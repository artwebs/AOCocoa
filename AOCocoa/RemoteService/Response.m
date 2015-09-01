//
//  Response.m
//  LuckyNumber
//
//  Created by artwebs on 14-6-16.
//  Copyright (c) 2014年 artwebs. All rights reserved.
//

#import "Response.h"
#import "ArtLog.h"
static NSString *tag=@"Response";
@implementation Response
@synthesize source;
-(id)initWithSource:(NSString *)str
{
    if (self=[super init]) {
        self.source=str;
    }
    return self;
}

-(void)setSource:(NSString *)str
{
    if (source) {
        source=nil;
    }
    [ArtLog warnWithTag:@"Response" object:str];
    source=str;
    [self parse];
}

-(void)parse
{
    NSData *data=[source dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    resultObj=[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (resultObj==nil) {
        resultObj=[self getJSONWithError:[NSString stringWithFormat:@"%@",error]];
    }
    [ArtLog infoWithTag:tag object:resultObj];
}

-(NSDictionary *)getJSONWithError:(NSString *)err
{
    return [[NSDictionary alloc]initWithObjectsAndKeys:
            @"0",@"code",
            @"0",@"count",
            err,@"message",
            @"",@"result",
            nil];
}

-(BOOL)successed
{
    if ([@"1" isEqual:[NSString stringWithFormat:@"%@",[resultObj objectForKey:@"code"]]]) {
        return YES;
    }
    else
    {
        return NO;
    }
}

-(NSString *)getMessage
{
    return [resultObj objectForKey:@"message"];
}

-(NSObject *)getResultObject
{
    return [resultObj objectForKey:@"result"];
}



@end
