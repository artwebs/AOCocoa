//
//  ArtLog.m
//  LuckyNumber
//
//  Created by artwebs on 14-6-17.
//  Copyright (c) 2014年 artwebs. All rights reserved.
//

#import "ArtLog.h"
#import "Utils.h"
ArtLogLevel levelArtLogLevel=INFO;
static NSMutableArray *dataArtLog;
@implementation ArtLog
+(void)infoWithTag:(NSString *)tag object:(NSObject *)meg
{
    if (levelArtLogLevel<=INFO&&([[ArtLog filterOjbects] containsObject:tag]||[[ArtLog filterOjbects] count]==0)) {
        NSLog(@"[%@]=> %@",tag,meg);
    }
}
+(void)warnWithTag:(NSString *)tag object:(NSObject *)meg
{
    if (levelArtLogLevel<=WARN&&([[ArtLog filterOjbects] containsObject:tag]||[[ArtLog filterOjbects] count]==0)) {
        NSLog(@"[%@]=> %@",tag,meg);
    }
}
+(void)errorWithTag:(NSString *)tag object:(NSObject *)meg
{
    if (levelArtLogLevel<=ERROR&&([[ArtLog filterOjbects] containsObject:tag]||[[ArtLog filterOjbects] count]==0)) {
        NSLog(@"[%@]=> %@",tag,meg);
    }
}

+(void)setLevel:(ArtLogLevel)l{
    levelArtLogLevel = l;
}

+(void)addObject:(NSString *)obj{
    if (!dataArtLog) {
        dataArtLog = [[NSMutableArray alloc]init];
    }
    [dataArtLog addObject:obj];
}

+(void)setObjects:(NSArray *)arr{
    if (!dataArtLog) {
        dataArtLog = [[NSMutableArray alloc]init];
    }
    [dataArtLog removeAllObjects];
    [dataArtLog addObjectsFromArray:arr];
}

+(NSArray *)filterOjbects
{
    if (dataArtLog) {
        return dataArtLog;
    }
    return @[];
}

@end
