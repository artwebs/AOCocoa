//
//  ArtDragFrameView.m
//  IOSDemo
//
//  Created by artwebs on 14-9-17.
//  Copyright (c) 2014年 artwebs. All rights reserved.
//

#import "ArtFrameDragView.h"
#import "Utils.h"
@implementation ArtFrameDragView
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        viewDelArray=[[NSMutableArray alloc]init];
        [self addTarget:self action:@selector(createDragStart:withEvent: ) forControlEvents:UIControlEventTouchDown];
//        CGSize size=[UIScreen mainScreen].bounds.size;
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



-(ArtFrameCellView *)createView:(CGRect)frame
{
    ArtFrameCellView *v= [super createView:frame];
    UILongPressGestureRecognizer *longPress =[[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                           action:@selector(handleTableviewCellLongPressed:)];
    longPress.delegate = self;
    longPress.minimumPressDuration = 0.5;
    //将长按手势添加到需要实现长按操作的视图里
    [v addGestureRecognizer:longPress];
    
    [v addTarget:self action:@selector(dragStart:withEvent: )forControlEvents: UIControlEventTouchDown];
    [v addTarget:self action:@selector(dragMoving:withEvent: )forControlEvents: UIControlEventTouchDragInside];
    [v addTarget:self action:@selector(dragEnded:withEvent: )forControlEvents: UIControlEventTouchUpInside |
     UIControlEventTouchUpOutside];
    return v;
}

-(void)createDragStart:(UIControl *) c withEvent:ev
{
    ArtFrameCellView *v= [self createView:CGRectMake(0, 0, 100, 50)];
    v.center=[[[ev allTouches] anyObject] locationInView:self];
}

-(void)dragStart:(ArtFrameCellView *) c withEvent:ev
{
    
    touchView=c;
    if (curView&&curView!=touchView) {
        curView.layer.borderColor=[UIColor greenColor].CGColor;
        curView=nil;
    }
    touchView.layer.borderColor=[UIColor redColor].CGColor;
}

- (void) dragMoving: (ArtFrameCellView *) c withEvent:ev
{
    CGPoint pos=[[[ev allTouches] anyObject] locationInView:self];
    CGPoint opos=c.frame.origin;
    CGSize  size=c.frame.size;
    
    CGPoint cpos=CGPointMake(opos.x+c.frame.size.width/2, opos.y+c.frame.size.height/2);
    float len=sqrt(pow( cpos.x - pos.x , 2 )+pow( cpos.y - pos.y , 2 ));
    float or=size.width<size.height?size.width/2:size.height/2;
    
    if (len<or) {
        c.center = [[[ev allTouches] anyObject] locationInView:self];
    }else{
        float width=pos.x-opos.x;
        width=width<40?40:width;
        float heigth=pos.y-opos.y;
        heigth=heigth<40?40:heigth;
        c.frame=CGRectMake(opos.x,opos.y,width,heigth);
    }
    
}

- (void) dragEnded: (ArtFrameCellView *) c withEvent:ev
{
      touchView.layer.borderColor=[UIColor greenColor].CGColor;
        if (curView) {
            curView.layer.borderColor=[UIColor greenColor].CGColor;
            curView=nil;
        }
}



-(ArtFrameCellView *)currentView
{
    return curView;
}

-(void)deleteCurrentView
{
    if (curView) {
        [curView removeFromSuperview];
    }
}


-(NSArray *)allViewPosition
{
    NSMutableArray *arr=[[NSMutableArray alloc]init];
    for (UIView *v in self.subviews) {
        if (v==bgImage) {
            continue;
        }
        CGSize size=v.frame.size;
        CGPoint pos=v.frame.origin;
        
        [arr addObject:@{
                         @"x": [NSString stringWithFormat:@"%f",pos.x],
                         @"y":[NSString stringWithFormat:@"%f",pos.y],
                         @"width":[NSString stringWithFormat:@"%f",size.width],
                         @"height":[NSString stringWithFormat:@"%f",size.height],
                         @"params":((ArtFrameCellView *)v).params}];
        
    }
    return arr;
}

//长按事件的实现方法
- (void) handleTableviewCellLongPressed:(UILongPressGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state ==
        UIGestureRecognizerStateBegan) {
//        NSLog(@"UIGestureRecognizerStateBegan");
//        CGPoint p = [(UILongPressGestureRecognizer *)gestureRecognizer locationInView:tweetieTableView];
        if (touchView) {
            touchView.layer.borderColor=[UIColor redColor].CGColor;
            curView=touchView;
            if (delegate) {
                [delegate longPressView:touchView];
            }
        }
//        NSLog(@"UIGestureRecognizerStateBegan %@",curView);
//        if (touchView.layer.borderColor!=[UIColor redColor].CGColor) {
//            touchView.layer.borderColor=[UIColor redColor].CGColor;
//            curView=touchView;
//        }else
//        {
//            touchView.layer.borderColor=[UIColor greenColor].CGColor;
//            curView=nil;
//        }
        
    }
    if (gestureRecognizer.state ==
        UIGestureRecognizerStateChanged) {
//        NSLog(@"UIGestureRecognizerStateChanged");
    }
    
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
//        NSLog(@"UIGestureRecognizerStateEnded");
    }
    
}

@end
