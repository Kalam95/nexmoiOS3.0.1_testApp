//
//  ViewController.swift
//  NexmoTest3.0.1
//
//  Created by Mehboob Alam on 10.02.23.
//

import UIKit
import Combine
import NexmoClient

class ViewController: UIViewController {
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var connectionStatus: UILabel!
    @IBOutlet weak var callTextField: UITextField!
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var hangupButton: UIButton!
    
    private var cancellable = Set<AnyCancellable>()
    
    private let viewModel = ClientManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        // Do any additional setup after loading the view.
    }
    
    func bindViewModel() {
        viewModel.$connectionStatus
            .receive(on: DispatchQueue.main)
            .assign(to: \.text!, on: connectionStatus)
            .store(in: &cancellable)
        
        viewModel.$callInvite
            .receive(on: DispatchQueue.main)
            .sink { caller in
                guard let caller = caller else { return }
                self.showCallAlert(caller: caller)
                }
            .store(in: &cancellable)
        viewModel.$error.receive(on: DispatchQueue.main).sink { error in
            guard let error = error else { return }
            self.showErrorAlert(error: error.localizedDescription)
            }
        .store(in: &cancellable)
        NotificationCenter.default
            .publisher(for: .pushKitHandlledCall)
            .receive(on: DispatchQueue.main)
            .sink { it in
                self.dismiss(animated: true)
            }.store(in: &cancellable)
    }
    
    func showCallAlert(caller: String) {
        let alert = UIAlertController(title: "Call Alert!!", message: "You have received a call from \(caller) ", preferredStyle: .alert)
        let actionAnswer = UIAlertAction(title: "Answer", style: .default) { _ in
            self.viewModel.answerCall()
        }
        let actionReject = UIAlertAction(title: "Reject", style: .destructive) { _ in
            self.viewModel.rejectCall()
        }
        alert.addAction(actionReject)
        alert.addAction(actionAnswer)
        present(alert, animated: true)
    }
    
    func showErrorAlert(error: String) {
        let alert = UIAlertController(title: "Error",
                                      message: error,
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    @IBAction func hangUpButtonTapped(_ sender: Any) {
        viewModel.hangupCall()
    }
    
    @IBAction func callButtonTapped(_ sender: Any) {
        let callee = callTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let callee = callee, !callee.isEmpty else {
            showErrorAlert(error: "Please enter call id or number")
            return
        }
        viewModel.startaCall(callee: callee)
    }
}

