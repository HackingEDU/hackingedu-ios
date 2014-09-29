//
//  ProfileViewController.h
//  HackerBoard
//
//  Created by Blake Tsuzaki on 4/12/14.
//  Copyright (c) 2014 Swag. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfileTableView.h"

@interface ProfileViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIScrollView *backgroundView;
@property (strong, nonatomic) IBOutlet UIImageView *profileImageView;
@property (retain, nonatomic) IBOutlet ProfileTableView *tableView;
@end
