//
//  NSDataBase64Tests.m
//  BusinessCard
//
//  Created by artwebs on 14-7-24.
//  Copyright (c) 2014年 artwebs. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSData+Base64.h"

@interface UtilsTests : XCTestCase

@end

@implementation UtilsTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

-(void)testBase64String
{
    NSString *str = @"a12*&1c中文";
    NSLog(@"原NSString: %@", str);
    
    NSString *rs=[NSData base64Encode:str];
    NSLog(@"编码: %@", rs);
    NSLog(@"解码：%@",[NSData base64Decode:rs]);
    
}


-(void)testBase64
{
    // insert code here...
	NSString *str = @"happy";
    NSLog(@"原NSString: %@", str);
    
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"原NSString转为data:%@", data);
    
    NSString *encodingStr = [data base64Encoding];
    NSLog(@"Base64编码:%@", encodingStr);
    
    NSData *newData = [NSData dataWithBase64EncodedString:encodingStr];
    NSLog(@"进行Base64解码后的新data:%@", newData);
    
    NSString *newStr = [[NSString alloc] initWithData:newData encoding:NSUTF8StringEncoding];
    NSLog(@"将新data转成原NSString类型:%@", newStr);
    
}



- (void)testExample
{
//    XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
}

@end
