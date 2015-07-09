//
//  ArtLog.m
//  LuckyNumber
//
//  Created by artwebs on 14-6-17.
//  Copyright (c) 2014年 artwebs. All rights reserved.
//

#import "ArtLog.h"
#import "Utils.h"
ArtLogLevel level=INFO;
static NSString *t=@"";
@implementation ArtLog
+(void)infoWithTag:(NSString *)tag object:(NSObject *)meg
{
    if (level<=INFO&&([[ArtLog filterOjbects] containsObject:tag]||[[ArtLog filterOjbects] count]==0)) {
        NSLog(@"[%@]=> %@",tag,meg);
    }
}
+(void)warnWithTag:(NSString *)tag object:(NSObject *)meg
{
    if (level<=WARN&&([[ArtLog filterOjbects] containsObject:tag]||[[ArtLog filterOjbects] count]==0)) {
        NSLog(@"[%@]=> %@",tag,meg);
    }
}
+(void)errorWithTag:(NSString *)tag object:(NSObject *)meg
{
    if (level<=ERROR&&([[ArtLog filterOjbects] containsObject:tag]||[[ArtLog filterOjbects] count]==0)) {
        NSLog(@"[%@]=> %@",tag,meg);
    }
}

+(NSArray *)filterOjbects
{
    return @[
//             @"ReviewCellView",
//             @"MenuViewController",
//             @"SPSubmitViewController",
//             @"SPModifyViewController",
//             @"SubmitPickCellVIew",
//             @"SearchView",
//             @"SPickViewController",
//             @"ArtSubmitControl",
//             @"SDoReviewViewController",
//             @"LoginViewController",
//             @"SQueryReviewViewController"
             ];
}

@end
