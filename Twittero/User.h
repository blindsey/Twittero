//
//  User.h
//  Twittero
//
//  Created by Ben Lindsey on 10/18/13.
//
//

#import <Foundation/Foundation.h>

extern NSString *const UserDidLoginNotification;
extern NSString *const UserDidLogoutNotification;

@interface User : NSObject

- (id)initWithDictionary:(NSDictionary *)data;

@property (strong, nonatomic, readonly) NSString *name;
@property (strong, nonatomic, readonly) NSString *screenName;
@property (strong, nonatomic, readonly) NSString *profileImageURL;

@property (assign, nonatomic, readonly) NSInteger statusesCount;
@property (assign, nonatomic, readonly) NSInteger followersCount;
@property (assign, nonatomic, readonly) NSInteger friendsCount;

+ (void)checkUserAuthorization;
+ (void)setCurrentUser:(User *)user;
+ (User *)currentUser;

@end
