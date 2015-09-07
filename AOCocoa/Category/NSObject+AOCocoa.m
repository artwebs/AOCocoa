//
//  NSObject+AOCocoa.m
//  AOCocoa
//
//  Created by 刘洪彬 on 15/6/9.
//  Copyright (c) 2015年 刘洪彬. All rights reserved.
//

#import "NSObject+AOCocoa.h"

@implementation NSObject(AOCocoa)
-(void)log:(NSObject *)obj{
    NSLog(@"%@=>%@",[self tag],obj);
}

-(NSString *)tag{
    return [NSString stringWithFormat:@"%@",NSStringFromClass([self class])];
}
@end
