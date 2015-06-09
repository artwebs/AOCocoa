//
//  IServiceHttp.m
//  LuckyNumber
//
//  Created by artwebs on 14-6-11.
//  Copyright (c) 2014年 artwebs. All rights reserved.
//

#import "IServiceHttp.h"

@implementation IServiceHttp
@synthesize delegate;

-(id)initWithUrl:(NSString *)_url
{
    if (self=[super init]) {
        urlStr=_url;
    }
    return self;
}

-(void)sendMessage:(NSString *)params
{
    NSURL *url = [NSURL URLWithString:urlStr];
    //第二步，创建请求
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    NSData *data = [params dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    //第三步，连接服务器
    NSURLConnection *connection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
}
                                   
//接收到服务器回应的时候调用此方法
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse *res = (NSHTTPURLResponse *)response;
//    NSLog(@"%@",[res allHeaderFields]);
    receiveData = [NSMutableData data];
}

//接收到服务器传输数据的时候调用，此方法根据数据大小执行若干次
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [receiveData appendData:data];
}

//数据传完之后调用此方法
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *receiveStr = [[NSString alloc]initWithData:receiveData encoding:NSUTF8StringEncoding];
//    NSLog(@"connectionDidFinishLoading=%@",receiveStr);
    if (self.delegate) {
        [delegate successWithString:receiveStr];
    }
}

//网络请求过程中，出现任何错误（断网，连接超时等）会进入此方法
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
//    NSLog(@"%@",[error localizedDescription]);
    if (self.delegate) {
        [self.delegate failWithString:[error localizedDescription]];
    }
}

@end
