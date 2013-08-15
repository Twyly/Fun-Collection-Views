//
//  TJWCardCell.m
//  CollectionViewFun
//
//  Created by Teddy Wyly on 8/12/13.
//  Copyright (c) 2013 Teddy Wyly. All rights reserved.
//

#import "TJWCardCell.h"

@implementation TJWCardCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.backgroundColor = [UIColor colorWithWhite:0.85f alpha:1.0f];
    
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
    self.layer.shouldRasterize = YES;
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
