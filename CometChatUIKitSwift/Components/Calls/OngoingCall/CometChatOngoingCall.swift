//
//  CometChatOngoingCall.swift
//  
//
//  Created by Pushpsen Airekar on 07/03/23.
//

import UIKit
import CometChatSDK
#if canImport(CometChatCallsSDK)

public enum CallWorkFlow {
    case defaultCalling
    case directCalling
}

open class CometChatOngoingCall: UIViewController {

    @IBOutlet weak var container: UIView!
    var viewModel : OngoingCallViewModel?
    var onCallEnded: ((_ call: Call) -> Void)?
    var sessionId: String?
    private var callSettingsBuilder: Any?
    private var callWorkFlow: CallWorkFlow?
    
    public override func loadView() {
        let loadedNib = CometChatUIKit.bundle.loadNibNamed(String(describing: Swift.type(of: self)), owner: self, options: nil)
        if let contentView = loadedNib?.first as? UIView {
            contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.view  = contentView
        }
    }
    
     open override func viewDidLoad() {
        super.viewDidLoad()
         startCall()
         
         
     }
    
    private func handleCall() {
        
        guard let viewModel = viewModel else { return }
        viewModel.onCallEnded = {
//            self.onCallEnded?(call)
            DispatchQueue.main.async {
                self.dismiss(animated: true)
            }
        }
        viewModel.onError = {  _ in
            DispatchQueue.main.async {
                self.dismiss(animated: true)
            }
        }
    }
    
    private func startCall() {
        guard let sessionId = sessionId else { return }
        viewModel = OngoingCallViewModel(callView: self.container, sessionId: sessionId)
        if let callWorkFlow = callWorkFlow {
            viewModel?.set(callWorkFlow: callWorkFlow)
        }
        print("callSettingsBuilder-1",callSettingsBuilder)
        if CallingDefaultBuilder.callSettingsBuilder != nil {
            print("CallingDefaultBuilder.callSettingsBuilder-4")
        } else {
                print("CallingDefaultBuilder.callSettingsBuilder-4 is nil")
        }
        if let callSettingsBuilder = callSettingsBuilder as? CometChatCallsSDK.CallSettingsBuilder {
            print("callSettingsBuilder-2",callSettingsBuilder)
            viewModel?.set(callSettingsBuilder: callSettingsBuilder)
        }
        handleCall()
        viewModel?.startCall()
    }
}

extension CometChatOngoingCall {
    
    @discardableResult
    public func set(sessionId: String) -> Self {
        self.sessionId = sessionId
        return self
    }
    
    @discardableResult
    public func set(callSettingsBuilder: Any?) -> Self {
        if CallingDefaultBuilder.callSettingsBuilder != nil {
            print("CallingDefaultBuilder.callSettingsBuilder-5",callSettingsBuilder)
        } else {
                print("CallingDefaultBuilder.callSettingsBuilder-5 is nil",callSettingsBuilder)
        }
        self.callSettingsBuilder = callSettingsBuilder
        return self
    }
    
    @discardableResult
    public func set(callWorkFlow: CallWorkFlow) -> Self {
        self.callWorkFlow = callWorkFlow
        return self
    }
    
    @discardableResult
    public func setOnCallEnded(onCallEnded: @escaping ((_ call: Call) -> Void)) -> Self {
        self.onCallEnded = onCallEnded
        return self
    }
}
#endif
