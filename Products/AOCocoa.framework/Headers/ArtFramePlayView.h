//
//  ArtDragFramePlayView.h
//  IOSDemo
//
//  Created by artwebs on 14-9-18.
//  Copyright (c) 2014年 artwebs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArtFrameSuperView.h"
#import "ArtFrameCellView.h"
@protocol ArtFramePlayViewDelegate;
@interface ArtFramePlayView : ArtFrameSuperView
{
   
}

@property (nonatomic,retain) id<ArtFramePlayViewDelegate> delegate;
-(void)show;
-(void)hidden;
@end

@protocol ArtFramePlayViewDelegate <NSObject>
-(void)viewOnClickListener:(ArtFrameCellView *)v;
-(void)noneOnClickListener;
@end