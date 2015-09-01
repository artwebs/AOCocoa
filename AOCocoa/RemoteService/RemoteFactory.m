//
//  RemoteFactory.m
//  BusinessCard
//
//  Created by artwebs on 14-8-8.
//  Copyright (c) 2014年 artwebs. All rights reserved.
//

#import "RemoteFactory.h"
#import "ArtCircleProcessView.h"
#import "AsyncRemoteOperation.h"
@implementation RemoteFactory
@synthesize delegate;
-(id)init
{
    if (self=[super init]) {
        operationQueue=[[NSOperationQueue alloc] init];
        [operationQueue setMaxConcurrentOperationCount:20];
    }
    return self;
}

-(id)initWithDelegate:(id<RemoteFactoryDelegate>)obj
{
    if (self=[self init]) {
        self.delegate=obj;
    }
    return self;
}

-(void)sendCommand:(RData *)cmd
{
    [ self sendCommandArray:[[NSArray alloc] initWithObjects:cmd, nil]];
    
}

-(void)sendCommand:(RData *)cmd parent:(UIView *)pView
{
    [self sendCommandArray:[[NSArray alloc] initWithObjects:cmd, nil] parent:pView];
}

-(void)sendCommandArray:(NSArray *)arr
{
    NSThread *thread=[[NSThread alloc] initWithTarget:self selector:@selector(run:) object:arr];
    [thread start];
}

-(void)sendCommandArray:(NSArray *)arr parent:(UIView *)pView
{
    [ArtCircleProcessView showWithParent:pView message:@"正在加载数据"];
    [self sendCommandArray:arr];
}

-(void)run:(NSArray *)arr
{
    for (int i=0; i<[arr count]; i++) {
        RData *sigle=[arr objectAtIndex:i];
        if (sigle==nil) {
            continue;
        }
        [operationQueue addOperation:[[AsyncRemoteOperation alloc] initWithCommand:sigle queue:operationQueue]];
    }
    [operationQueue waitUntilAllOperationsAreFinished];
    if (delegate) {
        [self.delegate toResult:arr];
    }
    [ArtCircleProcessView hidden];
    
}

-(void)cancelAllOperation
{
    [operationQueue cancelAllOperations];
}
@end
