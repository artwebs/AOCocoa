//
//  RemoteFactory.h
//  BusinessCard
//
//  Created by artwebs on 14-8-8.
//  Copyright (c) 2014年 artwebs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RData.h"
#import <UIKit/UIKit.h>
@protocol RemoteFactoryDelegate;
@interface RemoteFactory : NSObject
{
    NSOperationQueue *operationQueue;
    UIView *parentView;
}
@property (nonatomic,retain) id<RemoteFactoryDelegate> delegate;
-(id)initWithDelegate:(id<RemoteFactoryDelegate>)obj;
-(void)sendCommand:(RData *)cmd;
-(void)sendCommand:(RData *)cmd parent:(UIView *)pView;
-(void)sendCommandArray:(NSArray *)arr;
-(void)sendCommandArray:(NSArray *)arr parent:(UIView *)pView;
-(void)cancelAllOperation;
@end

@protocol RemoteFactoryDelegate <NSObject>
-(void)toResult:(NSArray *)arr;
@end