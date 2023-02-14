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
    private let token = "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJNYXggTlBFIEFwcCIsImlhdCI6MTY3NjM4MDI3OCwibmJmIjoxNjc2MzgwMjc4LCJleHAiOjE2NzY0NzYzMDgsImp0aSI6MTY3NjM4MDMwODYwNiwiYXBwbGljYXRpb25faWQiOiI0ZmVkM2Q3YS0zZjY1LTQzNmQtODdkZC03NzUxMzk0YWE0MzMiLCJhY2wiOnsicGF0aHMiOnsiLyovdXNlcnMvKioiOnt9LCIvKi9jb252ZXJzYXRpb25zLyoqIjp7fSwiLyovc2Vzc2lvbnMvKioiOnt9LCIvKi9kZXZpY2VzLyoqIjp7fSwiLyovaW1hZ2UvKioiOnt9LCIvKi9tZWRpYS8qKiI6e30sIi8qL2FwcGxpY2F0aW9ucy8qKiI6e30sIi8qL3B1c2gvKioiOnt9LCIvKi9rbm9ja2luZy8qKiI6e30sIi8qL2NhbGxzLyoqIjp7fSwiLyovbGVncy8qKiI6e319fSwic3ViIjoiYWxhbSJ9.z3AmWO6Ye5-9nhe0NoEboaYNBfa--RwXNf1jAs7GkCAlWPQGq71XiC9mhod6DHchqNJWLTLpaDmrnF62n65Q7kJnLZYSMTg1jpvcDDONEHivcL8w5YTqqq7r1AXKnSvFV0JOoIi-4QCoYmWJou4z9oIk3NzO5B1gW8HL0KA3NNijT2_x9ZnoePKQJdrqX0hNxpihBRq-5ZchsBEEprgFPzvjvZFKhAyOvwOWSk0LMUIcB8seCIuXEBGHKEb4CP6V5a0oVTwdm5qkpu68mdHWaKun_tLM7-HhP8b3cwHMbeHY61geBh0X8A5vMLpIYiMqrb3TVhhqOZN83mIO2cGjmA"
    
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
        PushManager.shared.hangupCall()
    }
    
    func answerCall() {
        NotificationCenter.default.post(name: .alertHandlledCall, object: nil)
        call?.answer() {
            guard let error = $0 else { return }
            self.error = error
        }
    }
    
    func rejectCall() {
        NotificationCenter.default.post(name: .alertHandlledCall, object: nil)
        call?.answer() {
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
        self.callInvite = call.allMembers.first?.channel?.from.data ?? "Unknown"
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
