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

- (id)initWithDictionary:(NSDictionary *)data
{
    self = [self init];
    if (self) {
        _name = [data objectForKey:@"name"];
        _screenName = [data objectForKey:@"screen_name"];
        _profileImageURL = [data objectForKey:@"profile_image_url"];
        _statusesCount = [[data objectForKey:@"statuses_count"] integerValue];
        _followersCount = [[data objectForKey:@"followers_count"] integerValue];
        _friendsCount = [[data objectForKey:@"friends_count"] integerValue];
    }
    return self;
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
