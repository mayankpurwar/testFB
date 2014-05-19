//
//  AppDelegate.h
//  TestFB
//
//  Created by Apple on 5/19/14.
//  Copyright (c) 2014 Mayank Purwar. All rights reserved.
//

#import <FacebookSDK/FacebookSDK.h>

#import "ViewController.h"

#import <UIKit/UIKit.h>
#define FACEBOOK_APP_ID				@"1505903789629594"
#define FACEBOOK_APP_Secret         @"b5745c48b5a58cd3e7d906310a6643b8"
#define NOTIFY_FB_UPLOAD_START		@"FB_START"
#define NOTIFY_FB_UPLOAD_STOP		@"FB_STOP"
#define SETTINGS_FB_TOKEN			@"AccessToken"
#define SETTINGS_FB_EXPIRY			@"TokenExpiry"

#define APP_DELEGATE        ((AppDelegate *)[UIApplication sharedApplication].delegate)




@interface AppDelegate : UIResponder <UIApplicationDelegate>


@property (strong, nonatomic) UIWindow *window;



- (BOOL) isReachable:(NSString *)url;
-(void)GetFBInfo;
-(BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI;
@end
