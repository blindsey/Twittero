//
//  ComposeViewController.h
//  Twittero
//
//  Created by Ben Lindsey on 10/18/13.
//
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@interface ComposeViewController : UIViewController <UITextViewDelegate>

@property (strong, nonatomic) Tweet *tweet;

@end
