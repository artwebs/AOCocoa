//
//  SecurityAES.h
//  AOCocoa
//
//  Created by 刘洪彬 on 16/6/13.
//  Copyright © 2016年 刘洪彬. All rights reserved.
//

#import <AOCocoa/AOCocoa.h>

@interface SecurityAES : Security{
    MODEL model; 
}
-(id)initWithModel:(MODEL)mod;
-(NSString *)encodeWithString:(NSString *)source key:(NSString *)key;
-(NSString *)encodeWithString:(NSString *)source key:(NSString *)key iv:(NSString *)iv;
-(NSString *)decodeWithString:(NSString *)source key:(NSString *)key;
-(NSString *)decodeWithString:(NSString *)source key:(NSString *)key iv:(NSString *)iv;
@end
