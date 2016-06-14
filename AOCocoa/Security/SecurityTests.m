//
//  SecurityTests.m
//  BusinessCard
//
//  Created by artwebs on 14-7-24.
//  Copyright (c) 2014年 artwebs. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SecurityDES.h"
#import "Utils.h"
@interface SecurityTests : XCTestCase

@end

@implementation SecurityTests

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

//-(void)testSecurityDES_ECB
//{
//    SecurityDES *obj=[[SecurityDES alloc] init];
//    NSString *key=@"www.zcline.net";
//    NSString *text=@"1103010900000013";
//    NSString *rs=[obj encodeWithString:text key:key];
//    NSLog(@"%s加密：%@",__PRETTY_FUNCTION__,rs);
//    NSLog(@"%s加密：ysedRi2FrlST+cQsk2DD4DphLQcvzpT6",__PRETTY_FUNCTION__);
//    NSLog(@"%s加密：%@",__PRETTY_FUNCTION__,text);
//    NSLog(@"%s加密：%@",__PRETTY_FUNCTION__,[obj decodeWithString:rs key:key]);
//}

-(void)testSecurityDES_CBC
{
    SecurityDES *obj=[[SecurityDES alloc] initWithMode:CBC];
//    NSString *key=@"www.zcline.net";
//    NSString *text=@"1103010900000013";
//    NSString *iv=@"artwebs";
//    NSString *rs=[obj encodeWithString:text key:key iv:iv];
    
//    NSLog(@"%s参考加密：bXgKYTR47dosKznX/32ARzoeuuBsdfIn",__PRETTY_FUNCTION__);
//    NSLog(@"%s加密：%@",__PRETTY_FUNCTION__,rs);
//    NSLog(@"%s参考解密：%@",__PRETTY_FUNCTION__,text);
//    NSLog(@"%s解密：%@",__PRETTY_FUNCTION__,[obj decodeWithString:rs key:key iv:iv]);
    
//    NSDictionary *dic=@{@"email":@"",@"phone":@"",@"mobile":@"18387133512",@"company":@"云南卓诚科技有限公司",@"name":@"刘洪彬",@"address":@"云南昆明"};
    NSDictionary *dic=@{@"a":@"刘洪彬",@"b":@"云南科技"};
    NSString *key=@"Ge7F5zKUbj31pgMndAL8suNS";
    NSString *text=[Utils JSONObjectToString:dic];
    NSString *iv=@"Zalnh2c0";
    NSString *rs=[obj encodeWithString:text key:key iv:iv];
    NSLog(@"%s加密：%@",__PRETTY_FUNCTION__,rs);
//    NSLog(@"%s加密：Ge7F5zKUbj31pgMndAL8suNS",__PRETTY_FUNCTION__);
//    NSLog(@"%s加密：%@",__PRETTY_FUNCTION__,text);
    NSLog(@"%s加密：%@",__PRETTY_FUNCTION__,[obj decodeWithString:rs key:key iv:iv]);
}

-(void)testSecurityAES
{
    Secu *obj= [[SecurityAES alloc] init];
    NSString *key = @"Y8gyxetKJ68N3d35Lass72GP";
    NSString *text = "a12*&1c中文";
    NSString *rs = [obj encodeWithString:text key:key];
    NSLog(@"%s加密：%@",__PRETTY_FUNCTION__,rs);
    NSLog(@"%s加密：%@",__PRETTY_FUNCTION__,[obj decodeWithString:rs key:key]);
    
    
}


- (void)testExample
{
//    XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
}

@end
