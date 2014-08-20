//
//  BezierPath.m
//  Dropit
//
//  Created by myqiqiang on 14-6-16.
//  Copyright (c) 2014年 myqiqiang. All rights reserved.
//

#import "BezierPath.h"

@implementation BezierPath

-(void)setPath:(UIBezierPath *)path
{
    _path = path;
    [self setNeedsDisplay];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    [self.path stroke];
}


@end
