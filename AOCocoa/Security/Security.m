//
//  Security.m
//  BusinessCard
//
//  Created by artwebs on 14-7-24.
//  Copyright (c) 2014年 artwebs. All rights reserved.
//

#import "Security.h"
#import "ArtLog.h"
#import <CommonCrypto/CommonCryptor.h>
@implementation Security
-(id)initWithKeySize:(int)kSize blockSize:(int)bSize
{
    if (self=[super init]) {
        keySize=kSize;
        blockSize=bSize;
    }
    return self;
}

-(const void *)getKey:(NSString *)keyStr
{
    const char *keyBytes = [keyStr UTF8String];
    int klen = (int)[keyStr length];
    int len=0;
    NSMutableData *rs=[[NSMutableData alloc]init];
    while (keySize-len>0) {
        len+=klen;
        [rs appendBytes:keyBytes length:(keySize-len)<0?(klen-(len-keySize)):klen];
    }
    return [rs bytes];
}
-(const void *)getIV:(NSString *)ivStr
{
    const char *keyBytes = [ivStr UTF8String];
    int klen = (int)[ivStr length];
    int len=0;
    NSMutableData *rs=[[NSMutableData alloc]init];
    while (blockSize-len>0) {
        len+=klen;
        [rs appendBytes:keyBytes length:(blockSize-len)<0?(klen-(len-blockSize)):klen];
    }
    return [rs bytes];
}


-(int)getPaddingByte:(int)size
{
    return blockSize-(size%blockSize);
}

-(NSString *)appendPadding:(NSString *)str
{
    int len=(int)[str length];
    int padByte=[self getPaddingByte:len];
    NSMutableString *string=[NSMutableString stringWithString:str];
    for (int i=0; i<padByte; i++) {
        [string appendFormat:@"%c",padByte];
    }
    return string;
}

-(NSString *)removePadding:(NSString *)str
{
    int len=(int)[str length];
    int padByte=[str characterAtIndex:len-1];
    NSString *rs;
    if (padByte>len||padByte>blockSize) {
        [ArtLog warnWithTag:@"Security removePadding" object:[NSString stringWithFormat:@"padByte 过大%d",padByte]];
        return rs;
    }else
    {
        rs=[str substringToIndex:len-padByte];
    }
    return rs;
}

@end
