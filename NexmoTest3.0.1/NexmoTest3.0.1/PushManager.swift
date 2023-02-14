//
//  PushManager.swift
//  NexmoTest3.0.1
//
//  Created by Mehboob Alam on 13.02.23.
//

import Foundation
import PushKit
import CallKit
import UserNotifications
import NexmoClient
import Combine

class PushManager: NSObject {
    
    let voipRegistry = PKPushRegistry(queue: nil)
    private var voipToken: Data?
    private var userNotificationToken: Data?
    private var callProvider: CXProvider
    private let callController = CXCallController()
    private var call: NXMCall?
    private var uuid: UUID!
    private var cancellable: AnyCancellable!
    private var pushInfo: [AnyHashable: Any]?
    var providerConfiguration: CXProviderConfiguration = {
        let providerConfiguration = CXProviderConfiguration()
        providerConfiguration.supportsVideo = false
        providerConfiguration.maximumCallsPerCallGroup = 1
        providerConfiguration.supportedHandleTypes = [.generic]
        return providerConfiguration
    }()
    static let shared: PushManager = .init()
    
    private override init() {
        self.callProvider = .init(configuration: providerConfiguration)
        super.init()
        cancellable = NotificationCenter.default
            .publisher(for: .alertHandlledCall)
            .receive(on: DispatchQueue.main)
            .sink { _ in
                self.callProvider.invalidate()
                self.callProvider = CXProvider(configuration: .init())
            }
        callProvider.setDelegate(self, queue: nil)

    }
    
    
    func registerForPush() {
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.badge,.sound]) { isGranted, error in
            if isGranted {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            } else {
                print("failed for remote notications")
            }
        }
        registerForVoIPPush()
    }
    
    private func registerForVoIPPush() {
        self.voipRegistry.delegate = self
        self.voipRegistry.desiredPushTypes = [PKPushType.voIP]
        
    }
    
    func setUserNotificationToken(data: Data?) {
        self.userNotificationToken = data
    }
    
    func update(call: NXMCall) {
        self.call = call
    }
    
    func processPushInfo() {
        guard let pushInfo = pushInfo else { return }
        guard let _ = ClientManager.shared.processPush(payload: pushInfo) else { return }
    }
    
    func sendPushTokens() {
//        NXMClient.shared.enablePushNotifications(withPushKitToken: voipToken, userNotificationToken: userNotificationToken, isSandbox: true) { error in
//            print("push registration has \(error == nil ? "been successful" : "been failed with")", error ?? "")
//        }
    }
    
}


extension PushManager: PKPushRegistryDelegate {
    func pushRegistry(_ registry: PKPushRegistry, didUpdate pushCredentials: PKPushCredentials, for type: PKPushType) {
        if type == .voIP {
            voipToken = pushCredentials.token
            print("Voip: \(voipToken?.hexString ?? "dfd")")
        }
    }
    
    func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith
                      payload: PKPushPayload, for type: PKPushType, completion: @escaping () -> Void) {
        self.pushInfo = payload.dictionaryPayload
        uuid = UUID()
        let update = CXCallUpdate()
        update.localizedCallerName = "Unknown"
        callProvider.reportNewIncomingCall(with: uuid, update: update) { error in
            print(error?.localizedDescription ?? "Call reported")
            if error == nil {
                completion()
            }
        }
    }
    
    func hangupCall() {
        guard let uuid = uuid else { return }
        let action = CXEndCallAction(call: uuid)
        let transaction = CXTransaction(action: action)
        
        callController.request(transaction) { error in
            if let error = error {
                print(error)
            }
        }
    }
}

extension PushManager: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
    }
}

extension PushManager: CXProviderDelegate {
    func providerDidReset(_ provider: CXProvider) {
        callProvider = provider
        callProvider.setDelegate(self, queue: nil)
    }

    func provider(_ provider: CXProvider, perform action: CXStartCallAction) {
        action.fulfill()
    }

    func provider(_ provider: CXProvider, perform action: CXAnswerCallAction) {
        call?.answer()
        print("call answered", call ?? "no call")
        NotificationCenter.default.post(name: .pushKitHandlledCall, object: nil)
        action.fulfill()
    }

    func provider(_ provider: CXProvider, perform action: CXEndCallAction) {
        call?.reject()
        NotificationCenter.default.post(name: .pushKitHandlledCall, object: nil)
        action.fulfill()
    }
}


extension Data {
    var hexString: String {
        let hexString = map { String(format: "%02.2hhx", $0) }.joined()
        return hexString
    }
}

extension Notification.Name {
    static let pushKitHandlledCall = Self.init("call_handelled_by_callkit")
    static let alertHandlledCall = Self.init("call_handelled_by_alert")
}
