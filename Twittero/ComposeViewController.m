//
//  ComposeViewController.m
//  Twittero
//
//  Created by Ben Lindsey on 10/18/13.
//
//

#import "ComposeViewController.h"
#import "TwitterClient.h"
#import "UIImageView+AFNetworking.h"

@interface ComposeViewController ()

@property (weak, nonatomic) IBOutlet UILabel *lengthLabel;
@property (weak, nonatomic) IBOutlet UIButton *tweetButton;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *placeholderLabel;
@property (weak, nonatomic) IBOutlet UITextView *textView;

- (IBAction)onCancelButton;
- (IBAction)onTweetButton;

@end

@implementation ComposeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    [self setup];
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    [self setup];
    return self;
}

- (void)setup
{
    // Custom initialization
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    User *user = [User currentUser];

    NSURL *url = [NSURL URLWithString:user.profileImageURL];
    [self.imageView setImageWithURL:url];
    self.imageView.layer.cornerRadius = 5.0;
    self.imageView.layer.masksToBounds = YES;

    self.nameLabel.text = user.name;
    self.usernameLabel.text = [NSString stringWithFormat:@"@%@", user.screenName];

    if (self.tweet) {
        NSMutableString *string = [[NSMutableString alloc] init];
        [string appendString:[NSString stringWithFormat:@"@%@ ", self.tweet.user.screenName]];
        for (NSDictionary *params in self.tweet.userMentions) {
            [string appendString:[NSString stringWithFormat:@"@%@ ", params[@"screen_name"]]];
        }
        self.textView.text = string;
    } else {
        self.textView.text = @"";
    }
    [self textViewDidChange:self.textView];
    [self.textView becomeFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    NSInteger length = [textView.text length];
    self.placeholderLabel.hidden = length > 0;
    self.lengthLabel.text = [NSString stringWithFormat:@"%d", 140 - length];
    self.lengthLabel.textColor = length > 140 ? [UIColor redColor] : [UIColor grayColor];
    self.tweetButton.enabled = length <= 140;
}

#pragma mark - Private methods

- (IBAction)onCancelButton
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onTweetButton
{
    self.tweetButton.enabled = NO;
    [[TwitterClient instance] tweetWithStatus:self.textView.text inReplyToStatusId:self.tweet.id success:^(AFHTTPRequestOperation *operation, id response) {
        self.tweetButton.enabled = YES;
        [self dismissViewControllerAnimated:YES completion:nil];
        [[[UIAlertView alloc] initWithTitle:@"Success" message:@"Tweeted!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        self.tweetButton.enabled = YES;
        NSLog(@"Error: %@", error);
        [[[UIAlertView alloc] initWithTitle:@"Oops!" message:@"Couldn't access twitter, please try again!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }];
}

@end
