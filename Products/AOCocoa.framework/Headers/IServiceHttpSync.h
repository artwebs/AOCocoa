//
//  IServiceHttpSync.h
//  LuckyNumber
//
//  Created by artwebs on 14-6-17.
//  Copyright (c) 2014年 artwebs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IService.h"
@interface IServiceHttpSync :NSObject<IService>
{
    NSString *urlStr;
}
-(id)initWithUrl:(NSString *)_url;
-(NSString *)sendMessage:(NSString *)params;
-(NSString *)sendParems: (NSMutableDictionary *)postParems;
-(NSString *)sendParems: (NSMutableDictionary *)postParems imageDict:(NSMutableDictionary *) dicImages;
@end
