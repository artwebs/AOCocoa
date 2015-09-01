//
//  SecurityDES.m
//  BusinessCard
//
//  Created by artwebs on 14-7-24.
//  Copyright (c) 2014年 artwebs. All rights reserved.
//

#import "SecurityDES.h"
#import "NSData+Base64.h"
#import "ArtLog.h"
@implementation SecurityDES
-(id)init
{
    return [self initWithMode:ECB];
}

-(id)initWithMode:(int)mod
{
    if (self=[super initWithKeySize:kCCKeySize3DES blockSize:kCCBlockSize3DES]) {
        model=mod;
    }
    return self;
}

-(NSString *)encodeWithString:(NSString *)source key:(NSString *)key
{
    return [self encodeWithString:source key:key iv:@"00000000"];
}


-(NSString *)encodeWithString:(NSString *)source key:(NSString *)key iv:(NSString *)ivstr
{
    NSData* data = [source dataUsingEncoding:NSUTF8StringEncoding];
    size_t plainTextBufferSize = [data length];
    const void *vplainText = (const void *)[data bytes];
    
    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    
    const void *vkey = [self getKey:key];
    const void *vinitVec =[self getIV:ivstr];
    
    ccStatus = CCCrypt(kCCEncrypt,
                       kCCAlgorithm3DES,
                       model,
                       vkey,
                       kCCKeySize3DES,
                       vinitVec,
                       vplainText,
                       plainTextBufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);
    
    NSData *myData = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
    NSString *result = [myData base64Encoding];
    [ArtLog warnWithTag:@"SecurityDES encodeWithString" object:result];
    return result;
}

-(NSString *)decodeWithString:(NSString *)source key:(NSString *)key
{
    return [self decodeWithString:source key:key iv:@"00000000"];
}
          
            
-(NSString *)decodeWithString:(NSString *)source key:(NSString *)key iv:(NSString *)ivstr
{
    NSData *encryptData =[NSData dataWithBase64EncodedString:source];
    size_t plainTextBufferSize = [encryptData length];
    const void *vplainText = [encryptData bytes];
    
    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    
    const void *vkey = [self getKey:key];
    const void *vinitVec = [self getIV:ivstr];
    
    ccStatus = CCCrypt(kCCDecrypt,
                       kCCAlgorithm3DES,
                       model,
                       vkey,
                       kCCKeySize3DES,
                       vinitVec,
                       vplainText,
                       plainTextBufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);
    
    NSString *result = [[NSString alloc] initWithData:[NSData dataWithBytes:(const void *)bufferPtr
                                                                      length:(NSUInteger)movedBytes] encoding:NSUTF8StringEncoding];
//    [ArtLog warnWithTag:@"SecurityDES decodeWithString" object:[self removePadding:result]];
    return result;
}
@end
