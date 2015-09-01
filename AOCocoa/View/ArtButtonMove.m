//
//  ArtButtonMove.m
//  AppDemoHelper
//
//  Created by artwebs on 14-9-24.
//  Copyright (c) 2014年 artwebs. All rights reserved.
//

#import "ArtButtonMove.h"

@implementation ArtButtonMove
@synthesize parentView;

-(void)setParentView:(UIView *)view
{
    parentView=view;
    [self addTarget:self action:@selector(dragMoving:withEvent: )forControlEvents: UIControlEventTouchDragInside];
    [self addTarget:self action:@selector(dragEnded:withEvent: )forControlEvents: UIControlEventTouchUpInside |
     UIControlEventTouchUpOutside];
 
}

- (void) dragMoving: (UIControl *) c withEvent:ev
{
//    c.center = [[[ev allTouches] anyObject] locationInView:self.parentView];
}

- (void) dragEnded: (UIControl *) c withEvent:ev
{
    c.center = [[[ev allTouches] anyObject] locationInView:self.parentView];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
