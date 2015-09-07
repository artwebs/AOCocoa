//
//  ServiceTask.m
//  BusinessCard
//
//  Created by artwebs on 14-8-11.
//  Copyright (c) 2014年 artwebs. All rights reserved.
//

#import "ServiceTask.h"
#import "ArtLog.h"
static NSOperationQueue *operationQueue;
static ServiceTask *task;
@implementation ServiceTask
@synthesize timer;
-(id)init
{
    self=[super init];
    isRun=false;
     count=0;
    if (self) {
        
    }
    return self;
}

-(void)main
{
    [[NSRunLoop currentRunLoop]run];
}


-(void)sendHeart:(NSTimer *)timer
{
    if (!isRun) {
        [self run];
    }
}

-(void)run
{
    [ArtLog warnWithTag:@"ServiceTask" object:@"ServiceTask........."];
}


+(void)start:(Class)vclass timeInterval:(NSTimeInterval)ti
{
    if (operationQueue==nil) {
        operationQueue=[[NSOperationQueue alloc]init];
        task=[[vclass alloc]init];
        task.timer=[NSTimer scheduledTimerWithTimeInterval:ti
                                                    target:task
                                                  selector:@selector(sendHeart:)
                                                  userInfo:nil
                                                   repeats:YES];
        [operationQueue addOperation:task];
        
    }
}

+(void)stop
{
    if (operationQueue) {
        [task.timer invalidate];
//        [operationQueue delete:task];
        task=nil;
        operationQueue=nil;
    }
}
@end
