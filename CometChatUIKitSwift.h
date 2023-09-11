//
//  CometChatUIKitSwift.h
//  CometChatUIKitSwift
//
//  Created by Admin on 06/09/23.
//

#import <Foundation/Foundation.h>

//! Project version number for CometChatUIKitSwiCometChatUIKitSwiftCallsCallsRT double CometChatUIKitSwiftVersionNumber;

//! Project version string for CometChatUIKitSwift.
FOUNDATION_EXPORT const unsigned char CometChatUIKitSwiftVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <CometChatUIKitSwift/PublicHeader.h>
//#import <CometChatUIKitSwift/CometChatCalls.h>
#if __has_include(<CometChatCallsSDK/CometChatCallsSDK.h>)
#define __HAS_SOME_MODULE_FRAMEWORK__
#import <CometChatCallsSDK/CometChatCallsSDK.h>
#endif

@interface CometChatUIKitSwiftCalls: NSObject

//#ifdef __HAS_SOME_MODULE_FRAMEWORK__
//@property (strong,nonatomic) CallSettingBuilder * callSettingsBuilder;
//#endif

//+(CometChatUIKitSwiftCalls *)sharedInstance;
+(id)callSettingsBuilderObject:(id)obj;
//-(void)setIsAudioOnly:(BOOL)value;
//-(BOOL)callsInstalled;
@end
