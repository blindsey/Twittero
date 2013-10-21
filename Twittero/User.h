//
//  User.h
//  Twittero
//
//  Created by Ben Lindsey on 10/18/13.
//
//

#import <Foundation/Foundation.h>
#import "RestObject.h"

extern NSString *const UserDidLoginNotification;
extern NSString *const UserDidLogoutNotification;

@interface User : RestObject

- (NSString *)name;
- (NSString *)screenName;
- (NSString *)profileImageURL;

- (NSInteger)statusesCount;
- (NSInteger)followersCount;
- (NSInteger)friendsCount;

+ (void)checkUserAuthorization;
+ (void)setCurrentUser:(User *)user;
+ (User *)currentUser;

@end
