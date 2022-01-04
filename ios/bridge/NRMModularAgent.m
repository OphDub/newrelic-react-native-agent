#import "NRMModularAgent.h"
#import <NewRelic/NewRelic.h>




@interface NewRelic (Private)
    + (bool) isAgentStarted:(SEL _Nonnull)callingMethod;
@end

@implementation NRMModularAgent

-(id)init {
    static dispatch_once_t predicate;

    dispatch_once(&predicate, ^{
    });
    return self;
}

+ (BOOL)requiresMainQueueSetup{
    return NO;
}

- (dispatch_queue_t)methodQueue{
    return dispatch_get_main_queue();
}

RCT_EXPORT_MODULE()

// Refer to https://facebook.github.io/react-native/docs/native-modules-ios for a list of supported argument types

RCT_EXPORT_METHOD(startAgent:(NSString* _Nonnull)appKey
                 startWithResolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject){
    NSLog(@"NRMA calling start agent for RN bridge is deprecated. The agent automatically starts on creation.");
    [NewRelic startWithApplicationToken: appKey];
    resolve(@(TRUE));
}


RCT_EXPORT_METHOD(isAgentStarted:(NSString* _Nonnull)call
                   callback: (RCTResponseSenderBlock)callback){
    callback(@[[NSNull null], @(TRUE)]);
}

RCT_EXPORT_METHOD(recordBreadcrumb:(NSString* _Nonnull)eventName attributes:(NSDictionary* _Nullable)attributes) {
    [NewRelic recordBreadcrumb:eventName attributes:attributes];
}

RCT_EXPORT_METHOD(setStringAttribute:(NSString* _Nonnull)key withString:(NSString* _Nonnull)value) {
    [NewRelic setAttribute:key value:value];
}

RCT_EXPORT_METHOD(setNumberAttribute:(NSString* _Nonnull)key withNumber:( NSNumber* _Nonnull)value) {
    [NewRelic setAttribute:key value:value];
}

RCT_EXPORT_METHOD(setBoolAttribute:(NSString* _Nonnull)key withBool:value) {
    [NewRelic setAttribute:key value:value];
}

RCT_EXPORT_METHOD(setUserId:(NSString* _Nonnull)userId) {
    [NewRelic setUserId:userId];
}

//RCT_EXPORT_METHOD(continueSession) {
//    [NewRelic continueSession];
//}

RCT_EXPORT_METHOD(setJSAppVersion:(NSString* _Nonnull)version) {
    [NewRelic setAttribute:@"JSAppVersion" value:version];
}

RCT_EXPORT_METHOD(nativeLog:(NSString* _Nonnull) name message:(NSString* _Nonnull) message) {
    NSDictionary *logs =  @{@"Name":name,@"Message": message};
    [NewRelic recordCustomEvent:@"Console Events" attributes:logs];
}


RCT_EXPORT_METHOD(recordCustomEvent:(NSString* _Nonnull) eventType eventName:(NSString* _Nullable)eventName eventAttributes:(NSDictionary* _Nullable)attributes) {
    // todo: Not sure if we need to check the validity of these arguments at all..
    [NewRelic recordCustomEvent:eventType name:eventName attributes:attributes];
}

RCT_EXPORT_METHOD(noticeHttpTransaction:(NSString* _Nonnull) url method:(NSString* _Nonnull)method statusCode:(NSInteger*)statusCode startTime:(NSUInteger* )startTime endTime:(NSUInteger*)endTime bytesSent:(NSUInteger* )bytesSent bytesReceived:(NSUInteger*)bytesReceived responseBody:(NSString* _Nullable)responseBody) {
    
    NSURL *nsurl = [NSURL URLWithString:url];

    [NewRelic noticeNetworkRequestForURL:nsurl httpMethod:method withTimer:NULL responseHeaders:NULL statusCode:*statusCode bytesSent:*bytesSent bytesReceived:*bytesReceived responseData:[responseBody dataUsingEncoding:NSUTF8StringEncoding] andParams:NULL];
    // todo: Not sure if we need to check the validity of these arguments at all..
  
}

RCT_EXPORT_METHOD(recordStack:(NSString* _Nullable) errorName
                  errorMessage:(NSString* _Nullable)errorMessage
                  errorStack:(NSString* _Nullable)errorStack
                  isFatal:(NSNumber* _Nonnull)isFatal
                  jsAppVersion:(NSString* _Nullable)jsAppVersion) {
    
    
    NSDictionary *dict =  @{@"Name":errorName,@"Message": errorMessage,@"isFatal": isFatal,@"jsAppVersion": jsAppVersion,@"errorStack": errorStack};
    
    [NewRelic recordCustomEvent:@"JS Errors" attributes:dict];

    
    
//    NRMAStackTrace* trace = [[NRMAStackTrace alloc] init];
//    trace.buildId = jsAppVersion;
//    trace.fatal = isFatal;
//    trace.stackType = ReactNative;
//    NRMAStackException* message = [NRMAStackException messageWithName:errorName reason:errorMessage];
//    trace.message  = message;
//    NRMAStack* stack = [[NRMAStack alloc] init];
//    stack.identifier = @"JS Thread";
//    stack.isThrowingThread = @YES;
//    NSArray* stackArray = [errorStack componentsSeparatedByString:@"\n"];
//    for (NSString* frameString in stackArray){
//        NRMAStackFrame* frame = [[NRMAStackFrame alloc] init];
//        frame.sourceLine = frameString;
//        [stack.stackFrames addObject:frame];
//    }
//
//    trace.occurrenceId = [NSUUID new].UUIDString;
//
//    [trace.stacks addObject:stack];
//
//    [NewRelic recordStack:trace];
}

@end
