//
//  ArtCircleProcessView.h
//  LuckyNumber
//
//  Created by artwebs on 14-6-30.
//  Copyright (c) 2014年 artwebs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArtView.h"
@interface ArtCircleProcessView : ArtView
{
    
}
-(id)initWithFrame:(CGRect)frame message:(NSString *)meg;
+(void)showWithParent:(UIView *)parent;
+(void)showWithParent:(UIView *)parent message:(NSString *)meg;
+(void)hidden;

@end
