//
//  Tweet.h
//  Twittero
//
//  Created by Ben Lindsey on 10/18/13.
//
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Tweet : RestObject {
    NSNumber *_retweeted; // overrides data setting
    NSNumber *_favorited; // overrides data setting
}

- (NSString *)id;
- (NSString *)text;
- (NSDate *)createdAt;
- (NSInteger)favoriteCount;
- (NSInteger)retweetCount;
- (NSArray *)userMentions; // of NSDictionary

- (User *)user;

@property (assign, nonatomic) BOOL retweeted;
@property (assign, nonatomic) BOOL favorited;

+ (NSArray *)tweetsWithArray:(NSArray *)array;

@end
