//
//  RestObject.m
//  Twittero
//
//  Created by Ben Lindsey on 10/20/13.
//
//

#import "RestObject.h"

@interface RestObject ()

@end

@implementation RestObject

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [self init];
    if (self) {
        _data = dictionary;
    }
    return self;
}

- (NSString *)stringValueForKey:(id)key
{
    return [[self.data objectForKey:key] description];
}

- (NSInteger)intValueForKey:(id)key
{
    return [[self.data objectForKey:key] integerValue];
}

- (NSDate *)dateValueForKey:(id)key
{
    static NSDateFormatter *formatter = nil; //cached
    if (!formatter) {
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"EE MM dd HH:mm:ss ZZZ yyyy"];
    }
    return [formatter dateFromString:[self.data objectForKey:key]];
}

@end
