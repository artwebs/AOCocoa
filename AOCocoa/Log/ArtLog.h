//
//  ArtLog.h
//  LuckyNumber
//
//  Created by artwebs on 14-6-17.
//  Copyright (c) 2014年 artwebs. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum {
    INFO=1,
    WARN=2,
    ERROR=3
} ArtLogLevel;
@interface ArtLog : NSObject
+(void)infoWithTag:(NSString *)tag object:(NSObject *)meg;
+(void)warnWithTag:(NSString *)tag object:(NSObject *)meg;
+(void)errorWithTag:(NSString *)tag object:(NSObject *)meg;
@end
