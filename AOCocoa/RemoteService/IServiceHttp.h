//
//  IServiceHttp.h
//  LuckyNumber
//
//  Created by artwebs on 14-6-11.
//  Copyright (c) 2014年 artwebs. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol IServiceHttpCallBack;
@interface IServiceHttp : NSObject<NSURLConnectionDataDelegate>
{
    NSString *urlStr;
    NSMutableData *receiveData;
}
@property (nonatomic,retain) id<IServiceHttpCallBack> delegate;
-(id)initWithUrl:(NSString *)_url;
-(void)sendMessage:(NSString *)params;
@end


@protocol IServiceHttpCallBack <NSObject>
-(void)successWithString:(NSString *)str;
-(void)failWithString:(NSString *)str;
@end