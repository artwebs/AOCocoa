//
//  HelpView.m
//  AOCocoa
//
//  Created by 刘洪彬 on 15/7/14.
//  Copyright (c) 2015年 刘洪彬. All rights reserved.
//

#import "AOHelpView.h"
#import <UIKit/UIKit.h>

@implementation AOHelpView
@synthesize imageArr;
-(id)initWithCoder:(NSCoder *)aDecoder {
    self=[super initWithCoder:aDecoder];
    return [self initWithFrame:[self frame]];
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        viewArr=[[NSMutableArray alloc]init];
    }
    return self;
}

-(void)drawView
{
    
//    if (![[NSUserDefaultsstandardUserDefaults] boolForKey:@"everLaunched"]) {
//        
//        [[NSUserDefaultsstandardUserDefaults] setBool:YES forKey:@"everLaunched"];
//        
//        [[NSUserDefaultsstandardUserDefaults] setBool:YES forKey:@"firstLaunch"];
//        
//        NSLog(@"first launch");
//        
//    }else {
//        
//        [[NSUserDefaultsstandardUserDefaults] setBool:NO forKey:@"firstLaunch"];
//        
//        NSLog(@"second launch");
//        
//    }
    if (imageArr) {
        for (int i=(int)imageArr.count-1; i>=0; i--) {
            UIImageView *imageView=[[UIImageView alloc]initWithFrame:self.bounds];
            [imageView setImage:[UIImage imageNamed:[imageArr objectAtIndex:i]]];
            [self addSubview:imageView];
            [viewArr addObject:imageView];
        
        }
        [self addTarget:self action:@selector(viewOnClickListener:withEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
}

-(void)viewOnClickListener:(UIControl *) c withEvent:ev
{
    if ([[self subviews] count]>0) {
        UIImageView *imageView=[viewArr objectAtIndex:viewArr.count-1];
        [imageView removeFromSuperview];
        [viewArr removeObject:imageView];
    }
}


@end
