//
//  AppDelegate.m
//  TestFB
//
//  Created by Apple on 5/19/14.
//  Copyright (c) 2014 Mayank Purwar. All rights reserved.
//

#import "AppDelegate.h"
NSString *const FBSessionStateChangedNotification = @"com.example.Login:FBSessionStateChangedNotification";

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

//- (BOOL) isReachable:(NSString *)url
//{
//    Reachability* reach = [Reachability reachabilityWithHostName:url];
//    if ([reach isReachable])
//    {
//        return YES;
//    } else
//    {
//        return NO;
//    }
//    return NO;
//}



- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    switch (state) {
        case FBSessionStateOpen:
            if (!error) {
                // We have a valid session
                NSLog(@"User session found");
                //                if(usingFB ==1)
                {
                    [self GetFBInfo];
                }
                //                else if(usingFB == 2)
                //                {
                //                    [objRecipentViewController FBClicked];
                //                }
                //                else if(usingFB == 3)
                //                {
                //                    [self postWallOnFacebook];
                //                }
                //
                //                usingFB = 0;
                
                //                [self postWallOnFacebook];
            }
            break;
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed:
            [FBSession.activeSession closeAndClearTokenInformation];
            break;
        default:
            break;
    }
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:FBSessionStateChangedNotification
     object:session];
    
    if (error) {
        
        
        NSLog(@"Error");
        NSString *alertText = @"1";
        NSString *alertTitle;
        // If the error requires people using an app to make an action outside of the app in order to recover
        if ([FBErrorUtility shouldNotifyUserForError:error] == YES){
            alertTitle = @"Something went wrong";
            alertText = [FBErrorUtility userMessageForError:error];
            [self showMessage:alertText withTitle:alertTitle];
        } else {
            
            // If the user cancelled login, do nothing
            if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
                NSLog(@"User cancelled login");
                
                // Handle session closures that happen outside of the app
            } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession){
                alertTitle = @"Session Error";
                alertText = @"Your current session is no longer valid. Please log in again.";
                [self showMessage:alertText withTitle:alertTitle];
                
                // Here we will handle all other errors with a generic error message.
                // We recommend you check our Handling Errors guide for more information
                // https://developers.facebook.com/docs/ios/errors/
            } else {
                //Get more error information from the error
                NSDictionary *errorInformation = [[[error.userInfo objectForKey:@"com.facebook.sdk:ParsedJSONResponseKey"] objectForKey:@"body"] objectForKey:@"error"];
                
                // Show the user an error message
                alertTitle = @"Something went wrong";
                alertText = [NSString stringWithFormat:@"Please retry. \n\n If the problem persists contact us and mention this error code: %@", [errorInformation objectForKey:@"message"]];
                [self showMessage:alertText withTitle:alertTitle];
            }
        }
        
        NSLog(@"%@",alertText);
        // Clear this token
        [FBSession.activeSession closeAndClearTokenInformation];
        // Show the user the logged-out UI
        //        [self userLoggedOut];
        
        //        NSLog(@"%@",error.localizedDescription);
        //
        //
        //        UIAlertView *alertView = [[UIAlertView alloc]
        //                                  initWithTitle:@"Error"
        //                                  message:@"Cannot connect to Facebook at the moment, please try again later."
        //                                  delegate:nil
        //                                  cancelButtonTitle:@"OK"
        //                                  otherButtonTitles:nil];
        //        [alertView show];
    }
}




-(void)showMessage:(NSString *)message withTitle:(NSString *)title
{
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:title
                              message:message
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
    [alertView show];
    
}










/*
 * Opens a Facebook session and optionally shows the login UX.
 */

- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI {
    NSArray *permissions = [[NSArray alloc] initWithObjects:@"user_location",@"email",nil] ;
    return [FBSession openActiveSessionWithReadPermissions:permissions
                                              allowLoginUI:YES
                                         completionHandler:
            ^(FBSession *session,
              FBSessionState state, NSError *error) {
                [self sessionStateChanged:session state:state error:error];
            }];
}
#pragma mark -




// Convenience method to perform some action that requires the "publish_actions" permissions.
- (void) performPublishAction:(void (^)(void)) action {
    // we defer request for permission to post to the moment of post, then we check for the permission
    if ([FBSession.activeSession.permissions indexOfObject:@"publish_actions"] == NSNotFound) {
        // if we don't already have the permission, then we request it now
        [FBSession.activeSession requestNewPublishPermissions:[NSArray arrayWithObjects:@"publish_actions",nil]
                                              defaultAudience:FBSessionDefaultAudienceFriends
                                            completionHandler:^(FBSession *session, NSError *error) {
                                                if (!error) {
                                                    action();
                                                }
                                                //For this example, ignore errors (such as if user cancels).
                                            }];
    } else {
        NSLog(@"Action");
        action();
    }
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url2 sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    // attempt to extract a token from the url
    
    NSLog(@"Facebook application openURL %@.",url2);
    
    return [FBSession.activeSession handleOpenURL:url2];
}



//-(void)postWallOnFacebook{
//
//    NSMutableDictionary *params;
//    params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
//              @"Salutation", @"name",
//              self.objSalInfo1ViewController.salVideoLink1, @"source",
//              @"Salutation", @"message", nil];
//
//    FBRequest *request = [FBRequest requestWithGraphPath:@"me/feed" parameters:params HTTPMethod:@"POST"];
//    [self performPublishAction:^{
//        [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
//            NSLog(@"result: %@, error: %@", result, error);
//            [self showAlert:@"" result:result error:error];
//        }];
//    }];
//}

-(void)GetFBInfo
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        //        [APP_DELEGATE removePopup:self.objViewController.view];
        //        [APP_DELEGATE addPopup:YES :@"Getting FB info..." :@"" :self.objViewController.view];
    });
    
    [[FBRequest requestForMe] startWithCompletionHandler:
     ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
         dispatch_async(dispatch_get_main_queue(), ^{
             //             [APP_DELEGATE removePopup:self.objViewController.view];
         });
         if (!error) {
             //             [[NSUserDefaults standardUserDefaults] setObject:[FBSession activeSession].accessTokenData forKey:@"FACEBOOK_ACCESS_TOKEN"];
             [[NSUserDefaults standardUserDefaults] setObject:[user objectForKey:@"email"] forKey:@"FACEBOOK_EMAIL"];
             [[NSUserDefaults standardUserDefaults] setObject:user.username forKey:@"FACEBOOK_USER_NAME"];
             [[NSUserDefaults standardUserDefaults] setObject:user.name forKey:@"FACEBOOK_FULL_NAME"];
             [[NSUserDefaults standardUserDefaults] setObject:user.first_name forKey:@"FACEBOOK_FIRST_NAME"];
             [[NSUserDefaults standardUserDefaults] setObject:user.last_name forKey:@"FACEBOOK_LAST_NAME"];
             dispatch_async(dispatch_get_main_queue(), ^{
                 //             [self.objViewController ClickedRegister];
                 NSLog(@"%@",user.id);
                 NSLog(@"%@",user);
//                 [ViewController performSegueWithIdentifier:@"your_storyboard_identifier" sender:nil]
                 ViewController *login = [ViewController alloc];
                 //                 [login ClickedRegisterBtn];
                 
                 
                 
//                 
//                 UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//                 ViewController *login = [storyBoard instantiateViewControllerWithIdentifier:@"login"];
                 [login performSegueWithIdentifier:@"1" sender:login];
                 //                 [login ClickedRegisterBtn];
                 
                 
                 //                 APP_DELEGATE.objRegisterView.strName = user.name;
                 //                 APP_DELEGATE.objRegisterView.strEmail = [user objectForKey:@"email"];
                 
                 NSLog(@"[FBSession activeSession].accessToken:%@, Facebook email:%@, user.username :%@, user.name:%@, user.first_name:%@, user.last_name:%@",[FBSession activeSession].accessTokenData.accessToken,[user objectForKey:@"email"],user.username,user.name,user.first_name, user.last_name);
                 
                 
             });
         }
         else
         {
             UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:error.localizedDescription delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil , nil];
             [alert show];
         }
         
     }];
}

// UIAlertView helper for post buttons
- (void)showAlert:(NSString *)message
           result:(id)result
            error:(NSError *)error {
    
    NSString *alertMsg;
    NSString *alertTitle;
    
    if (error)
    {
        alertMsg = @"Please remove old Salutation 365 application from your Facebook account then try again.";
        //        alertTitle = @"Error";
        alertTitle = nil;
    }
    else
    {
        alertMsg = [NSString stringWithFormat:@"Successfully posted"];
        alertTitle = @"";
    }
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alertTitle
                                                        message:alertMsg
                                                       delegate:nil
                                              cancelButtonTitle:@"Dismiss"
                                              otherButtonTitles:nil];
    [alertView show];
}


@end
