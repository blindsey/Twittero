//
//  RestObject.h
//  Twittero
//
//  Created by Ben Lindsey on 10/20/13.
//
//

#import <Foundation/Foundation.h>

@interface RestObject : NSObject

- (id) initWithDictionary:(NSDictionary *)dictionary;

- (NSString *)stringValueForKey:(id)key;
- (NSInteger)intValueForKey:(id)key;
- (NSDate *)dateValueForKey:(id)key;

@property (strong, nonatomic) NSDictionary *data;

@end
