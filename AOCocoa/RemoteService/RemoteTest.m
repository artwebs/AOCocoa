//
//  RemoteTest.m
//  BusinessCard
//
//  Created by artwebs on 14-8-8.
//  Copyright (c) 2014年 artwebs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "RData.h"
#import "IServiceHttpSync.h"
#import "RemoteFactory.h"
#import "Utils.h"
#import "ArtLog.h"
#import "IServiceHttpSync.h"

@interface RemoteTest : XCTestCase

@end

@interface ExRData : RData

@end


@interface ExRemoteFactory : RemoteFactory

@end

@interface DataCallObject : NSObject<RDataCallback>

@end

@implementation RemoteTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}

-(void)testRemote{
//    DataCallObject *callObj=[[DataCallObject alloc]init];
//    ExRData *cmd=[[ExRData alloc] initWithFun:@"aws_test" params:[Utils JSONObjectToString:@{@"a":@"1",@"b":@"1"}]];
//    [cmd setCallObj:callObj];
//    ExRemoteFactory *remoteFactory=[[ExRemoteFactory alloc]init];
//    [remoteFactory sendCommand:cmd];
//    CFRunLoopRun();
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
//    [self measureBlock:^{
//        // Put the code you want to measure the time of here.
//    }];
}

@end



@implementation ExRData

-(id<IService> )getService
{
    return [[IServiceHttpSync alloc] initWithUrl:[NSString stringWithFormat:@"http://192.168.119.134:8081/DataAction/%@",self.getController]];
}

-(NSString *)getParams
{
    return [NSString stringWithFormat:@"cmd=%@",[super getParams]];
}

@end


@implementation ExRemoteFactory



@end

@implementation DataCallObject
-(void)sendMessage:(RData *)cmd
{
    [ArtLog warnWithTag:@"DataCallObject" object:[cmd.response getMessage]];
    CFRunLoopRef runLoopRef = CFRunLoopGetCurrent();
    CFRunLoopStop(runLoopRef);
}


@end


