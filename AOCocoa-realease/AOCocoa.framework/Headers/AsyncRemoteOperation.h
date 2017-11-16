//
//  AsyncRemoteOperation.h
//  LuckyNumber
//
//  Created by artwebs on 14-6-16.
//  Copyright (c) 2014年 artwebs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RData.h"
@interface AsyncRemoteOperation : NSOperation
{
    RData *_command;
    NSOperationQueue *_queue;
}

-(id)initWithCommand:(RData *)cmd queue:(NSOperationQueue *)queue;

@end
