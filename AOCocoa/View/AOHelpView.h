//
//  HelpView.h
//  AOCocoa
//
//  Created by 刘洪彬 on 15/7/14.
//  Copyright (c) 2015年 刘洪彬. All rights reserved.
//

#import <AOCocoa/AOCocoa.h>
@protocol AOHelpViewDelegate;
@interface AOHelpView : UIControl
{
    NSMutableArray *viewArr;
}
@property (nonatomic,retain) NSMutableArray *imageArr;
@property (nonatomic,retain) id<AOHelpViewDelegate> delegate;
-(void)drawView;
@end

@protocol AOHelpViewDelegate <NSObject>
-(void)showOver;
-(void)jumpOver;
@end
