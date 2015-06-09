//
//  ArtDragFramePlayView.m
//  IOSDemo
//
//  Created by artwebs on 14-9-18.
//  Copyright (c) 2014年 artwebs. All rights reserved.
//

#import "ArtFramePlayView.h"
#import "ArtFrameCellView.h"
#import "Utils.h"
@implementation ArtFramePlayView
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addTarget:self action:@selector(shortToShow:withEvent: ) forControlEvents:UIControlEventTouchDown];
    }
    return self;
}


-(ArtFrameCellView *)createView:(CGRect)frame
{
    ArtFrameCellView *v= [super createView:frame];
    [v addTarget:self action:@selector(viewOnClickListener:withEvent:) forControlEvents:UIControlEventTouchUpInside];
    return v;
}

-(void)drawView{
    [super drawView];
    [self hidden];
}


-(void)shortToShow:(ArtFrameCellView *) c withEvent:ev
{
    [self show];
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerToHidden:) userInfo:nil repeats:NO];
    [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(timerToShow:) userInfo:nil repeats:NO];
    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(timerToHidden:) userInfo:nil repeats:NO];
    [NSTimer scheduledTimerWithTimeInterval:2.5 target:self selector:@selector(timerToShow:) userInfo:nil repeats:NO];
    [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(timerToHidden:) userInfo:nil repeats:NO];
    if (self.delegate) {
        [self.delegate noneOnClickListener];
    }

//    [NSTimer timerWithTimeInterval:5 target:self selector:@selector(timerToHidden:) userInfo:nil repeats:NO];
}

-(void)show
{
    for (UIView *v in self.subviews) {
        if (v==bgImage) {
            continue;
        }
        v.layer.borderWidth = 1.0;
        v.backgroundColor=[UIColor colorWithRed:255 green:255 blue:255 alpha:0.4];
    }
}

-(void)timerToShow:(NSTimer *)timer
{
    [self show];
}

-(void)timerToHidden:(NSTimer *)timer
{
    [self hidden];
}

-(void)hidden
{
    for (UIView *v in self.subviews) {
        if (v==bgImage) {
            continue;
        }
        v.layer.borderWidth = 0.0;
        v.layer.borderColor=[UIColor greenColor].CGColor;
        v.backgroundColor=[UIColor colorWithRed:255 green:255 blue:255 alpha:0.0];
    }
    
}

-(void)viewOnClickListener:(ArtFrameCellView *) c withEvent:ev
{
    if (delegate) {
        [self.delegate viewOnClickListener:c];
    }
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
