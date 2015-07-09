//
//  SimpleTable.h
//  BusinessCard
//
//  Created by artwebs on 14-8-11.
//  Copyright (c) 2014年 artwebs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SqliteHelper.h"
@interface SimpleTable : NSObject

-(id)initWithDB:(SqliteHelper *)db table:(NSString *)tName priKey:(NSString *)pKey;

@end
