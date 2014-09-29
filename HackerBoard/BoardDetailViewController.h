//
//  BoardDetailViewController.h
//  HackerBoard
//
//  Created by Blake Tsuzaki on 4/12/14.
//  Copyright (c) 2014 Swag. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BoardDetailViewController : UIViewController
- (IBAction)doneButtonPressed:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *doneButton;

@end
