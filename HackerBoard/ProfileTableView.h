//
//  ProfileTableView.h
//  HackerBoard
//
//  Created by Blake Tsuzaki on 4/12/14.
//  Copyright (c) 2014 Swag. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileTableView : UITableView <UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate, UINavigationControllerDelegate>
- (void)loadView;
@end
