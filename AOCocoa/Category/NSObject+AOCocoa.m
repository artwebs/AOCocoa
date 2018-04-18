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

-(void)log:(NSObject *)obj,...{
    if (isDebugger_NSObject_AOCocoa) {
        va_list arguments;
        id eachObject;
        if (obj) {
            NSString *rs =[self tag];
            va_start(arguments, obj);
            while ((eachObject = va_arg(arguments, id))) {
                if(eachObject)
                    rs=[rs stringByAppendingString:[NSString stringWithFormat:@" %@",eachObject]];
            }
            va_end(arguments);
            NSLog(@"%@",rs);
        }
        
    }
    
}

-(NSString *)tag{
    return NSStringFromClass([self class]);
}
@end
