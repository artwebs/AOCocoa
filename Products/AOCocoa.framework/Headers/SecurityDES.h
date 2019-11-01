//
//  SecurityDES.h
//  BusinessCard
//
//  Created by artwebs on 14-7-24.
//  Copyright (c) 2014年 artwebs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Security.h"


@interface SecurityDES : Security
{
    MODEL model;
}
-(id)initWithModel:(int)mod;
-(NSString *)encodeWithString:(NSString *)source key:(NSString *)key;
-(NSString *)encodeWithString:(NSString *)source key:(NSString *)key iv:(NSString *)iv;
-(NSString *)decodeWithString:(NSString *)source key:(NSString *)key;
-(NSString *)decodeWithString:(NSString *)source key:(NSString *)key iv:(NSString *)iv;
@end
