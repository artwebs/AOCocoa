//
//  ArtNumberToCapital.m
//  LuckyNumber
//
//  Created by artwebs on 14-6-23.
//  Copyright (c) 2014年 artwebs. All rights reserved.
//

#import "ArtNumberToCapital.h"
@implementation ArtNumberToCapital
+(NSString *)changeDigit:(NSObject *)obj
{
    return [[ArtNumberToCapital getDigit0] objectAtIndex:[[NSString stringWithFormat:@"%@",obj] intValue]];
}

+(NSArray *)getDigit0
{
    return @[@"零",@"一",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九"];
}
@end
