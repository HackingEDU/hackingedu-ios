//
//  ProfileTableView.m
//  HackerBoard
//
//  Created by Blake Tsuzaki on 4/12/14.
//  Copyright (c) 2014 Swag. All rights reserved.
//

#import "ProfileTableView.h"
#import "AFIndexedCollectionView.h"
#import "AFTableViewCell.h"
#import <Parse/Parse.h>

@interface ProfileTableView()
@property (nonatomic, strong) NSArray *colorArray;
@property (nonatomic, strong) NSMutableDictionary *contentOffsetDictionary;
@property (nonatomic, strong) NSArray *labels;
@property (nonatomic, strong) NSMutableArray *data;
@end

@implementation ProfileTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)loadView
{
    self.data = [[NSMutableArray alloc] init];
    
    self.labels = [[NSArray alloc] initWithObjects:@"Awards",@"Projects",@"Skills", nil];
    const NSInteger numberOfTableViewRows = 4;
    const NSInteger numberOfCollectionViewCells = 15;
    
    NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:numberOfTableViewRows];
    
    for (NSInteger tableViewRow = 0; tableViewRow < numberOfTableViewRows; tableViewRow++)
    {
        NSMutableArray *colorArray = [[NSMutableArray alloc] init];
        
        for (NSInteger collectionViewItem = 0; collectionViewItem < numberOfCollectionViewCells; collectionViewItem++)
        {
            
            CGFloat red = arc4random() % 255;
            CGFloat green = arc4random() % 255;
            CGFloat blue = arc4random() % 255;
            UIColor *color = [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1.0f];
            
            [colorArray addObject:color];
        }
        
        [mutableArray addObject:colorArray];
    }
    [self setPagingEnabled:YES];
    [self setShowsVerticalScrollIndicator:NO];
    self.colorArray = [NSArray arrayWithArray:mutableArray];
    self.contentOffsetDictionary = [NSMutableDictionary dictionary];
    
    [self setBackgroundColor:[UIColor clearColor]];
    
}

#pragma mark - UITableViewDataSource Methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.colorArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    
    if (indexPath.row == 0){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell setSelectionStyle:UITableViewCellEditingStyleNone];
        [cell setBackgroundColor:[UIColor clearColor]];
        return cell;
    }
    
    AFTableViewCell *cell = (AFTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
    {
        cell = [[AFTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell setSelectionStyle:UITableViewCellEditingStyleNone];
        [cell setBackgroundColor:[UIColor colorWithWhite:1 alpha:1]];
        [cell setType:indexPath.row-1];
        UILabel *sectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 310, 30)];
        [sectionLabel setFont:[UIFont fontWithName:@"Helvetica Light" size:14.0]];
        [sectionLabel setTextColor:[UIColor blackColor]];
        [sectionLabel setText:[self.labels objectAtIndex:indexPath.row-1]];
        [cell addSubview:sectionLabel];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(AFTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row != 0){
        [cell setCollectionViewDataSourceDelegate:self index:indexPath.row];
        NSInteger index = cell.collectionView.index;
        
        CGFloat horizontalOffset = [self.contentOffsetDictionary[[@(index) stringValue]] floatValue];
        [cell.collectionView setContentOffset:CGPointMake(horizontalOffset, 0)];
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        [self setContentOffset:CGPointMake(0, -200) animated:YES];
    }
}
#pragma mark - UITableViewDelegate Methods

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row != 0)
        return 160;
    else
        return 200;
}

#pragma mark - UICollectionViewDataSource Methods

-(NSInteger)collectionView:(AFIndexedCollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSArray *collectionViewArray = self.colorArray[collectionView.index];
    return collectionViewArray.count;
}

-(UICollectionViewCell *)collectionView:(AFIndexedCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CollectionViewCellIdentifier forIndexPath:indexPath];
    
    NSArray *collectionViewArray = self.colorArray[collectionView.index];
    cell.backgroundColor = collectionViewArray[indexPath.item];
    if(collectionView.index == 1){
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"star.png"]];
        [imageView setFrame:CGRectMake(10, 10, 70, 70)];
        [cell.contentView addSubview:imageView];
    }
    
    return cell;
}
- (void)collectionView:(AFIndexedCollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:collectionView.type] forKey:@"Type"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:indexPath.row] forKey:@"Object"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"BaseDetail" object:self];
}

#pragma mark - UIScrollViewDelegate Methods

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (![scrollView isKindOfClass:[AFIndexedCollectionView class]]) return;
    
    CGFloat horizontalOffset = scrollView.contentOffset.x;
    
    AFIndexedCollectionView *collectionView = (AFIndexedCollectionView *)scrollView;
    NSInteger index = collectionView.index;
    self.contentOffsetDictionary[[@(index) stringValue]] = @(horizontalOffset);
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if ([scrollView isKindOfClass:[AFIndexedCollectionView class]]){
        CGPoint bottomOffset = CGPointMake(0, self.contentSize.height - self.bounds.size.height);
        [self setContentOffset:bottomOffset animated:YES];
        [self setPagingEnabled:NO];
    }
}

-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    if([scrollView isKindOfClass:[self class]]){
        [self setPagingEnabled:YES];
        if (scrollView.contentOffset.y<-90.0)
            [self setContentInset:UIEdgeInsetsMake(200, 0, 0, 0)];
    }
}

@end
