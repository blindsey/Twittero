//
//  Tweet.m
//  Twittero
//
//  Created by Ben Lindsey on 10/18/13.
//
//

#import "Tweet.h"

@implementation Tweet

- (NSString *)id
{
    return [super stringValueForKey:@"id_str"];
}

- (NSString *)text
{
    return [super stringValueForKey:@"text"];
}

- (NSDate *)createdAt
{
    return [super dateValueForKey:@"created_at"];
}

- (NSInteger)retweetCount
{
    return [super intValueForKey:@"retweet_count"];
}

- (NSInteger)favoriteCount
{
    return [super intValueForKey:@"favorite_count"];
}

- (NSArray *)userMentions
{
    return [self.data valueForKeyPath:@"entities.user_mentions"];
}

- (User*)user
{
    NSDictionary *dict = [self.data objectForKey:@"user"];
    return [[User alloc] initWithDictionary:dict];
}

- (void)setRetweeted:(BOOL)retweeted
{
    _retweeted = @(retweeted);
}

- (BOOL)retweeted
{
    if (_retweeted != nil) {
        return [_retweeted boolValue];
    } else {
        return [super intValueForKey:@"retweeted"];
    }
}

- (void)setFavorited:(BOOL)favorited
{
    _favorited = @(favorited);
}

- (BOOL)favorited
{
    if (_favorited != nil) {
        return [_favorited boolValue];
    } else {
        return [super intValueForKey:@"favorited"];
    }
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
