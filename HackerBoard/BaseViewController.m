//
//  BaseViewController.m
//  HackerBoard
//
//  Created by Blake Tsuzaki on 4/12/14.
//  Copyright (c) 2014 Swag. All rights reserved.
//

#import "BaseViewController.h"
#import "BoardDetailViewController.h"
#import "LoginViewController.h"
@interface BaseViewController (){
    BOOL moveRight;
}
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *locationLabel;
@property (strong, nonatomic) UILabel *durationLabel;
@property (strong, nonatomic) UITextView *descriptionLabel;


@end

@implementation BaseViewController

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
    
    [self performSegueWithIdentifier:@"Show Login" sender:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startSlideshow) name:@"StartSlide" object:nil];
    [super viewDidLoad];
    moveRight = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(pushToDetail)
                                                 name:@"BaseDetail"
                                               object:nil];
    // Do any additional setup after loading the view.
    
    self.bannerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 440 )];
    [self.bannerView setPagingEnabled:YES];
    [self.bannerView setBackgroundColor:[UIColor blackColor]];
    [self.bannerView setContentSize:CGSizeMake(320*3, 440)];
    [self.view addSubview:self.bannerView];
    [self.view sendSubviewToBack:self.bannerView];
    for (int i  = 0; i<3; i++){
        UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pauley.jpg"]];
        [image setContentMode:UIViewContentModeScaleAspectFill];
        [image setClipsToBounds:YES];
        [image setFrame:CGRectMake(320*i, 0, 320, 440)];
        [self.bannerView addSubview:image];
    }
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //[self startSlideshow];
    });
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 200, 300, 30)];
    [self.nameLabel setTextColor:[UIColor whiteColor]];
    [self.nameLabel setBackgroundColor:[UIColor colorWithWhite:0.2 alpha:0.8]];
    [self.nameLabel setText:@" LA Hacks"];
    [self.view addSubview:self.nameLabel];
    
    self.locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 240, 300, 30)];
    [self.locationLabel setTextColor:[UIColor whiteColor]];
    [self.locationLabel setBackgroundColor:[UIColor colorWithWhite:0.2 alpha:0.8]];
    [self.locationLabel setText:@" Location: Pauley Pavilion, UCLA"];
    [self.view addSubview:self.locationLabel];
    
    self.durationLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 280, 300, 30)];
    [self.durationLabel setTextColor:[UIColor whiteColor]];
    [self.durationLabel setBackgroundColor:[UIColor colorWithWhite:0.2 alpha:0.8]];
    [self.durationLabel setFont:[UIFont systemFontOfSize:14]];
    [self.durationLabel setText:@"  Fri Apr 11 6:00PM  -  Sun Apr 13 5:00PM"];
    [self.view addSubview:self.durationLabel];
    
    self.descriptionLabel = [[UITextView alloc] initWithFrame:CGRectMake(10, 320, 300, 70)];
    [self.descriptionLabel setTextColor:[UIColor whiteColor]];
    [self.descriptionLabel setBackgroundColor:[UIColor colorWithWhite:0.2 alpha:0.8]];
    [self.descriptionLabel setEditable:NO];
    [self.descriptionLabel setUserInteractionEnabled:YES];
    [self.descriptionLabel setFont:[UIFont systemFontOfSize:12]];
    [self.descriptionLabel setText:@"Description:"];
    [self.view addSubview:self.descriptionLabel];
    
    self.tableView = [[AFViewController alloc] initWithFrame:CGRectMake(0, 0, 320, 504)];
    [self.view addSubview:self.tableView];
    [self.tableView setDelegate:self.tableView];
    [self.tableView setDataSource:self.tableView];
    [self.tableView loadView];
}

- (void)startSlideshow{
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //[self startSlideshow];
    
    while(0){
        sleep(2);
        if(moveRight){
            [self.bannerView setContentOffset:CGPointMake(self.bannerView.contentOffset.x+320, 0) animated:YES];
            moveRight = NO;
        }
        else{
            [self.bannerView setContentOffset:CGPointMake(0, 0) animated:YES];
            moveRight = YES;
        }
    }
        });
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
