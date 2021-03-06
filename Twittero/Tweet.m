//
//  Tweet.m
//  Twittero
//
//  Created by Ben Lindsey on 10/18/13.
//
//

#import "Tweet.h"

@implementation Tweet

- (id)initWithDictionary:(NSDictionary *)data
{
    self = [self init];
    if (self) {
        _id = [data objectForKey:@"id_str"];
        _text = [data objectForKey:@"text"];

        static NSDateFormatter *formatter = nil; //cached not threadsafe
        if (!formatter) {
            formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"EE MM dd HH:mm:ss ZZZ yyyy";
        }
        _createdAt = [formatter dateFromString:[data objectForKey:@"created_at"]];

        _retweetCount = [[data objectForKey:@"retweet_count"] integerValue];
        _favoriteCount = [[data objectForKey:@"favorite_count"] integerValue];

        _userMentions = [data valueForKeyPath:@"entities.user_mentions"];
        _user = [[User alloc] initWithDictionary:[data objectForKey:@"user"]];

        _retweeted = [[data objectForKey:@"retweeted"] integerValue];
        _favorited = [[data objectForKey:@"favorited"] integerValue];

        NSDictionary *retweet = [data objectForKey:@"retweeted_status"];
        if (retweet) {
            _retweetedStatus = [[Tweet alloc] initWithDictionary:retweet];
        }
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ %@", self.id, self.text];
}

+ (NSArray *)tweetsWithArray:(NSArray *)array
{
    NSMutableArray *result = [[NSMutableArray alloc] initWithCapacity:[array count]];
    for (NSDictionary *dict in array) {
        Tweet *tweet = [[Tweet alloc] initWithDictionary:dict];
        [result addObject:tweet];
    }
    return result;
}

@end
