//
//  InfoCard.m
//  HackerBoard
//
//  Created by Blake Tsuzaki on 4/13/14.
//  Copyright (c) 2014 Swag. All rights reserved.
//

#import "InfoCard.h"

@implementation InfoCard

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (InfoCard *)initWithData:(NSString*)message :(UIImage*)image{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 240, 120)];
    [imageView setImage:image];
    [self addSubview:imageView];
    UITextView *label = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 240, 120)];
    [label setText:message];
    [label setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:label];
    return self;
}
- (InfoCard *)initWithMessage:(NSString*)message{
    UITextView *label = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 240, 120)];
    [label setText:message];
    [label setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:label];
    return self;
}
- (InfoCard *)initWithImage:(UIImage *)image{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 240, 120)];
    [imageView setImage:image];
    [self addSubview:imageView];
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
