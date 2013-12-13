//
//  TweetCell.m
//  Twittero
//
//  Created by Ben Lindsey on 10/18/13.
//
//

#import "TweetCell.h"
#import "UIImageView+AFNetworking.h"

@interface TweetCell ()

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetLabel;
@property (weak, nonatomic) IBOutlet UILabel *retweetLabel;

- (void)nameLabelWithUser:(User *)user;

@end

@implementation TweetCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    float inset = 20.f;
    if (self.tweet.retweetedStatus) {
        inset = 0.f;
    }
    CGRect frame = self.contentView.frame;
    self.contentView.frame = CGRectMake(0, -inset, frame.size.width, frame.size.height);
}

- (void)setTweet:(Tweet *)tweet
{
    _tweet = tweet;
    User *user = tweet.user;

    if (tweet.retweetedStatus) {
        self.retweetLabel.text = [NSString stringWithFormat:@"%@ retweeted", user.name];
        user = tweet.retweetedStatus.user;
    }

    // profile pic
    NSURL *url = [NSURL URLWithString:user.profileImageURL];
    [self.profileImageView setImageWithURL:url];
    self.profileImageView.layer.cornerRadius = 5.0;
    self.profileImageView.layer.masksToBounds = YES;

    [self nameLabelWithUser:user];

    NSTimeInterval interval = -1 * [tweet.createdAt timeIntervalSinceNow];
    if (interval > 86400) {
        self.timeLabel.text = [NSString stringWithFormat:@"%0.fd", interval/86400];
    } else if (interval > 3600) {
        self.timeLabel.text = [NSString stringWithFormat:@"%0.fh", interval/3600];
    } else if (interval > 60) {
        self.timeLabel.text = [NSString stringWithFormat:@"%0.fm", interval/60];
    } else {
        self.timeLabel.text = [NSString stringWithFormat:@"%0.fs", interval];
    }

    self.tweetLabel.text = tweet.retweetedStatus ? tweet.retweetedStatus.text : tweet.text;
}

# pragma mark - Private methods

- (void)nameLabelWithUser:(User *)user
{
    NSMutableAttributedString *mas = [[NSMutableAttributedString alloc] initWithString:user.name];
    
    UIFont *font = self.nameLabel.font;
    UIColor *color = [UIColor blackColor];
    NSRange range = NSMakeRange(0, [user.name length]);
    [mas addAttributes:@{ NSForegroundColorAttributeName : color, NSFontAttributeName : font } range:range];
    NSString *handle = [NSString stringWithFormat:@" @%@", user.screenName];
    [mas appendAttributedString:[[NSAttributedString alloc] initWithString:handle]];
    
    range = NSMakeRange([user.name length], [handle length]);
    UIFont *regularFont = [UIFont systemFontOfSize:[font pointSize] - 1];
    color = [UIColor lightGrayColor];
    [mas addAttributes:@{ NSForegroundColorAttributeName : color, NSFontAttributeName : regularFont } range:range];
    
    self.nameLabel.attributedText = mas;
}

@end
