//
//  SimpleTable.m
//  BusinessCard
//
//  Created by artwebs on 14-8-11.
//  Copyright (c) 2014年 artwebs. All rights reserved.
//

#import "SimpleTable.h"

@implementation SimpleTable
-(id)initWithDB:(SqliteHelper *)db table:(NSString *)tName priKey:(NSString *)pKey
{
    if (self=[super init]) {
        
    }
    return self;
}
@end
