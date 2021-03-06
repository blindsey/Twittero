//
//  TwitterClient.m
//  Twittero
//
//  Created by Ben Lindsey on 10/18/13.
//
//

#import "TwitterClient.h"
#import "AFNetworking.h"

#define TWITTER_BASE_URL [NSURL URLWithString:@"https://api.twitter.com/"]
#define TWITTER_CONSUMER_KEY @"4pYYTgFBdcjyohteM8yPg"
#define TWITTER_CONSUMER_SECRET @"a0QQ16TP8XsRfiYYftYMnQusLWpM9xntttq9ZKFxN8"

#define ACCESS_TOKEN_DEFAULTS_KEY @"kAccessTokenKey"

@implementation TwitterClient

+ (TwitterClient *)instance
{
    static dispatch_once_t once;
    static TwitterClient *instance;
    
    dispatch_once(&once, ^{
        instance = [[TwitterClient alloc] initWithBaseURL:TWITTER_BASE_URL key:TWITTER_CONSUMER_KEY secret:TWITTER_CONSUMER_SECRET];
    });
    
    return instance;
}

- (id)initWithBaseURL:(NSURL *)url key:(NSString *)key secret:(NSString *)secret
{
    self = [super initWithBaseURL:TWITTER_BASE_URL key:TWITTER_CONSUMER_KEY secret:TWITTER_CONSUMER_SECRET];
    if (self != nil) {
        [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
        
        NSData *data = [[NSUserDefaults standardUserDefaults] dataForKey:ACCESS_TOKEN_DEFAULTS_KEY];
        if (data) {
            self.accessToken = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        }
    }
    return self;
}

- (void)setAccessToken:(AFOAuth1Token *)accessToken
{
    [super setAccessToken:accessToken];
    
    if (accessToken) {
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:accessToken];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:ACCESS_TOKEN_DEFAULTS_KEY ];
    } else {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:ACCESS_TOKEN_DEFAULTS_KEY];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Users API

- (void)authorizeWithCallbackUrl:(NSURL *)callbackUrl success:(void (^)(AFOAuth1Token *accessToken, id responseObject))success failure:(void (^)(NSError *error))failure
{
    self.accessToken = nil;
    [super authorizeUsingOAuthWithRequestTokenPath:@"oauth/request_token" userAuthorizationPath:@"oauth/authorize" callbackURL:callbackUrl accessTokenPath:@"oauth/access_token" accessMethod:@"POST" scope:nil success:success failure:failure];
}

- (void)currentUserWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id response))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self getPath:@"1.1/account/verify_credentials.json" parameters:nil success:success failure:failure];
}

#pragma mark - Statuses API

- (void)homeTimelineWithCount:(int)count sinceId:(NSString *)sinceId maxId:(NSString *)maxId success:(void (^)(AFHTTPRequestOperation *operation, id response))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{@"count": @(count)}];
    if (sinceId) {
        [params setObject:sinceId forKey:@"since_id"];
    }
    if (maxId) {
        [params setObject:maxId forKey:@"max_id"];
    }
    [self getPath:@"1.1/statuses/home_timeline.json" parameters:params success:success failure:failure];
}

- (void)tweetWithStatus:(NSString *)status inReplyToStatusId:(NSString *)statusId success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{@"status": status}];
    if (statusId) {
        [params setObject:statusId forKey:@"in_reply_to_status_id"];
    }
    [self postPath:@"1.1/statuses/update.json" parameters:params success:success failure:failure];
}

- (void)retweetWithStatusId:(NSString *)statusId success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
    NSDictionary *params = @{@"trim_user" : @"true"};
    NSString *path = [NSString stringWithFormat:@"1.1/statuses/retweet/%@.json", statusId];
    [self postPath:path parameters:params success:success failure:failure];
}

- (void)favoriteWithStatusId:(NSString *)statusId success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
    NSDictionary *params = @{@"id": statusId};
    [self postPath:@"1.1/favorites/create.json" parameters:params success:success failure:failure];
}

- (void)unfavoriteWithStatusId:(NSString *)statusId success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
    NSDictionary *params = @{@"id": statusId};
    [self postPath:@"1.1/favorites/destroy.json" parameters:params success:success failure:failure];
}
@end
