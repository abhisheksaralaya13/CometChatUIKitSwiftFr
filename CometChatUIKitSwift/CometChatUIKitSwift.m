//
//  CometChatUIKitSwift.m
//  CometChatUIKitSwift
//
//  Created by Admin on 08/09/23.
//

#import <Foundation/Foundation.h>
#import "CometChatUIKitSwift.h"



@implementation CometChatUIKitSwiftCalls
id callSettingsBuilder;

//+(CometChatUIKitSwiftCalls *)sharedInstance {
//    static CometChatUIKitSwiftCalls *sharedInstance = nil;
//    static dispatch_once_t onceToken;
//        dispatch_once(&onceToken, ^{
//            sharedInstance = [[CometChatUIKitSwiftCalls alloc] init];
//            // Do any other initialisation stuff here
//            [sharedInstance callSettingsBuilderObject];
//        });
//        return sharedInstance;
//}

+(id)callSettingsBuilderObject:(id)obj {
    NSLog(@"qwertyqwertyqwerty1");
    if (obj) {
        NSLog(@"qwertyqwertyqwerty2");
        callSettingsBuilder = [[[[[[[[[[[[[[[[[obj callSettingsBuilder] setDefaultLayout:true] setIsAudioOnly:false] setIsSingleMode:true] setShowSwitchToVideoCall:false] setEnableVideoTileClick:true] setEnableDraggableVideoTile:true] setEndCallButtonDisable:false] setShowRecordingButton:false] setSwitchCameraButtonDisable:false] setMuteAudioButtonDisable:false] setPauseVideoButtonDisable:false] setAudioModeButtonDisable:false] setStartAudioMuted:false] setStartVideoMuted:false] setMode:@"DEFAULT"] setDefaultAudioMode:@"SPEAKER"];
        NSLog(@"qwertyqwertyqwerty2");
        return callSettingsBuilder;
    }
    return nil;
}

@end
