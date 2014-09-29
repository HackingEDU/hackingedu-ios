//
//  LoginViewController.m
//  HackerBoardv1
//
//  Created by Blake Tsuzaki on 4/12/14.
//  Copyright (c) 2014 Swag. All rights reserved.
//

#import "LoginViewController.h"
#import "GithubAuthController.h"
#import "Defines.h"
#import <Parse/Parse.h>

@interface LoginViewController ()

@end

@implementation LoginViewController

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
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUserKey:) name:@"URLParsed" object:nil];
}

//This is our authentication delegate. When the user logs in, and Github sends us our auth token, we receive that here.
-(void) didAuth:(NSString*)token
{
    if(!token)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"Failed to request token."] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    //As a test, we'll request the authenticated user data.
    NSString *gistCreateURLString = [NSString stringWithFormat:@"https://api.github.com/user?access_token=%@", token];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:gistCreateURLString]];

    NSOperationQueue *theQ = [NSOperationQueue new];
    [NSURLConnection sendAsynchronousRequest:request queue:theQ
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               
                               NSError *err;
                               id val = [NSJSONSerialization JSONObjectWithData:data options:0 error:&err];
                               if(!err && !error && val && [NSJSONSerialization isValidJSONObject:val])
                               {
                                   [[NSUserDefaults standardUserDefaults] setValue:[val objectForKey:@"name"] forKey:@"Name"];
                                   [[NSUserDefaults standardUserDefaults] setValue:[val objectForKey:@"login"] forKey:@"Username"];
                                   [[NSUserDefaults standardUserDefaults] setValue:[val objectForKey:@"email"] forKey:@"email"];
                                   [[NSUserDefaults standardUserDefaults] setValue:[NSArray arrayWithObjects:[NSString stringWithFormat:@"%@ Followers",[val objectForKey:@"followers"]],[NSString stringWithFormat:@"Following %@",[val objectForKey:@"followers"]],[NSString stringWithFormat:@"%@ Collaborators",[val objectForKey:@"collaborators"]],[val objectForKey:@"company"],[val objectForKey:@"email"],[val objectForKey:@"location"], nil] forKey:@"Stats"];
                                   [[NSUserDefaults standardUserDefaults] setValue:[val objectForKey:@"html_url"] forKey:@"URL"];
                                   [[NSUserDefaults standardUserDefaults] setValue:[NSArray arrayWithObject:[val objectForKey:@"login"]] forKey:@"TeamNames"];
                                   [[NSUserDefaults standardUserDefaults] setValue:[NSArray arrayWithObject:[val objectForKey:@"gravatar_id"]] forKey:@"TeamPics"];
                                   
                                   /*
                                   [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%@ Followers",[val objectForKey:@"followers"]] forKey:@"Followers"];
                                   [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"Following %@",[val objectForKey:@"followers"] forKey:@"Following"];
                                    [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%@ Collaborators",[val objectForKey:@"collaborators"] forKey:@"Collaborators"];
                                     [[NSUserDefaults standardUserDefaults] setValue:[val objectForKey:@"company"] forKey:@"Company"];
                                     [[NSUserDefaults standardUserDefaults] setValue:[val objectForKey:@"email"] forKey:@"Email"];
                                     */
                                   [[NSUserDefaults standardUserDefaults] setValue:[val objectForKey:@"gravatar_id"] forKey:@"Pictureid"];
                                   [[NSUserDefaults standardUserDefaults] synchronize];
                                   
                                   dispatch_sync(dispatch_get_main_queue(), ^{
                                       [self dismissViewControllerAnimated:NO completion:nil];
                                       [self dismissViewControllerAnimated:YES completion:nil];
                                       [[NSNotificationCenter defaultCenter] postNotificationName:@"StartSlide" object:nil];
                                   });
                                   
                               }
                           }];
    
    //NSMutableURLRequest *backRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://107.170.192.217:6543/api/addUser?username=%@&git_link=%@&git_token=%@&email=%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"Username"],[[NSUserDefaults standardUserDefaults] objectForKey:@"URL"],[[NSUserDefaults standardUserDefaults] objectForKey:@"Token"],[[NSUserDefaults standardUserDefaults] objectForKey:@"email"]]]];
    
    NSMutableURLRequest *backRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://107.170.192.217:6543/api/getUser?user_id=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"Username"]]]];
    [backRequest setHTTPMethod:@"GET"];
    NSOperationQueue *queue = [NSOperationQueue new];
    [NSURLConnection sendAsynchronousRequest:backRequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSError *err;
        if(data){
            id val = [NSJSONSerialization JSONObjectWithData:data options:0 error:&err];
            if(!err && !connectionError && val && [NSJSONSerialization isValidJSONObject:val])
            {
                NSLog(@"Success: %@",val);
            }
            else{
                NSLog(@"Failure: %@",[connectionError localizedDescription]);
            }
        }else{
            NSLog(@"Error %@",response);
        }
        
        
    }];
}


- (void) getUserKey:(NSNotification *)notification{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://github.com/login/oauth/access_token?client_id=%@&client_secret=%@&code=%@",GITHUB_CLIENT_ID,GITHUB_CLIENT_SECRET,notification.object]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    NSOperationQueue *theQ = [NSOperationQueue new];
    [NSURLConnection sendAsynchronousRequest:request queue:theQ
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               NSError *err;
                               id val = [NSJSONSerialization JSONObjectWithData:data options:0 error:&err];
                               NSLog(@"%@",val);
                               if(!err && !error && val && [NSJSONSerialization isValidJSONObject:val])
                               {
                                   [[NSUserDefaults standardUserDefaults] setValue:[val objectForKey:@"access_token"] forKey:@"Token"];
                                   [[NSUserDefaults standardUserDefaults] synchronize];
                                   [self didAuth:[val objectForKey:@"access_token"]];
                               }
                           }];

}

-(void) checkGitAuth
{
    GithubAuthController *githubAuthController = [[GithubAuthController alloc] init];
    githubAuthController.authDelegate = self;
    
    githubAuthController.modalPresentationStyle = UIModalPresentationFormSheet;
    githubAuthController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [self presentViewController:githubAuthController animated:YES completion:^{ } ];
    
    __weak __block GithubAuthController *weakAuthController = githubAuthController;
    
    githubAuthController.completionBlock = ^(void) {
        [weakAuthController dismissViewControllerAnimated:YES completion:^(void){
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
    };
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

- (IBAction)skipLogin:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)signIn:(id)sender {
    [self checkGitAuth];
}
@end
