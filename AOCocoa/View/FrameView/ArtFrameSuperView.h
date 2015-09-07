//
//  ArtFrameSuperView.h
//  IOSDemo
//
//  Created by artwebs on 14-9-18.
//  Copyright (c) 2014年 artwebs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArtFrameCellView.h"
@interface ArtFrameSuperView : UIControl
{
    
    UIImageView *bgImage;
}
@property (nonatomic,retain) NSMutableArray * source;
-(void)setBgImage:(UIImage *)image;
-(void)drawView;
-(void)deleteAllView;
-(ArtFrameCellView *)createView:(CGRect)frame;
-(ArtFrameCellView *)createView:(CGRect)frame params:(NSDictionary *)params;
@end
