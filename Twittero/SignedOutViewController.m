//
//  ViewController.m
//  Twittero
//
//  Created by Ben Lindsey on 10/18/13.
//
//

#import "SignedOutViewController.h"
#import "TwitterClient.h"
#import "User.h"

@interface SignedOutViewController ()

- (IBAction)onSignInButton;

@end

@implementation SignedOutViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onSignInButton
{
    [[TwitterClient instance] authorizeWithCallbackUrl:[NSURL URLWithString:@"cp-twitter://success"] success:^(AFOAuth1Token *accessToken, id responseObject) {
        [User checkUserAuthorization];
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
        [[[UIAlertView alloc] initWithTitle:@"Oops!" message:@"Couldn't log in with Twitter, please try again!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }];
}

@end
