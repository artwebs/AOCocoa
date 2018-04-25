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

-(void)log:(id)args,...{
    if (isDebugger_NSObject_AOCocoa) {
        NSString* rs=[self tag];
        if(args){
            va_list list;
            va_start(list, args);
            rs=[rs stringByAppendingString:[NSString stringWithFormat:@" %@",args]];
            id val = va_arg(list,id);
            while(val){
                rs=[rs stringByAppendingString:[NSString stringWithFormat:@" %@",val]];
                val=va_arg(list,id);
            }
            NSLog(@"%@",rs);
            va_end(list);
        }
        
    }
    
}

-(NSString *)tag{
    return NSStringFromClass([self class]);
}
@end
