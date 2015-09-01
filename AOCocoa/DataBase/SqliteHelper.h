//
//  SqliteHelper.h
//  BusinessCard
//
//  Created by artwebs on 14-6-10.
//  Copyright (c) 2014年 artwebs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
@interface SqliteHelper : NSObject
{
    sqlite3 *db;
    int dbVersion;
    int curVersion;
    NSString *dbName;
}

-(id)initWithName:(NSString *)name;
-(void)initDataWithVersion:(int)version;
-(void)onCreateWithSqlite:(sqlite3 *)newdb;
-(void)onUpdateWithSqlite:(sqlite3 *)newdb oldVersion:(int)oldVer newVersion:(int)newVer;
-(BOOL)conn;
-(void)closeConn;
-(BOOL)execWithSql:(NSString *)sql;
-(NSMutableArray *)queryWithTbName:(NSString *)tbname fieldArray:(NSArray *)fields where:(NSString *)where;
@end
