//
//  ArtDragFrameView.h
//  IOSDemo
//
//  Created by artwebs on 14-9-17.
//  Copyright (c) 2014年 artwebs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArtFrameSuperView.h"
#import "ArtFrameCellView.h"
@protocol ArtFrameDragViewDelegate;
@interface ArtFrameDragView : ArtFrameSuperView<UIGestureRecognizerDelegate>
{
    NSMutableArray *viewDelArray;
    ArtFrameCellView *curView;
    ArtFrameCellView *touchView;
    
}
@property (nonatomic,retain) id<ArtFrameDragViewDelegate> delegate;
-(ArtFrameCellView *)currentView;
-(void)deleteCurrentView;
-(NSArray *)allViewPosition;
@end

@protocol ArtFrameDragViewDelegate <NSObject>

-(void)longPressView:(ArtFrameCellView *)view;

@end
