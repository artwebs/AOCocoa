//
//  ArtView.m
//  LuckyNumber
//
//  Created by artwebs on 14-7-3.
//  Copyright (c) 2014年 artwebs. All rights reserved.
//

#import "ArtView.h"
#import "ArtLog.h"
static NSString *tag=@"ArtView";
@implementation ArtView

-(id)initWithCoder:(NSCoder *)aDecoder {
    self=[super initWithCoder:aDecoder];
    return [self initWithFrame:[self frame]];
}

-(id)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        size=[UIScreen mainScreen].bounds.size;
        contentView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
        contentView.backgroundColor=[UIColor colorWithRed:255 green:255 blue:255 alpha:0.4];
        [self addSubview:contentView];
        
        playerView=[[UIView alloc] initWithFrame:CGRectMake(20, 20, contentView.frame.size.width-40, contentView.frame.size.height-40)];
        playerView.layer.borderWidth = 1.0;
        playerView.center = CGPointMake(size.width/2, size.height/2);
        playerView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
        playerView.layer.backgroundColor = [UIColor whiteColor].CGColor;
        playerView.layer.cornerRadius = 10.0;
        [contentView addSubview:playerView];
    }
    return self;
}


-(void)addView:(UIView *)view
{
    if (!canvasView) {
        canvasView=[[UIView alloc]init];
    }
    [canvasView addSubview:view];
}

-(CGSize)getMatchSize
{
    return [self getMatchSize:canvasView];
}

-(CGSize)getMatchSize:(UIView *)view
{
    float maxWidth=view.frame.size.width,maxheight=view.frame.size.height;
    if (view)
        for (UIView *v in view.subviews) {
            if (v.frame.origin.x+v.frame.size.width>maxWidth)maxWidth=v.frame.origin.x+v.frame.size.width;
            if (v.frame.origin.y+v.frame.size.height>maxheight)maxheight=v.frame.origin.y+v.frame.size.height;
        }
    return CGSizeMake(maxWidth, maxheight);
}

-(void)matchLayout:(float)margin
{
    return [self matchLayout:canvasView margin:margin];
}

-(void)matchLayout:(UIView *)view margin:(float)margin
{
    CGSize max=[self getMatchSize:view];
    view.frame=CGRectMake(margin, margin, max.width+margin, max.height+margin);
}

-(void)view:(UIView *)view fillParent:(WidthHeight)param margin:(float)mar
{
    CGSize max=[self getMatchSize:view.superview];
    CGSize osize=view.frame.size;
    if(param&width)view.frame=CGRectMake(mar, 0, max.width-2*mar, osize.height);
    if (param&height)view.frame=CGRectMake(0,mar, osize.width, max.height-2*mar);
}

-(void)drawPlayView
{
    [self drawPlayView:20];
}

-(void)drawPlayView:(float)margin
{
    CGSize max=[self getMatchSize];
    [self matchLayout:margin];
    [playerView addSubview:canvasView];
    playerView.frame=CGRectMake(0, 0, max.width+2*margin, max.height+2*margin);
    playerView.center=CGPointMake(contentView.frame.size.width/2, contentView.frame.size.height/2);
    
}



-(void)view:(UIView *)view relativeView:(UIView *)rview relative:(Rrelative)rel margin:(float)mar
{
    CGSize osize=view.frame.size;
    CGPoint opos=view.frame.origin;
    CGSize rsize=rview.frame.size;
    CGPoint rpos=rview.frame.origin;
    if (rel&RrelativeTop)view.frame=CGRectMake(opos.x, rpos.y-(mar+osize.height), osize.width, osize.height);
    if (rel&RrelativeLeft)view.frame=view.frame=CGRectMake(rpos.x-(osize.width+mar), opos.y, osize.width, osize.height);
    if (rel&RrelativeRight)view.frame=view.frame=CGRectMake(rpos.x+mar+rsize.width, opos.y, osize.width, osize.height);
    if (rel&RrelativeBlow)view.frame=CGRectMake(opos.x, rpos.y+rsize.height+mar, osize.width, osize.height);
//    [ArtLog warnWithTag:tag object:[NSString stringWithFormat:@"x=%f,y=%f,w=%f,h=%f",view.frame.origin.x,view.frame.origin.y,view.frame.size.width,view.frame.size.height]];
}

-(void)view:(UIView *)view relativeView:(UIView *)rview align:(Align)rel
{
    CGSize osize=view.frame.size;
    CGPoint opos=view.frame.origin;
    CGSize rsize=rview.frame.size;
    CGPoint rpos=rview.frame.origin;
    if (rel&AlignTop)view.frame=CGRectMake(opos.x, rpos.y, osize.width, osize.height);
    if (rel&AlignLeft)view.frame=CGRectMake(rpos.x, opos.y, osize.width, osize.height);
    if (rel&AlignRight)view.frame=CGRectMake(rpos.x+(rpos.x+rsize.width-osize.width), opos.y, osize.width, osize.height);
    if (rel&AlignBlow)view.frame=CGRectMake(opos.x,(rpos.y+rsize.height-osize.height), osize.width, osize.height);
    
    if (rel&AlignCenterHorizontal)
        view.frame=CGRectMake(rsize.width/2-osize.width/2,opos.y, osize.width, osize.height);
    
    if (rel&AlignCenterVertical)
        view.frame=CGRectMake(rpos.x,rsize.height/2-osize.height/2, osize.width, osize.height);
    if (rel&AlignCenter)
        view.frame=CGRectMake(rsize.width/2-osize.width/2,rsize.height/2-osize.height/2, osize.width, osize.height);
    

}

-(void)view:(UIView *)view relativeParentalign:(AlignParent)rel
{
    CGSize osize=view.frame.size;
    CGPoint opos=view.frame.origin;
    CGSize max=[self getMatchSize:view.superview];
    if (rel&AlignParentCenterHorizontal)
        view.frame=CGRectMake(max.width/2-osize.width/2,opos.y, osize.width, osize.height);
    if (rel&AlignParentCenterVertical)
        view.frame=CGRectMake(opos.x,max.height/2-osize.height/2, osize.width, osize.height);;
    
//    [ArtLog warnWithTag:tag object:[NSString stringWithFormat:@"x=%f,y=%f,w=%f,h=%f",view.frame.origin.x,view.frame.origin.y,view.frame.size.width,view.frame.size.height]];
}

-(UIViewController *)superViewController
{
    id object = [self nextResponder];
    
    
    
    while (![object isKindOfClass:[UIViewController class]] &&
           
           object != nil) {
        
        object = [object nextResponder];
        
    }
    
    
    
    return (UIViewController*)object;
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
