//
//  Utilities.h
//  iFrameExtractor
//
//  Created by lajos on 1/10/10.
//
//  Copyright 2010 Lajos Kamocsay
//
//  lajos at codza dot com
//
//  iFrameExtractor is free software; you can redistribute it and/or
//  modify it under the terms of the GNU Lesser General Public
//  License as published by the Free Software Foundation; either
//  version 2.1 of the License, or (at your option) any later version.
// 
//  iFrameExtractor is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
//  Lesser General Public License for more details.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Utils : NSObject {

}

+(NSString *)bundlePath:(NSString *)fileName;
+(NSString *)documentsPath:(NSString *)fileName;

+(unsigned char *)getBytesWithLong:(long long)newLong asc:(BOOL)asc;
+(long long)getLongWithBytes:(unsigned char *)buf size:(int)size asc:(BOOL)asc;

+(NSDate *)fileTime2Date:(long long)newLong;
+(long long)date2FileTime:(NSDate *)dateTime;

+(NSString *)nowTime;
+(NSString *)nowTimeWithFormate:(NSString *)formate;
+(NSString *)timeWith:(NSString *)dateStr addend:(int)num;
+(NSString *)timeWith:(NSString *)dateStr addend:(int)num formate:(NSString *)formate;

+(NSString *)base64EncodeWithString:(NSString *)str;
+(NSString *)base64DecodeWithString:(NSString *)str;

+(NSString *)urlEncodeWithString:(NSString *)str;
+(NSString *)urlDecodeWithString:(NSString *)str;

+(void)deleteSerializeValue:(NSString *)key;
+(NSString *)readSerializeValue:(NSString *)key;
+(void)saveSerializeValue:(NSString *)key value:(NSString *)value;

+(NSString *)Dictionary:(NSDictionary *)dic key:(NSString *)key;

+(NSString *)JSONObjectToString:(NSObject *)obj;
+(NSString *)JSONObjectToString:(NSObject *)obj options:(NSJSONWritingOptions)opt;
+(id)JSONOjbectFromString:(NSString *)str;

+(CGSize)labelResize:(UILabel *)aLabel;

+(NSString *)toString:(NSObject *)obj;
+(NSString *)toString:(NSObject *)obj default:(NSString *)dValue;

+(UIImage *) imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize) newSize;

+ (UIImage *)readImage:(NSString *)imageName;
+(NSString *)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName;

+(void)callPhone:(NSString *)phone;
+(void)sendSMS:(NSString *)phone;

+(CGColorRef) colorFromRed:(int)red Green:(int)green Blue:(int)blue Alpha:(int)alpha;

+ (UIImage *)createImageWithColor:(UIColor *)color;
+ (UIImage *)createImageWithColor:(UIColor *)color rect:(CGRect)rect;

+(CGSize)stringLength:(NSString *)string fontSize:(float)size;

+(void)clearCatche;
+(UIImage *)loadImageCacheWithUrl:(NSString *)urlString defaultImage:(NSString *)imageName;
+(void)loadImageCacheWithUrl:(NSString *)urlString callback:(void(^)(UIImage *))callback;
+(UIImage *)loadImageCacheWithUrl:(NSString *)urlString defaultImage:(NSString *)imageName expireInterval:(long) interval;

+(UIImage*)captureView:(UIView *)theView frame:(CGRect)fra;

+ (NSString *) localIPAddress;
+ (NSString *) localWiFiIPAddress;
@end
