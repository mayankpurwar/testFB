//
//  ViewController.m
//  TestFB
//
//  Created by Apple on 5/19/14.
//  Copyright (c) 2014 Mayank Purwar. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Setting reference in app delegate for Facebook Login callback
    [(AppDelegate*)[UIApplication sharedApplication].delegate setLoginViewController:self];
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)ClickedRegisterBtn
{

        [self performSegueWithIdentifier:@"1" sender:self];
   }


-(IBAction)ClickedFBBtn
{
    [FBSession.activeSession closeAndClearTokenInformation];
    //    APP_DELEGATE.usingFB = 1;
//    if ([APP_DELEGATE isReachable:@"www.facebook.com"])
        //    if(APP_DELEGATE.netStatus)
    {
        if (FBSession.activeSession.isOpen)
        {
            [APP_DELEGATE GetFBInfo];
        }
        else
        {
            [APP_DELEGATE openSessionWithAllowLoginUI:YES];
        }
    }
}

@end
