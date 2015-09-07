//
//  SecurityDES.h
//  BusinessCard
//
//  Created by artwebs on 14-7-24.
//  Copyright (c) 2014年 artwebs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h>
#import "Security.h"
typedef enum MODEL{
    ECB=0x0002,CBC=0x0000,PKCS7=0x0001
} MODEL;

@interface SecurityDES : Security
{
    MODEL model;
}
-(id)initWithMode:(int)mod;
-(NSString *)encodeWithString:(NSString *)source key:(NSString *)key;
-(NSString *)encodeWithString:(NSString *)source key:(NSString *)key iv:(NSString *)iv;
-(NSString *)decodeWithString:(NSString *)source key:(NSString *)key;
-(NSString *)decodeWithString:(NSString *)source key:(NSString *)key iv:(NSString *)iv;
@end
