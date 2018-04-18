//
//  SqliteHelper.h
//  BusinessCard
//
//  Created by artwebs on 14-6-10.
//  Copyright (c) 2014年 artwebs. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol SqliteHelperDelegate <NSObject>
-(void)onCreate;
-(void)onUpdate:(int)oldVer newVersion:(int)newVer;
@end
@interface DBNULL: NSObject{}
@end
@interface SqliteHelper : NSObject
{
   
    int dbVersion;
    int curVersion;
    NSString *dbName;
}
@property (nonatomic,retain) id<SqliteHelperDelegate> delegate;
-(id)init:(NSString *)name version:(int)version;
-(BOOL)conn;
-(void)close;
-(int)exec:(NSString *)sql;
-(NSArray *)query:(NSString *)sql;
@end
