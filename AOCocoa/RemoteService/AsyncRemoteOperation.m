//
//  AsyncRemoteOperation.m
//  LuckyNumber
//
//  Created by artwebs on 14-6-16.
//  Copyright (c) 2014年 artwebs. All rights reserved.
//

#import "AsyncRemoteOperation.h"
#import "IServiceHttpSync.h"
#import "Utils.h"
@implementation AsyncRemoteOperation

-(id)initWithCommand:(RData *)cmd queue:(NSOperationQueue *)queue;
{
    if (self=[super init]) {
        _command=cmd;
        _queue=queue;
    }
    return self;
}

-(void)main
{
    [_command request];
    if (_command.children!=nil) {
        NSArray *childArr=_command.children;
        for (int i=0; i<[childArr count]; i++) {
            RData *childCmd=[childArr objectAtIndex:i];
            AsyncRemoteOperation *child=[[AsyncRemoteOperation alloc]initWithCommand:childCmd queue:_queue];
            [_queue addOperation:child];
        }
    }
}

@end
