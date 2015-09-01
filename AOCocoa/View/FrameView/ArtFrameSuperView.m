//
//  ArtFrameSuperView.m
//  IOSDemo
//
//  Created by artwebs on 14-9-18.
//  Copyright (c) 2014年 artwebs. All rights reserved.
//

#import "ArtFrameSuperView.h"
#import "Utils.h"
@implementation ArtFrameSuperView
@synthesize source;
-(id)initWithCoder:(NSCoder *)aDecoder {
    self=[super initWithCoder:aDecoder];
    return [self initWithFrame:[self frame]];
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //        CGSize size=[UIScreen mainScreen].bounds.size;
    }
    return self;
}

-(void)setSource:(NSMutableArray *)_source{
    if (source) {
        [source addObjectsFromArray:_source];
    }else
    {
        source=[NSMutableArray arrayWithArray:_source];
    }
}

-(void)drawView
{
    if (self.source) {
        for (NSDictionary *info in self.source) {
            ArtFrameCellView *view=[self createView:CGRectMake([[Utils Dictionary:info key:@"x"] floatValue], [[Utils Dictionary:info key:@"y"] floatValue],[[Utils Dictionary:info key:@"width"] intValue],[[Utils Dictionary:info key:@"height"] intValue])];
            view.params=[NSMutableDictionary dictionaryWithDictionary:[info objectForKey:@"params"]];
        }
    }
}
-(ArtFrameCellView *)createView:(CGRect)frame{
    return [self createView:frame params:nil];
}

-(ArtFrameCellView *)createView:(CGRect)frame params:(NSDictionary *)params
{
    ArtFrameCellView *v= [[ArtFrameCellView alloc] initWithFrame:frame];
    v.layer.borderWidth = 1.0;
    v.layer.borderColor=[UIColor greenColor].CGColor;
    v.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
    v.backgroundColor=[UIColor colorWithRed:255 green:255 blue:255 alpha:0.4];
    [v.params addEntriesFromDictionary:params];
    [self addSubview:v];
    return v;
}


-(void)deleteAllView
{
    for (UIView *v in self.subviews) {
        if (v==bgImage) {
            continue;
        }
        [v removeFromSuperview];
    }
}

-(void)setBgImage:(UIImage *)image
{
//    CGSize usize=[UIScreen mainScreen].bounds.size;
//    bgImage.frame=CGRectMake(0, 0, usize.width, usize.height);
    bgImage=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [self addSubview:bgImage];
    bgImage.image=image;
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
