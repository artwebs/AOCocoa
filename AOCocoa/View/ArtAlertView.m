//
//  ArtAlertView.m
//  AppDemoHelper
//
//  Created by artwebs on 14-9-25.
//  Copyright (c) 2014年 artwebs. All rights reserved.
//

#import "ArtAlertView.h"

@implementation ArtAlertView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

//-(void)drawPlayView
//{
//    pheigth+=margin;
//    pwidth+=margin;
//    playerView.frame=CGRectMake(20, 20, pwidth, pheigth);
//    playerView.center=CGPointMake(contentView.frame.size.width/2, contentView.frame.size.height/2);
//}




- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    return YES;
}
@end
