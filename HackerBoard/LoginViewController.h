//
//  LoginViewController.h
//  HackerBoardv1
//
//  Created by Blake Tsuzaki on 4/12/14.
//  Copyright (c) 2014 Swag. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GithubAuthController.h"
#import <Parse/Parse.h>

@interface LoginViewController : UIViewController <GitAuthDelegate>
- (IBAction)skipLogin:(id)sender;
- (IBAction)signIn:(id)sender;

@end
