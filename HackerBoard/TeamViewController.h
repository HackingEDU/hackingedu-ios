//
//  TeamViewController.h
//  HackerBoard
//
//  Created by Blake Tsuzaki on 4/12/14.
//  Copyright (c) 2014 Swag. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TeamViewController : UIViewController <UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *searchField;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
- (IBAction)shareButtonPressed:(id)sender;
@end
