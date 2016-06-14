//
//  FBEncryptorAES.h
//  AOCocoa
//
//  Created by 刘洪彬 on 16/6/14.
//  Copyright © 2016年 刘洪彬. All rights reserved.
//

#import <CommonCrypto/CommonCryptor.h>
#import <Foundation/Foundation.h>

#define FBENCRYPT_ALGORITHM     kCCAlgorithmAES128
#define FBENCRYPT_BLOCK_SIZE    kCCBlockSizeAES128
#define FBENCRYPT_KEY_SIZE      kCCKeySizeAES256

@interface FBEncryptorAES : NSObject
+ (NSData*)generateIv;
+ (NSData*)encryptData:(NSData*)data key:(NSData*)key iv:(NSData*)iv;
+ (NSData*)decryptData:(NSData*)data key:(NSData*)key iv:(NSData*)iv;
@end


