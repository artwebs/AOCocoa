//
//  ArtCircleProcessView.m
//  LuckyNumber
//
//  Created by artwebs on 14-6-30.
//  Copyright (c) 2014年 artwebs. All rights reserved.
//

#import "ArtCircleProcessView.h"
#import "Utils.h"
static UIView *selView;
static UIView *parentView;
@implementation ArtCircleProcessView

-(id)initWithFrame:(CGRect)frame
{
    if (self=[self initWithFrame:frame message:nil]) {
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame message:(NSString *)meg
{
    if (self=[super initWithFrame:frame]) {
        playerView.frame=CGRectMake((size.width-200)*0.5f, (size.height-100)*0.5f, 200, 100);
        
        UILabel *megLabel=[[UILabel alloc] initWithFrame:CGRectZero];
        if (meg) {
            megLabel.text=meg;
        }
        CGSize labelSize=[Utils labelResize:megLabel];
        megLabel.frame=CGRectMake((size.width-labelSize.width)*0.5f+20, (size.height-labelSize.height)*0.5f, labelSize.width, labelSize.height);
        
        [contentView addSubview:megLabel];
        
        UIActivityIndicatorView *dialog=[[UIActivityIndicatorView alloc]initWithFrame:CGRectMake((size.width-(labelSize.width+40))*0.5f, (size.height-40)*0.5f, 40, 40)];
        dialog.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
        dialog.color=[UIColor blackColor];
        [dialog startAnimating];
        [contentView addSubview:dialog];
    }
    return self;
}

+(void)showWithParent:(UIView *)parent
{
    [self showWithParent:parent message:nil];
}

+(void)showWithParent:(UIView *)parent message:(NSString *)meg
{
    if (!selView) {
        selView=[[ArtCircleProcessView alloc]initWithFrame:parent.frame message:meg];
        parentView=parent;
        [parent addSubview:selView];
    }
}

+(void)hidden
{
    if (selView) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [selView removeFromSuperview];
                selView=nil;
            });
        });
        
    }
}

@end
