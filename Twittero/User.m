//
//  User.m
//  Twittero
//
//  Created by Ben Lindsey on 10/18/13.
//
//

#import "User.h"
#import "TwitterClient.h"

NSString * const UserDidLoginNotification = @"UserDidLoginNotification";
NSString * const UserDidLogoutNotification = @"UserDidLogoutNotification";

@implementation User

- (NSString *)name
{
    return [super stringValueForKey:@"name"];
}

- (NSString *)screenName
{
    return [super stringValueForKey:@"screen_name"];
}

- (NSString *)profileImageURL
{
    return [super stringValueForKey:@"profile_image_url"];
}

- (NSInteger)statusesCount
{
    return [super intValueForKey:@"statuses_count"];
}

- (NSInteger)followersCount
{
    return [super intValueForKey:@"followers_count"];
}

- (NSInteger)friendsCount
{
    return [super intValueForKey:@"friends_count"];
}

static User *_currentUser;

+ (User *)currentUser
{
    return _currentUser;
}

+ (void)setCurrentUser:(User *)user
{
    if (!_currentUser && user) {
        _currentUser = user;
        [[NSNotificationCenter defaultCenter] postNotificationName:UserDidLoginNotification object:nil];
    } else if (_currentUser && !user) {
        _currentUser = user;
        [TwitterClient instance].accessToken = nil;
        [[NSNotificationCenter defaultCenter] postNotificationName:UserDidLogoutNotification object:nil];
    }
}

+ (void)checkUserAuthorization
{
    [[TwitterClient instance] currentUserWithSuccess:^(AFHTTPRequestOperation *operation, id response) {
        [User setCurrentUser:[[User alloc] initWithDictionary:response]];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

@end
