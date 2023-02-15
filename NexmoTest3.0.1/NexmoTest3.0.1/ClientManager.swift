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
    @Published private(set) var callInvite: String?
    private(set) var call: NXMCall?
    @Published private(set) var error: Error? = nil
    @Published var connectionStatus: String = "Not Connected"
    private let token = "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJNYXggTlBFIEFwcCIsImlhdCI6MTY3NjQ2MzkyNCwibmJmIjoxNjc2NDYzOTI0LCJleHAiOjE2NzY1NTk5NTQsImp0aSI6MTY3NjQ2Mzk1NDU2MSwiYXBwbGljYXRpb25faWQiOiI0ZmVkM2Q3YS0zZjY1LTQzNmQtODdkZC03NzUxMzk0YWE0MzMiLCJhY2wiOnsicGF0aHMiOnsiLyovdXNlcnMvKioiOnt9LCIvKi9jb252ZXJzYXRpb25zLyoqIjp7fSwiLyovc2Vzc2lvbnMvKioiOnt9LCIvKi9kZXZpY2VzLyoqIjp7fSwiLyovaW1hZ2UvKioiOnt9LCIvKi9tZWRpYS8qKiI6e30sIi8qL2FwcGxpY2F0aW9ucy8qKiI6e30sIi8qL3B1c2gvKioiOnt9LCIvKi9rbm9ja2luZy8qKiI6e30sIi8qL2NhbGxzLyoqIjp7fSwiLyovbGVncy8qKiI6e319fSwic3ViIjoiYWxhbSJ9.DcHmy_ksL4k4W3PQj9eHA3BES-8oEhRfclq30FJUK6Ji4AitQScRztOQZdyaMnS89gGnw2_uueAqBAKZ95WQCtMGQTFOcwFOhOdq6XJdj25qaAz9aNWZu0Voh6zX--JFJ1BqPd2bJoAwybWfyuEAKuTwKl2Uobbuc46gJ9w-dUZAeMHkwBlYSNChudysOo2p7zuZJFVHXTgP-UfpgaJTFJRAEEkSKH3aOjK-zBK-860HhRyRypyzJ0czn366UX-oMW21DKnuCGu1RDpq3d3hGQfsb7wNvVSjE5kXgrU89JE8MUudKsNvw5yE35AJ8GM46k8_mRoXByO-ImigkMmPEw"
    
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
    
    func startaCall(callee: String) {
        client.call(callee, callHandler: .inApp) { error, call in
            guard let call = call else {
                self.error = error
                return
            }
            call.setDelegate(self)
            self.call = call
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
        
    }
    
    func call(_ call: NXMCall, didUpdate member: NXMMember, isMuted muted: Bool) {
        
    }
    
    func call(_ call: NXMCall, didReceive error: Error) {
        self.error = error
    }
    
    func call(_ call: NXMCall, didReceive dtmf: String, from member: NXMMember?) {
        
    }
}
