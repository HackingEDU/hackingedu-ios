//
//  AFViewController.h
//  AFTabledCollectionView
//
//  Created by Ash Furrow on 2013-03-14.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AFViewController : UITableView <UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate, UINavigationControllerDelegate>
-(void)loadView;

@end
