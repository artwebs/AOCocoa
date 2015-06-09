//
//  RData.h
//  BusinessCard
//
//  Created by artwebs on 14-8-8.
//  Copyright (c) 2014年 artwebs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IService.h"
#import "Response.h"
@protocol RDataCallback;
@interface RData : NSObject
{
    NSString *_fun;
    NSString *_params;
    id<RDataCallback> callObj;
}
@property (nonatomic,assign) int sn;
@property (nonatomic,retain) NSArray *children;
@property (nonatomic,retain) Response *response;
-(id)initWithFun:(NSString *)fun params:(NSString *)params;
-(NSString *)getController;
-(void)setParams:(NSString *)params;
-(NSString *)getParams;
-(id<IService> )buildService;
-(Response *)buildResponse;
-(RData *)setCallObj:(id<RDataCallback>)obj;
-(id<RDataCallback>)getCallObj;
-(void)request;

+(RData *)instanceFun:(NSString *)fun params:(NSString *)params;




@end

@protocol RDataCallback <NSObject>

-(void)sendMessage:(RData *)cmd;

@end
