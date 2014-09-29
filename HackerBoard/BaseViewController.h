//
//  BaseViewController.h
//  HackerBoard
//
//  Created by Blake Tsuzaki on 4/12/14.
//  Copyright (c) 2014 Swag. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFViewController.h"
@interface BaseViewController : UIViewController
@property (retain, nonatomic) IBOutlet AFViewController *tableView;
@property (strong, nonatomic) IBOutlet UIImageView *logoImage;
@property (strong, nonatomic) IBOutlet UIScrollView *bannerView;

@end
