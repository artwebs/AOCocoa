//
//  ArtFrameCellView.m
//  IOSDemo
//
//  Created by artwebs on 14-9-18.
//  Copyright (c) 2014年 artwebs. All rights reserved.
//

#import "ArtFrameCellView.h"

@implementation ArtFrameCellView
@synthesize params;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        params=[[NSMutableDictionary alloc]init];
    }
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
