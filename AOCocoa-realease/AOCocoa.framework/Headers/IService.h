//
//  IService.h
//  LuckyNumber
//
//  Created by artwebs on 14-6-10.
//  Copyright (c) 2014年 artwebs. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IService <NSObject>
-(NSString *)sendMessage:(NSString *)params;
@end
