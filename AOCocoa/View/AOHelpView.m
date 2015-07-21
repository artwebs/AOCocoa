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
        UISwipeGestureRecognizer *recognizer;
        recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
        [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
        [self addGestureRecognizer:recognizer];
        
        recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
        [recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
        [self addGestureRecognizer:recognizer];
    }
    return self;
}

-(void)drawView
{
    NSUserDefaults *obj=[NSUserDefaults standardUserDefaults];
    if ([obj boolForKey:@"AOHelpViewLaunch"]) {
        [self setHidden:YES];
        return;
    }
    if (imageArr) {
        for (int i=(int)imageArr.count-1; i>=0; i--) {
            UIImageView *imageView=[[UIImageView alloc]initWithFrame:self.bounds];
            [imageView setImage:[UIImage imageNamed:[imageArr objectAtIndex:i]]];
            [self addSubview:imageView];
            [viewArr addObject:imageView];
        
        }
        [self addTarget:self action:@selector(viewOnClickListener:withEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [obj setBool:YES forKey:@"AOHelpViewLaunch"];
    [obj synchronize];
}

-(void)viewOnClickListener:(UIControl *) c withEvent:ev
{
    [self changeView];
}

- (IBAction)handleSwipeFrom:(UISwipeGestureRecognizer *)sender
{
    if(sender.direction==UISwipeGestureRecognizerDirectionLeft )
    {
        
    } else if(sender.direction==UISwipeGestureRecognizerDirectionRight)
    {
        
    }
    
    [self changeView];
}

-(void)changeView
{
    if ([[self subviews] count]>0) {
        UIImageView *imageView=[viewArr objectAtIndex:viewArr.count-1];
        [imageView removeFromSuperview];
        [viewArr removeObject:imageView];
    }else{
        [self setHidden:YES];
    }
}

@end
