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
#import <CommonCrypto/CommonCryptor.h>

@implementation SecurityAES
-(NSString *)encodeWithString:(NSString *)source key:(NSString *)key
{
    return [self encodeWithString:source key:key iv:[key substringToIndex:8]];
}

-(NSString *)encodeWithString:(NSString *)source key:(NSString *)key iv:(NSString *)iv
{
    NSData* data = [source dataUsingEncoding:NSUTF8StringEncoding];
    char keyPtr[kCCKeySizeAES256+1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [data length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding ,
                                          keyPtr, kCCBlockSizeAES128,
                                          [[iv dataUsingEncoding:NSUTF8StringEncoding] bytes],
                                          [data bytes], dataLength,
                                          buffer, bufferSize,
                                          &numBytesEncrypted);
    NSString *result = nil;

    if (cryptStatus == kCCSuccess) {
        result = [[NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted] base64Encoding];
        [ArtLog warnWithTag:@"SecurityAES encodeWithString" object:result];
        
    }
    free(buffer);
    return result;
}

-(NSString *)decodeWithString:(NSString *)source key:(NSString *)key
{
    return [self decodeWithString:source key:key iv:[key substringToIndex:8]];
}


-(NSString *)decodeWithString:(NSString *)source key:(NSString *)key iv:(NSString *)iv
{
    NSData *encryptData =[NSData dataWithBase64EncodedString:source];
    char keyPtr[kCCKeySizeAES256+1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [encryptData length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding ,
                                          keyPtr, kCCBlockSizeAES128,
                                          [[iv dataUsingEncoding:NSUTF8StringEncoding] bytes],
                                          [encryptData bytes], dataLength,
                                          buffer, bufferSize,
                                          &numBytesDecrypted);
    NSString *result = nil;
    if (cryptStatus == kCCSuccess) {
        result =  [[NSString alloc] initWithData:[NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted] encoding:NSUTF8StringEncoding];
        [ArtLog warnWithTag:@"SecurityAES decodeWithString" object:result];
        
    }
    free(buffer);
    return result;
}

@end
