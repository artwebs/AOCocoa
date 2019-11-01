//
//  Response.h
//  LuckyNumber
//
//  Created by artwebs on 14-6-16.
//  Copyright (c) 2014年 artwebs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Response : NSObject
{
    NSDictionary *resultObj;
}
@property (nonatomic,retain) NSString *source;

-(id)initWithSource:(NSString *)str;
-(NSDictionary *)getJSONWithError:(NSString *)err;
-(BOOL)successed;
-(NSString *)getMessage;
-(NSObject *)getResultObject;
@end
