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
    NSString *urlStr,*codeField,*encryptField,*countField,*messageField,*dataField;
}
-(id)initWithUrl:(NSString *)_url;
-(id)initWithUrl:(NSString *)_url field:(NSArray *)field;
-(NSString *)sendMessage:(NSString *)params;
-(NSString *)sendPath:(NSString *)_path Message:(NSString *)params;
-(NSString *)sendParems: (NSMutableDictionary *)postParems;
-(NSString *)sendPath:(NSString *)_path Parems: (NSMutableDictionary *)postParems;
-(NSString *)sendPath:(NSString *)_path Parems: (NSMutableDictionary *)postParems imageDict:(NSMutableDictionary *) dicImages;
-(NSString *)sendPath:(NSString *)_path Parems: (NSMutableDictionary *)postParems imageDict:(NSMutableDictionary *)dicImages Header:(NSMutableDictionary *)headerData Response: (NSHTTPURLResponse *) urlResponse;
@end
