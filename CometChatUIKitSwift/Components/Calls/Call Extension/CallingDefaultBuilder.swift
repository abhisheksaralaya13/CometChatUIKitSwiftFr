//
//  File.swift
//  
//
//  Created by Admin on 01/08/23.
//

import Foundation
#if canImport(CometChatCallsSDK)

public class CallingDefaultBuilder {
    public static var callSettingsBuilder = CometChatUIKitSwiftCalls.callSettingsBuilderObject(NSClassFromString("CometChatCallsSDK.CometChatCalls"))
    
    public static func setIsAudioOnly(_ value: Bool) {
        if let cls: AnyClass = NSClassFromString("CometChatCallsSDK.CometChatCalls") {
            cls.callSettingsBuilder.setIsAudioOnly(value)
        }
    }
    
    public static func callsInstalled() -> Bool {
        if NSClassFromString("CometChatCallsSDK.CometChatCalls") != nil {
            return true
        }
        return false
    }
}
#endif
