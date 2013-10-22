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

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetLabel;

- (void)attributedStringForNameLabel;

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

- (void)setTweet:(Tweet *)tweet
{
    _tweet = tweet;
    User *user = tweet.user;
    
    // profile pic
    NSURL *url = [NSURL URLWithString:user.profileImageURL];
    [self.imageView setImageWithURL:url];
    self.imageView.layer.cornerRadius = 5.0;
    self.imageView.layer.masksToBounds = YES;
    
    [self attributedStringForNameLabel];
    
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
    
    self.tweetLabel.text = tweet.text;
}

# pragma mark - Private methods

- (void)attributedStringForNameLabel
{
    User *user = self.tweet.user;
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
