//
//  SecurityAES.m
//  AOCocoa
//
//  Created by 刘洪彬 on 16/6/13.
//  Copyright © 2016年 刘洪彬. All rights reserved.
//

#import "SecurityAES.h"
#import "NSData+Base64.h"
#import "ArtLog.h"
#import "FBEncryptorAES.h"
#import <CommonCrypto/CommonCryptor.h>

@implementation SecurityAES
-(id)init
{
    return [self initWithModel:ECB|PKCS7];
}

-(id)initWithModel:(MODEL)mod
{
    if(self= [super initWithKeySize:kCCKeySizeAES256 blockSize:kCCBlockSizeAES128]){
        model = mod;
    }
    return self;
}

-(NSString *)encodeWithString:(NSString *)source key:(NSString *)key
{
    return [self encodeWithString:source key:key iv:[key substringToIndex:16]];
}

-(NSString *)encodeWithString:(NSString *)source key:(NSString *)key iv:(NSString *)iv
{
    NSData* data = [source dataUsingEncoding:NSUTF8StringEncoding];
    NSString *result = nil;
    
    CCCryptorStatus ccStatus   = kCCSuccess;
    size_t          cryptBytes = 0;    // Number of bytes moved to buffer.
    NSMutableData  *dataOut    = [NSMutableData dataWithLength:data.length + kCCBlockSizeAES128];
    
    ccStatus = CCCrypt( kCCEncrypt,
                       kCCAlgorithmAES128,
                       model,
                       [self getKey:key],
                       kCCKeySizeAES256,
                       [self getIV:iv],
                       data.bytes,
                       data.length,
                       dataOut.mutableBytes,
                       dataOut.length,
                       &cryptBytes);
    if (ccStatus == kCCSuccess) {
        dataOut.length = cryptBytes;
        result = [dataOut base64Encoding];
    }
    
    return result;
}

-(NSString *)decodeWithString:(NSString *)source key:(NSString *)key
{
    return [self decodeWithString:source key:key iv:[key substringToIndex:16]];
}


-(NSString *)decodeWithString:(NSString *)source key:(NSString *)key iv:(NSString *)iv
{
    NSData *encryptData =[NSData dataWithBase64EncodedString:source];
    NSString *result = nil;
    
    CCCryptorStatus ccStatus   = kCCSuccess;
    size_t          cryptBytes = 0;    // Number of bytes moved to buffer.
    NSMutableData  *dataOut    = [NSMutableData dataWithLength:encryptData.length + kCCBlockSizeAES128];
    ccStatus = CCCrypt( kCCDecrypt,
                       kCCAlgorithmAES128,
                       model,
                       [self getKey:key],
                       kCCKeySizeAES256,
                       [self getIV:iv],
                       encryptData.bytes,
                       encryptData.length,
                       dataOut.mutableBytes,
                       dataOut.length,
                       &cryptBytes);
    if (ccStatus == kCCSuccess) {
        dataOut.length = cryptBytes;
        result =  [[NSString alloc] initWithData:dataOut encoding:NSUTF8StringEncoding];
    }
    return result;
}

@end
