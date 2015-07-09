//
//  Utilities.m
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

#import "Utils.h"


@implementation Utils

+(NSString *)bundlePath:(NSString *)fileName {
	return [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:fileName];
}

+(NSString *)documentsPath:(NSString *)fileName {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	return [documentsDirectory stringByAppendingPathComponent:fileName];
}

+(unsigned char *)getBytesWithLong:(long long)newLong asc:(BOOL)asc
{
    int len=8;
    unsigned char * buf=(unsigned char *)malloc(len);
    if (asc) {
        for (int i=len-1; i>=0; i--) {
            buf[i] = (newLong & 0x00000000000000ff);
	        newLong >>= 8;
        }
    }else
    {
        for (int i=0; i<len; i++) {
            buf[i] = (newLong & 0x00000000000000ff);
	        newLong >>= 8;
        }
    }
    return  buf;
}

+(long long)getLongWithBytes:(unsigned char *)buf size:(int)size asc:(BOOL)asc
{
    long long rs=0;
    if (asc) {
        for (int i=size-1; i>=0; i--) {
            rs <<= 8;
            rs |= (buf[i] & 0x00000000000000ff);
        }
    }
    else
    {
        for (int i=0; i<size; i++) {
            rs <<= 8;
            rs |= (buf[i] & 0x00000000000000ff);
        }
    }
    return rs;
}

+(NSDate *)fileTime2Date:(long long)newLong
{
    NSDate *rs=[NSDate dateWithTimeIntervalSince1970:(newLong/10000000l-11644473600l)];
//    NSTimeZone *zone = [NSTimeZone systemTimeZone];
//    NSInteger interval = [zone secondsFromGMTForDate: rs];
    return rs;
}

+(long long)date2FileTime:(NSDate *)dateTime
{
    return ([dateTime timeIntervalSince1970]+11644473600l)*10000000l;

}

+(NSString *)nowTime
{
    return [self nowTimeWithFormate:@"yyyy-MM-dd HH:mm:ss"];
}

+(NSString *)nowTimeWithFormate:(NSString *)formate
{
    NSDateFormatter* formater = [[ NSDateFormatter alloc] init];
    NSDate *curDate = [NSDate date];//获取当前日期
    [formater setDateFormat:formate];
    NSString *rs=[formater stringFromDate:curDate];
    return rs;
}

+(NSString *)timeWith:(NSString *)dateStr addend:(int)num
{
    return  [self timeWith:dateStr addend:num formate:@"yyyy-MM-dd HH:mm:ss"];
}

+(NSString *)timeWith:(NSString *)dateStr addend:(int)num formate:(NSString *)formate
{
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:formate];
    NSString *rs=[dateformatter stringFromDate:[[dateformatter dateFromString:dateStr] dateByAddingTimeInterval:num]];
    return  rs;
}

+(NSString *)base64EncodeWithString:(NSString *)str
{
    NSData *strData = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSString *encodeString=[strData base64EncodedStringWithOptions:0];
    return encodeString;
}

+(NSString *)base64DecodeWithString:(NSString *)str
{
    NSData *strData = [[NSData alloc] initWithBase64EncodedString:str options:0];
    NSString *decodedString = [[NSString alloc] initWithData:strData encoding:NSUTF8StringEncoding];
    return decodedString;
}

+(NSString *)urlEncodeWithString:(NSString *)str
{
    str=[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    str=[str stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    str=[str stringByReplacingOccurrencesOfString:@"=" withString:@"%3D"];
    return str;
}

+(NSString *)urlDecodeWithString:(NSString *)str
{
    return [str stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
}

+(void)deleteSerializeValue:(NSString *)key
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs delete:key];
    [prefs synchronize];
}

+(NSString *)readSerializeValue:(NSString *)key
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *myString = [prefs stringForKey:key];
//    NSDictionary
    return myString;
}

+(void)saveSerializeValue:(NSString *)key value:(NSString *)value
{
    @try {
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [prefs setObject:value forKey:key];
        [prefs synchronize];
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

+(NSString *)Dictionary:(NSDictionary *)dic key:(NSString *)key
{
    return [NSString stringWithFormat:@"%@",[dic valueForKey:key]?[dic valueForKey:key]:@""];
}

+(NSString *)JSONObjectToString:(NSObject *)obj
{
    return [Utils JSONObjectToString:obj options:NSJSONWritingPrettyPrinted];
}

+(NSString *)JSONObjectToString:(NSObject *)obj options:(NSJSONWritingOptions)opt
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj options:opt error:&error];
    NSString *json =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return json;
}

+(id)JSONOjbectFromString:(NSString *)str
{
    NSData *data=[str dataUsingEncoding:NSUTF8StringEncoding];
    return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
}


+(CGSize)labelResize:(UILabel *)aLabel
{
    aLabel.lineBreakMode = NSLineBreakByWordWrapping;
    aLabel.numberOfLines = 9999;
    
    CGSize aSize = [aLabel.text sizeWithFont:aLabel.font constrainedToSize:CGSizeMake(aLabel.frame.size.width, 9999.0f) lineBreakMode:NSLineBreakByWordWrapping];
    
    aLabel.frame = CGRectMake(aLabel.frame.origin.x, aLabel.frame.origin.y, aSize.width, aSize.height+20.0f);
    return aSize;
}

+(NSString *)toString:(NSObject *)obj
{
    return [Utils toString:obj default:nil];
}

+(NSString *)toString:(NSObject *)obj default:(NSString *)dValue
{
    if (obj) {
        return [NSString stringWithFormat:@"%@",obj];
    }
    else
    {
        return dValue;
    }
}

+ (UIImage *) imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize) newSize{
    newSize.height=image.size.height*(newSize.width/image.size.width);
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return  newImage;
    
}

+ (NSString *)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName{
    NSData* imageData;
    
    //判断图片是不是png格式的文件
    if (UIImagePNGRepresentation(tempImage)) {
        //返回为png图像。
        imageData = UIImagePNGRepresentation(tempImage);
    }else {
        //返回为JPEG图像。
        imageData = UIImageJPEGRepresentation(tempImage, 1.0);
    }
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    
    NSString* documentsDirectory = [paths objectAtIndex:0];
    
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:imageName];
    
    NSArray *nameAry=[fullPathToFile componentsSeparatedByString:@"/"];
    NSLog(@"===fullPathToFile===%@",fullPathToFile);
    NSLog(@"===FileName===%@",[nameAry objectAtIndex:[nameAry count]-1]);
    
    [imageData writeToFile:fullPathToFile atomically:NO];
    return fullPathToFile;
}

+(void)callPhone:(NSString *)phone
{
    if (phone != nil) {
        NSString *telUrl = [NSString stringWithFormat:@"tel://%@",phone];
        NSURL *url = [[NSURL alloc] initWithString:telUrl];
        [[UIApplication sharedApplication] openURL:url];
        
    }
}

+(void)sendSMS:(NSString *)phone
{
    
    if (phone != nil) {
        NSString *telUrl = [NSString stringWithFormat:@"sms://%@",phone];
        NSURL *url = [[NSURL alloc] initWithString:telUrl];
        [[UIApplication sharedApplication] openURL:url];
        
    }
}

+(CGColorRef) colorFromRed:(int)red Green:(int)green Blue:(int)blue Alpha:(int)alpha
{
    CGFloat r = (CGFloat) red/255.0;
    CGFloat g = (CGFloat) green/255.0;
    CGFloat b = (CGFloat) blue/255.0;
    CGFloat a = (CGFloat) alpha/255.0;
    CGFloat components[4] = {r,g,b,a};
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGColorRef color = (CGColorRef)CGColorCreate(colorSpace, components);
    CGColorSpaceRelease(colorSpace);
    
    return color;
}

+ (UIImage *)createImageWithColor:(UIColor *)color
{
    return [Utils createImageWithColor:color rect:CGRectMake(0.0f, 0.0f, 1.0f, 1.0f)];
}

+ (UIImage *)createImageWithColor:(UIColor *)color rect:(CGRect)rect
{
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}

+(CGSize)stringLength:(NSString *)string fontSize:(float)size{
    //设置字体,包括字体及其大小
    UIFont *font = [UIFont boldSystemFontOfSize:size];
    //label可设置的最大高度和宽度
    CGSize maxSize = CGSizeMake(320.f, 2000.0f);
    CGSize labelSize = [string sizeWithFont:font  constrainedToSize:maxSize lineBreakMode:NSLineBreakByWordWrapping];
    return labelSize;
}



@end
