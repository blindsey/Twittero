//
//  TimelineViewController.m
//  Twittero
//
//  Created by Ben Lindsey on 10/18/13.
//
//

#import "TimelineViewController.h"
#import "TweetCell.h"
#import "Tweet.h"
#import "TwitterClient.h"
#import "TweetViewController.h"
#import "ComposeViewcontroller.h"
#import "User.h"

@interface TimelineViewController ()

@property (strong, nonatomic) NSArray *tweets; // of Tweet

- (void)refresh;
- (IBAction)onLoadMoreButton;
- (IBAction)onSignOutButton;

@end

@implementation TimelineViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"";
    UIImage *image = [UIImage imageNamed:@"twitter"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    [imageView setContentMode:UIViewContentModeScaleAspectFit];
    self.navigationItem.titleView = imageView;

    UINavigationBar *bar = [self.navigationController navigationBar];
    [bar setTranslucent:NO];
    [bar setTintColor:[UIColor whiteColor]];
    [bar setBarTintColor:[UIColor colorWithRed:85.0/255 green:172.0/255 blue:238.0/255 alpha:1.0]];
    
    NSDictionary *attributes = @{ UITextAttributeTextColor : [UIColor whiteColor],
                                  UITextAttributeFont : [UIFont boldSystemFontOfSize:20] };
    [bar setTitleTextAttributes:attributes];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    [self.refreshControl beginRefreshing];
    [self refresh];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = [self.tweets count];
    return count > 0 ? count + 1 : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == [self.tweets count]) {
        return [tableView dequeueReusableCellWithIdentifier:@"MoreCell" forIndexPath:indexPath];
    } else {
        TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell" forIndexPath:indexPath];
        cell.tweet = self.tweets[indexPath.row];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == [self.tweets count]) {
        return 32;
    }
    
    Tweet *tweet = self.tweets[indexPath.row];
    CGFloat width = self.view.frame.size.width - 79;
    NSDictionary *attributes = @{ NSFontAttributeName : [UIFont systemFontOfSize:14] };
    CGRect frame = [tweet.text boundingRectWithSize:CGSizeMake(width, 1000)
                                            options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                         attributes:attributes
                                            context:nil];
    return MAX(68.0, frame.size.height + 30);
}

#pragma mark - segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"TweetView"]) {
        TweetViewController *controller = [segue destinationViewController];
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        controller.tweet = self.tweets[indexPath.row];
    } else if ([segue.identifier isEqualToString:@"ComposeView"]) {
        ComposeViewController *controller = [segue destinationViewController];
        controller.tweet = nil;
    }
}

#pragma mark - Private methods

- (IBAction)onSignOutButton
{
    [User setCurrentUser:nil];
}

- (void)refresh
{
    [[TwitterClient instance] homeTimelineWithCount:20 sinceId:0 maxId:0 success:^(AFHTTPRequestOperation *operation, id response) {
        //NSLog(@"%@", response);
        self.tweets = [Tweet tweetsWithArray:response];
        [self.tableView reloadData];
        [self.refreshControl endRefreshing];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        // Do nothing
    }];
}

- (IBAction)onLoadMoreButton
{
    Tweet *tweet = [self.tweets lastObject];
    [[TwitterClient instance] homeTimelineWithCount:20 sinceId:0 maxId:tweet.id success:^(AFHTTPRequestOperation *operation, id response) {
        self.tweets = [self.tweets arrayByAddingObjectsFromArray:[Tweet tweetsWithArray:response]];
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        // Do nothing
    }];
}

@end
