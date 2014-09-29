//
//  UserSearchViewController.h
//  HackerBoard
//
//  Created by Blake Tsuzaki on 4/13/14.
//  Copyright (c) 2014 Swag. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserSearchViewController : UIViewController
- (IBAction)closeButtonPressed:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *closeButton;
@property (strong, nonatomic) IBOutlet UIImageView *userImage;
@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *secondLabel;
- (IBAction)addToTeam:(id)sender;

@end
