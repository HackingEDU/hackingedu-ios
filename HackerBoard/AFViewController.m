//
//  AFViewController.m
//  AFTabledCollectionView
//
//  Created by Ash Furrow on 2013-03-14.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

#import "AFViewController.h"
#import "AFIndexedCollectionView.h"
#import "AFTableViewCell.h"
#import "BoardDetailViewController.h"
#import "InfoCard.h"
#import <Parse/Parse.h>

@interface AFViewController (){
    int i;
}

@property (nonatomic, strong) NSArray *colorArray;
@property (nonatomic, strong) NSMutableDictionary *contentOffsetDictionary;
@property (nonatomic, strong) NSArray *labels;
@property (nonatomic, strong) NSMutableArray *announcements;
@end

@implementation AFViewController

-(void)loadView
{
    i = 0;
    self.labels = [[NSArray alloc] initWithObjects:@"Announcements",@"Projects",@"People", nil];
    self.announcements = [[NSMutableArray alloc] init];
    PFQuery *announcementQuery = [[PFQuery alloc] initWithClassName:@"Announcements"];
    [self.announcements addObject:[announcementQuery findObjects]];
    PFQuery *projectQuery = [[PFQuery alloc] initWithClassName:@"Projects"];
    [self.announcements addObject:[projectQuery findObjects]];
    
    const NSInteger numberOfTableViewRows = 4;
    const NSInteger numberOfCollectionViewCells = 15;
    
    NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:numberOfTableViewRows];
    
    for (NSInteger tableViewRow = 0; tableViewRow < numberOfTableViewRows; tableViewRow++)
    {
        NSMutableArray *colorArray = [NSMutableArray arrayWithCapacity:numberOfCollectionViewCells];
        
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
        [sectionLabel setText:[self.labels objectAtIndex:i]];
        [cell addSubview:sectionLabel];
        i++;
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
    if(collectionView.index <3)
        return [[self.announcements objectAtIndex:collectionView.index-1] count];
    else return [collectionViewArray count];
}

-(UICollectionViewCell *)collectionView:(AFIndexedCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CollectionViewCellIdentifier forIndexPath:indexPath];
    NSArray *collectionViewArray = self.colorArray[collectionView.index];
    cell.backgroundColor = collectionViewArray[indexPath.item];
    
    if(collectionView.index <3){
        NSArray *stringArray = [self.announcements objectAtIndex:(collectionView.index-1)];
        UITextView *label  = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 240, 120)];
        [label setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.2]];
        [label setUserInteractionEnabled:NO];
        [label setEditable:NO];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setFont:[UIFont fontWithName:@"Helvetica Light" size:14]];
        if(collectionView.index ==1)
            [label setText:[[stringArray objectAtIndex:indexPath.row] objectForKey:@"Message"]];
        else if(collectionView.index == 2)
            [label setText:[[stringArray objectAtIndex:indexPath.row] objectForKey:@"project_name"]];
        [cell.contentView addSubview:label];
        NSLog(@"Printed %@", label.text);
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

/*
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0,0,tableView.frame.size.width,30)];
 
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, headerView.frame.size.width-120.0, headerView.frame.size.height)];
    
    headerLabel.textAlignment = NSTextAlignmentRight;
    headerLabel.text = @"OHAI";
    headerLabel.backgroundColor = [UIColor whiteColor];
    [self sendSubviewToBack:headerView];
    [headerView addSubview:headerLabel];
 
    [self sendSubviewToBack:headerView];
    
    return headerView;
    
}
*/
/*
-(float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return  200.0;
}
*/
@end
