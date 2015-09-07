//
//  ArtView.h
//  LuckyNumber
//
//  Created by artwebs on 14-7-3.
//  Copyright (c) 2014年 artwebs. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSUInteger, Rrelative) {
    RrelativeTop    =1<<0,
    RrelativeLeft   =1<<1,
    RrelativeRight  =1<<2,
    RrelativeBlow   =1<<3
};

typedef NS_OPTIONS(NSUInteger, Align) {
    AlignTop                =1<<0,
    AlignLeft               =1<<1,
    AlignRight              =1<<2,
    AlignBlow               =1<<3,
    AlignCenterVertical     =1<<4,
    AlignCenterHorizontal   =1<<5,
    AlignCenter             =1<<6,
    
};

typedef NS_OPTIONS(NSUInteger, AlignParent) {
    AlignParentCenterVertical =1<<0,
    AlignParentCenterHorizontal =1<<1,
};

typedef NS_OPTIONS(NSUInteger, WidthHeight)
{
    width   =1<<0,
    height  =1<<1
};


@interface ArtView : UIControl
{
    UIView *contentView;
    UIView *playerView;
    CGSize size;
    UIView *canvasView;
}
-(void)addView:(UIView *)view;
-(CGSize)getMatchSize;
-(CGSize)getMatchSize:(UIView *)view;
/*
 根据子类增加父类大小
 */
-(void)matchLayout:(float)margin;
-(void)matchLayout:(UIView *)view margin:(float)margin;
/*
 长宽设为父类的填充
 */
-(void)view:(UIView *)view fillParent:(WidthHeight)param margin:(float)mar;

-(void)drawPlayView;
-(void)drawPlayView:(float)margin;
-(void)view:(UIView *)view relativeView:(UIView *)rview relative:(Rrelative)rel margin:(float)mar;
-(void)view:(UIView *)view relativeView:(UIView *)rview align:(Align)rel;
-(void)view:(UIView *)view relativeParentalign:(AlignParent)rel;

-(UIViewController *)superViewController;

@end
