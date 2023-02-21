//
//  ViewModel.swift
//  NexmoTest3.0.1
//
//  Created by Mehboob Alam on 10.02.23.
//

import Foundation
import Combine
import CallKit
import NexmoClient
import AVFoundation

class ClientManager: NSObject {
    static let shared = ClientManager()
    
    private let client: NXMClient
    @Published var name: String = ""
    @Published private(set) var callInvite: String?
    private(set) var call: NXMCall?
    @Published private(set) var error: Error? = nil
    @Published var connectionStatus: String = "Not Connected"
    private var callee: String = ""
    private let token = ""
    
    private override init () {
        NXMClient.setConfiguration(.init(apiUrl: "https://api.nexmo.com/",
                                         websocketUrl: "https://ws.nexmo.com/",
                                         ipsUrl: "https://api.nexmo.com/v1/image/",
                                         iceServerUrls: ["stun:stun.l.google.com:19302"],
                                         useFirstIceCandidate: true))
        client =  NXMClient.shared
        super.init()
        client.setDelegate(self)
    }
    
    func login() {
        client.login(withAuthToken: token)
    }
    
    func hangupCall() {
        call?.hangup()
        call = nil
        PushManager.shared.hangupCall()
    }
    
    func answerCall() {
        NotificationCenter.default.post(name: .alertHandlledCall, object: nil)
        call?.answer {
            guard let error = $0 else { return }
            self.error = error
        }
    }
    
    func rejectCall() {
        NotificationCenter.default.post(name: .alertHandlledCall, object: nil)
        call?.reject {
            guard let error = $0 else { return }
            self.error = error
        }
    }
    
    func startCallKitCall(callee: String) {
        self.callee = callee
        PushManager.shared.startCallKitCall(callee: callee)
    }

    func startaCall() {
        client.call(callee, callHandler: .server) { error, call in
            guard let call = call else {
                self.error = error
                return
            }
            call.setDelegate(self)
            self.call = call
            PushManager.shared.update(call: call)
        }
    }
    
    func processPush(payload: [AnyHashable:Any]) -> NXMPushPayload? {
        client.processNexmoPushPayload(payload)
    }
    
    func isNexmoPush(payload: [AnyHashable:Any]) -> Bool {
        client.isNexmoPush(userInfo: payload)
    }
}

extension ClientManager: NXMClientDelegate {
    func client(_ client: NXMClient, didChange status: NXMConnectionStatus, reason: NXMConnectionStatusReason) {
        switch status {
        case .disconnected:
            connectionStatus = "Disconnected"
        case .connecting:
            connectionStatus = "Connecting"
        case .connected:
            connectionStatus = "Connected"
            PushManager.shared.sendPushTokens()
            PushManager.shared.processPushInfo()
            name = client.user?.name ?? "unknown"
        @unknown default:
            connectionStatus = "Unknown"
        }
        
    }
    
    func client(_ client: NXMClient, didReceiveError error: Error) {
        self.error = error
    }
    
    func client(_ client: NXMClient, didReceive call: NXMCall) {
        var caller = call.allMembers
            .filter { $0.memberUuid != call.myMember?.memberUuid }
            .compactMap { $0.user.name }
            .joined(separator: ", ")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        if caller.isEmpty || caller == "," {
            caller = "unknown"
        }
        callInvite = caller
        self.call = call
        PushManager.shared.update(call: call)
        call.setDelegate(self)
        setAudioSettings()
    }
    
    func client(_ client: NXMClient, didReceive conversation: NXMConversation) {
        
    }

    func setAudioSettings() {
        try! AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.voiceChat, options: .allowBluetooth)
        let mediaType = AVMediaType.audio
        let authorizationStatus = AVCaptureDevice.authorizationStatus(for: mediaType)
        AVAudioSession.sharedInstance().requestRecordPermission { (granted:Bool) in
                NSLog("Allow microphone use. Response: %d", granted)
            }
        print("🎤 status: \(authorizationStatus.rawValue)")
        switch authorizationStatus {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: mediaType) { granted in
                print("🎤 access \(granted ? "granted" : "denied")")
            }
        default: break
        }
    }
}

extension ClientManager: NXMCallDelegate {
    
    func call(_ call: NXMCall, didUpdate member: NXMMember, with status: NXMCallMemberStatus) {
        switch status {
        case .failed, .cancelled,.completed, .rejected, .timeout:
            self.call = nil
            hangupCall()
        default: break
        }
        print("call status: \(status) for member: \(member.user.name)")
    }
    
    func call(_ call: NXMCall, didUpdate member: NXMMember, isMuted muted: Bool) {
        print("mute status: \(muted) for member: \(member.user.name)")
    }
    
    func call(_ call: NXMCall, didReceive error: Error) {
        self.error = error
        print("error is received \(error.localizedDescription)")
    }
    
    func call(_ call: NXMCall, didReceive dtmf: String, from member: NXMMember?) {
        
    }
}
