//
//  UserSearchViewController.m
//  HackerBoard
//
//  Created by Blake Tsuzaki on 4/13/14.
//  Copyright (c) 2014 Swag. All rights reserved.
//

#import "UserSearchViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImage+RoundedImage.h"

@interface UserSearchViewController (){
    int i;
}
@property (strong, nonatomic) NSArray *statsArray;
@property (strong, nonatomic) NSObject *user;
@end

@implementation UserSearchViewController

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
    [self.secondLabel setAlpha:0];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData:) name:@"LoadSearchResult" object:nil];
    // Do any additional setup after loading the view.
    [self flashOn:self.closeButton];
    
}

- (void)loadData:(NSNotification *)notification{
    self.user = notification.object;
    self.statsArray = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%@ Followers",[notification.object objectForKey:@"followers"]],[NSString stringWithFormat:@"Following %@",[notification.object objectForKey:@"followers"]],[notification.object objectForKey:@"company"],[notification.object objectForKey:@"email"],[notification.object objectForKey:@"location"], nil];
                       
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.gravatar.com/avatar/%@?s=256",[notification.object objectForKey:@"gravatar_id"]]]] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if(!connectionError){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.userImage setImage:[UIImage roundedImageWithImage:[UIImage imageWithData:data]]];
            });
            
        }
        
    }];
    
    [self.userNameLabel setText:[notification.object objectForKey:@"name"]];
    [self performSelector:@selector(cycleText) withObject:nil afterDelay:1.0];
    
}

- (void)cycleText{
    if(i<[self.statsArray count]-1){
        i++;
    }
    else{
        i = 0;
    }
    if([self.statsArray objectAtIndex:i] != nil)
        [self.secondLabel setText:[self.statsArray objectAtIndex:i]];
    
    [UIView animateWithDuration:0.5 animations:^{
        [self.secondLabel setAlpha:1.0];
    } completion:^(BOOL finished){
        [UIView animateWithDuration:0.5 delay:1 options:UIViewAnimationOptionCurveLinear animations:^{
            [self.secondLabel setAlpha:0.0];
        } completion:^(BOOL finished) {
            [self cycleText];
        }];
    }];
}


- (void)flashOff:(UIView *)v
{
    [UIView animateWithDuration:1.5 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^ {
        v.alpha = .1;  //don't animate alpha to 0, otherwise you won't be able to interact with it
    } completion:^(BOOL finished) {
        [self flashOn:v];
    }];
}

- (void)flashOn:(UIView *)v
{
    [UIView animateWithDuration:1.5 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^ {
        v.alpha = 0.8;
    } completion:^(BOOL finished) {
        [self flashOff:v];
    }];
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
- (IBAction)closeButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)addToTeam:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AddMember" object:self.user];
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
