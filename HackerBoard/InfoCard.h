//
//  InfoCard.h
//  HackerBoard
//
//  Created by Blake Tsuzaki on 4/13/14.
//  Copyright (c) 2014 Swag. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoCard : UIView
- (InfoCard *)initWithData:(NSString*)message :(UIImage*)image;
- (InfoCard *)initWithMessage:(NSString*)message;
- (InfoCard *)initWithImage:(UIImage*)image;
@end