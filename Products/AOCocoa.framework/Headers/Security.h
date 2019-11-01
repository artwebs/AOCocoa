//
//  Security.h
//  BusinessCard
//
//  Created by artwebs on 14-7-24.
//  Copyright (c) 2014年 artwebs. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum MODEL{
    ECB=0x0002,CBC=0x0000,PKCS7=0x0001
} MODEL;
@interface Security : NSObject
{
    int keySize;
    int blockSize;
}
-(id)initWithKeySize:(int)keySize blockSize:(int)blockSize;
-(const void *)getKey:(NSString *)keyStr;
-(const void *)getIV:(NSString *)ivStr;

-(int)getPaddingByte:(int)size;
-(NSString *)appendPadding:(NSString *)str;
-(NSString *)removePadding:(NSString *)str;
@end
