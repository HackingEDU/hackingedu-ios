//
//  AFTableViewCell.m
//  AFTabledCollectionView
//
//  Created by Ash Furrow on 2013-03-14.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

#import "AFTableViewCell.h"

@implementation AFTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (!(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) return nil;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //layout.sectionInset = UIEdgeInsetsMake(10, 10, 9, 10);
    layout.itemSize = CGSizeMake(240, 120);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionView = [[AFIndexedCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:CollectionViewCellIdentifier];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    [self.contentView addSubview:self.collectionView];
    
    return self;
}

-(void)setType:(NSInteger)type{
    self.collectionView.type = type;
}



-(void)layoutSubviews
{
    [super layoutSubviews];
    
    //self.collectionView.frame = self.contentView.bounds;
    self.collectionView.frame = CGRectMake(0, 20, 320, 140);
}

-(void)setCollectionViewDataSourceDelegate:(id<UICollectionViewDataSource, UICollectionViewDelegate>)dataSourceDelegate index:(NSInteger)index
{
    self.collectionView.dataSource = dataSourceDelegate;
    self.collectionView.delegate = dataSourceDelegate;
    self.collectionView.index = index;
    
    [self.collectionView reloadData];
}

@end
