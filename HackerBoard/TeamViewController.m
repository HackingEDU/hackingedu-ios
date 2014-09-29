//
//  TeamViewController.m
//  HackerBoard
//
//  Created by Blake Tsuzaki on 4/12/14.
//  Copyright (c) 2014 Swag. All rights reserved.
//

#import "TeamViewController.h"
#import "UserSearchViewController.h"
#import "UIImage+RoundedImage.h"
@interface TeamViewController ()
@property (strong, nonatomic) NSMutableArray *teamNames;
@property (strong, nonatomic) NSMutableArray *teamPics;
@property (strong, nonatomic) NSMutableArray *teamViews;
@end

@implementation TeamViewController

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
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addMember:) name:@"AddMember" object:nil];
    self.teamNames = [[NSUserDefaults standardUserDefaults] objectForKey:@"TeamNames"];
    self.teamPics =[[NSUserDefaults standardUserDefaults] objectForKey:@"TeamPics"];
    self.teamViews = [[NSMutableArray alloc] init];
    [self.activityIndicator setHidesWhenStopped:YES];
    self.searchField.delegate = self;
    // Do any additional setup after loading the view.
    [self loadTeam];
}

- (void)loadTeam{
    for (int i = 0; i<[self.teamNames count]; i++){
        UIView *memberView = [[UIView alloc] initWithFrame:CGRectMake(320, 100, 80, 120)];
        [memberView setClipsToBounds:YES];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
        [memberView addSubview:imageView];
        [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.gravatar.com/avatar/%@?s=256",[self.teamPics objectAtIndex:i]]]] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            if(!connectionError){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [imageView setImage:[UIImage roundedImageWithImage:[UIImage imageWithData:data]]];
                });
                
            }
            
        }];
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 80, 80, 22)];
        [nameLabel setText:[self.teamNames objectAtIndex:i]];
        [nameLabel setFont:[UIFont fontWithName:@"Helvetica Light" size:14]];
        [nameLabel setTextAlignment:NSTextAlignmentCenter];
        [memberView addSubview:nameLabel];
        [self.view addSubview:memberView];
        [self.teamViews addObject:memberView];
    }
    [self arrangeTeam];
}

- (void) addMember:(NSNotification *)notification{
    UIView *memberView = [[UIView alloc] initWithFrame:CGRectMake(320, 100, 80, 120)];
    [memberView setClipsToBounds:YES];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
    [memberView addSubview:imageView];
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.gravatar.com/avatar/%@?s=256",[notification.object objectForKey:@"gravatar_id"]]]] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if(!connectionError){
            dispatch_async(dispatch_get_main_queue(), ^{
                [imageView setImage:[UIImage roundedImageWithImage:[UIImage imageWithData:data]]];
            });
            
        }
        
    }];
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 80, 80, 22)];
    [nameLabel setBackgroundColor:[UIColor whiteColor]];
    [nameLabel setText:[notification.object objectForKey:@"login"]];
    [nameLabel setFont:[UIFont fontWithName:@"Helvetica Light" size:14]];
    [nameLabel setTextAlignment:NSTextAlignmentCenter];
    [memberView addSubview:nameLabel];
    [self.view addSubview:memberView];
    [self.teamViews addObject:memberView];
    [self arrangeTeam];
}

- (void) arrangeTeam{
    for (int j = 0; j<[self.teamViews count]; j++){
        [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            [[self.teamViews objectAtIndex:j] setCenter:CGPointMake(((j+1.0)/([self.teamViews count]+1.0))*320, 160)];
        } completion:nil];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self searchUsers];
    return YES;
}

- (void)searchUsers{
    [self.activityIndicator startAnimating];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.github.com/users/%@",self.searchField.text]]];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    NSError *error = nil;
    NSHTTPURLResponse *responseCode = nil;
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&responseCode error:&error];
    NSError *err;
    id val = [NSJSONSerialization JSONObjectWithData:data options:0 error:&err];
    
    if(!err && !error && val && [NSJSONSerialization isValidJSONObject:val])
    {
        NSLog(@"%@",val);
        if([val objectForKey:@"message"] == nil){
            [self performSegueWithIdentifier:@"User Found" sender:self];
            [self.activityIndicator stopAnimating];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"LoadSearchResult" object:val];
        }
        else{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"User Not Found" message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alertView show];
            [self.activityIndicator stopAnimating];
        }
        
    }
    else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertView show];
        [self.activityIndicator stopAnimating];
    }
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)shareButtonPressed:(id)sender {
    
    UIActivityViewController* activityViewController =
    [[UIActivityViewController alloc] initWithActivityItems:[NSArray arrayWithObject:@"Hi"]
                                      applicationActivities:nil];
    [self presentViewController:activityViewController animated:YES completion:^{}];
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
