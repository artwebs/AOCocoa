//
//  NSObject+AOCocoa.m
//  AOCocoa
//
//  Created by 刘洪彬 on 15/6/9.
//  Copyright (c) 2015年 刘洪彬. All rights reserved.
//

#import "NSObject+AOCocoa.h"
static BOOL isDebugger_NSObject_AOCocoa = false;
@implementation NSObject(AOCocoa)

-(void)setDebugger:(BOOL)flag{
    isDebugger_NSObject_AOCocoa =flag;
}

-(BOOL)isDebugger{
    return isDebugger_NSObject_AOCocoa;
}

-(void)log:(NSObject *)obj{
    if (isDebugger_NSObject_AOCocoa) {
        NSLog(@"%@=>%@",[self tag],obj);
    }
}

-(NSString *)tag{
    return [NSString stringWithFormat:@"%@",NSStringFromClass([self class])];
}
@end
