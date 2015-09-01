//
//  ServiceTask.h
//  BusinessCard
//
//  Created by artwebs on 14-8-11.
//  Copyright (c) 2014年 artwebs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServiceTask : NSOperation
{
    
    BOOL isRun;
    int count;
}
@property (nonatomic,retain) NSTimer *timer;
+(void)start:(Class)vclass timeInterval:(NSTimeInterval)ti;
+(void)stop;
-(void)run;
@end
