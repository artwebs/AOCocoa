//
//  RData.m
//  BusinessCard
//
//  Created by artwebs on 14-8-8.
//  Copyright (c) 2014年 artwebs. All rights reserved.
//

#import "RData.h"
@implementation RData
@synthesize children;
-(id)initWithFun:(NSString *)fun params:(NSString *)params
{
    if (self=[super init]) {
        _fun=fun;
        _params=params;
    }
    return self;
}

-(NSString *)getController
{
    return _fun;
}

-(void)setParams:(NSString *)params
{
    _params=params;
}

-(NSString *)getParams
{
    return _params;
}

-(id<IService> )buildService
{
    return nil;
    //    return [[IServiceHttpSync alloc]initWithUrl:@"http://192.168.119.122/phone!reqCode.action"];
}



-(Response *)buildResponse
{
    return [[Response alloc]init];
}

-(RData *)setCallObj:(id<RDataCallback>)obj
{
    if (callObj) {
        callObj=nil;
    }
    callObj=obj;
    return self;
}

-(id<RDataCallback>)getCallObj;
{
    return callObj;
}

-(void)request
{
    NSString *rs=[[self buildService] sendMessage:[self getParams]];
    self.response=[self buildResponse];
    self.response.source=rs;
    if ([self getCallObj]) {
        [[self getCallObj] sendMessage:self];
    }
}

+(RData *)instanceFun:(NSString *)fun params:(NSString *)params
{
    return [[RData alloc]initWithFun:fun params:params];
}




@end


