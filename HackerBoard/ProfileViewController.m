//
//  ProfileViewController.m
//  HackerBoard
//
//  Created by Blake Tsuzaki on 4/12/14.
//  Copyright (c) 2014 Swag. All rights reserved.
//

#import "ProfileViewController.h"
#import "AFTableViewCell.h"
#import "AFIndexedCollectionView.h"
#import "UIImage+RoundedImage.h"

@interface ProfileViewController (){
    BOOL moveRight;
    int i;
}
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *userLabel;
@property (strong, nonatomic) UILabel *thirdLabel;
@property (strong, nonatomic) NSArray *statsArray;

@end

@implementation ProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    i = 0;
    [super viewDidLoad];
    moveRight = YES;
    self.statsArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"Stats"];
    //NSLog(@"%@",self.statsArray);
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(pushToDetail)
                                                 name:@"ProfileDetail"
                                               object:nil];
    // Do any additional setup after loading the view.
    
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.gravatar.com/avatar/%@?s=256",[[NSUserDefaults standardUserDefaults] objectForKey:@"Pictureid"]]]] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if(!connectionError){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.profileImageView setAlpha:0.0];
                [self.profileImageView setImage:[UIImage roundedImageWithImage:[UIImage imageWithData:data]]];
                [UIView animateWithDuration:0.5 animations:^{
                    [self.profileImageView setAlpha:1.0];
                }];
            });
            
        }
        
    }];
    
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(150, 60+20, 160, 30)];
    [self.nameLabel setAlpha:0.0];
    //[self.nameLabel setBackgroundColor:[UIColor whiteColor]];
    [self.nameLabel setFont:[UIFont fontWithName:@"Helvetica Light" size:24]];
    [self.nameLabel setTextColor:[UIColor whiteColor]];
    [self.nameLabel setTextAlignment:NSTextAlignmentCenter];
    [self.nameLabel setText:[[NSUserDefaults standardUserDefaults] objectForKey:@"Username"]];
    [self.view addSubview:self.nameLabel];
    
    self.userLabel = [[UILabel alloc] initWithFrame:CGRectMake(150, 90+20, 160, 20)];
    [self.userLabel setAlpha:0.0];
    //[self.userLabel setBackgroundColor:[UIColor whiteColor]];
    [self.userLabel setFont:[UIFont fontWithName:@"Helvetica Light" size:14]];
    [self.userLabel setTextColor:[UIColor whiteColor]];
    [self.userLabel setTextAlignment:NSTextAlignmentCenter];
    [self.userLabel setText:[[NSUserDefaults standardUserDefaults] objectForKey:@"Name"]];
    [self.view addSubview:self.userLabel];
    
    self.thirdLabel = [[UILabel alloc] initWithFrame:CGRectMake(150, 150, 160, 20)];
    [self.thirdLabel setAlpha:0.0];
    //[self.thirdLabel setBackgroundColor:[UIColor whiteColor]];
    [self.thirdLabel setFont:[UIFont fontWithName:@"Helvetica Light" size:14]];
    [self.thirdLabel setTextColor:[UIColor whiteColor]];
    [self.thirdLabel setTextAlignment:NSTextAlignmentCenter];
    [self.thirdLabel setText:[[NSUserDefaults standardUserDefaults] objectForKey:@"Name"]];
    [self.view addSubview:self.thirdLabel];
    
    [UIView animateWithDuration:0.5 animations:^{
        [self.nameLabel setFrame:CGRectMake(150, 60, 160, 30)];
        [self.nameLabel setAlpha:1.0];
    } completion:^(BOOL finished){
        [self performSelector:@selector(cycleText) withObject:nil afterDelay:1.0];
    }];
    [UIView animateWithDuration:0.5 delay:0.2 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self.userLabel setFrame:CGRectMake(150, 85, 160, 20)];
        [self.userLabel setAlpha:1.0];
    } completion:nil];
    
    
    self.backgroundView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 440 )];
    [self.backgroundView setPagingEnabled:YES];
    [self.backgroundView setBackgroundColor:[UIColor blackColor]];
    [self.backgroundView setContentSize:CGSizeMake(320*3, 440)];
    [self.view addSubview:self.backgroundView];
    [self.view sendSubviewToBack:self.backgroundView];
    for (int i  = 0; i<3; i++){
        UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pauley.jpg"]];
        [image setContentMode:UIViewContentModeScaleAspectFill];
        [image setClipsToBounds:YES];
        [image setFrame:CGRectMake(320*i, 0, 320, 440)];
        [self.backgroundView addSubview:image];
    }
    /*
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self startSlideshow];
    });
     */
    
    self.tableView = [[ProfileTableView alloc] initWithFrame:CGRectMake(0, 0, 320, 504)];
    [self.view addSubview:self.tableView];
    [self.tableView setDelegate:self.tableView];
    [self.tableView setDataSource:self.tableView];
    [self.tableView loadView];
     
}

- (void)startSlideshow{
    while(1){
        sleep(2);
        if(moveRight){
            [self.backgroundView setContentOffset:CGPointMake(self.backgroundView.contentOffset.x+320, 0) animated:YES];
            moveRight = NO;
        }
        else{
            [self.backgroundView setContentOffset:CGPointMake(0, 0) animated:YES];
            moveRight = YES;
        }
    }
}

- (void)cycleText{
    if(i<[self.statsArray count]-1){
        i++;
    }
    else{
        i = 0;
    }
    if([self.statsArray objectAtIndex:i] != nil)
        [self.thirdLabel setText:[self.statsArray objectAtIndex:i]];
    
    [UIView animateWithDuration:0.5 animations:^{
        [self.thirdLabel setAlpha:1.0];
    } completion:^(BOOL finished){
        [UIView animateWithDuration:0.5 delay:1 options:UIViewAnimationOptionCurveLinear animations:^{
            [self.thirdLabel setAlpha:0.0];
        } completion:^(BOOL finished) {
            [self cycleText];
        }];
    }];
}

- (void)pushToDetail{
    [self performSegueWithIdentifier:@"DetailViewSegue" sender:self];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
