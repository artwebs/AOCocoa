//
//  SqliteHelper.h
//  BusinessCard
//
//  Created by artwebs on 14-6-10.
//  Copyright (c) 2014年 artwebs. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface SqliteHelper : NSObject
{
   
    int dbVersion;
    int curVersion;
    NSString *dbName;
}

-(id)initWithName:(NSString *)name;
-(void)initDataWithVersion:(int)version;
-(void)onCreateWithSqlite;
-(void)onUpdateWithSqlite:(int)oldVer newVersion:(int)newVer;
-(BOOL)conn;
-(void)closeConn;
-(BOOL)execWithSql:(NSString *)sql;
-(NSMutableArray *)queryWithTbName:(NSString *)tbname fieldArray:(NSArray *)fields where:(NSString *)where;
@end