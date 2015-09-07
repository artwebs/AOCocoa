//
//  SqliteHelper.m
//  BusinessCard
//
//  Created by artwebs on 14-6-10.
//  Copyright (c) 2014年 artwebs. All rights reserved.
//

#import "SqliteHelper.h"
#import <sqlite3.h>
#import "ArtLog.h"
@interface SqliteHelper()
-(int)getCurVersion;
@end


@implementation SqliteHelper
-(id)initWithName:(NSString *)name
{
    if (self=[super init]) {
        dbVersion=0;
        dbName=name;
    }
    return self;
}

-(void)initDataWithVersion:(int)version
{
    dbVersion=version;
    [self onCreateWithSqlite:db];
    curVersion=[self getCurVersion];
    if (curVersion<dbVersion) {
        [self onUpdateWithSqlite:db oldVersion:curVersion newVersion:dbVersion];
        [self execWithSql:[NSString stringWithFormat:@"PRAGMA user_version=%d",dbVersion]];
        curVersion=dbVersion;
    }
}

-(void)onCreateWithSqlite:(sqlite3 *)newdb
{
    
}

-(void)onUpdateWithSqlite:(sqlite3 *)newdb oldVersion:(int)oldVer newVersion:(int)newVer
{

}


-(BOOL)conn
{
    BOOL rs=YES;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documents = [paths objectAtIndex:0];
    NSString *database_path = [documents stringByAppendingPathComponent:dbName];
    
    if (sqlite3_open([database_path UTF8String], &db) != SQLITE_OK) {
        sqlite3_close(db);
        rs=NO;
        NSLog(@"数据库打开失败");
    }
    return rs;
}

-(void)closeConn
{
    sqlite3_close(db);
}

-(BOOL)execWithSql:(NSString *)sql
{
    [self conn];
    char *err;
    BOOL rs=YES;
    if (sqlite3_exec(db, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK) {
        sqlite3_close(db);
        rs=NO;
        NSLog(@"数据库操作数据失败!");
    }
    [self closeConn];
    [ArtLog warnWithTag:@"SqliteHelper" object:[NSString stringWithFormat:@"%@=>%d",sql,rs]];
    return rs;
}

-(NSMutableArray *)queryWithTbName:(NSString *)tbname fieldArray:(NSArray *)fields where:(NSString *)where
{
    [self conn];
    sqlite3_stmt *stmt;
    NSMutableArray *rsArr=[[NSMutableArray alloc]init];
    NSString *sql=@"select ";
    for (int i=0; i<[fields count]; i++) {
        if ([fields objectAtIndex:i]==nil) {
            continue;
        }
        if (i!=0) {
            sql=[sql stringByAppendingString:@","];
        }
        sql=[sql stringByAppendingString:[fields objectAtIndex:i]];
    }
    sql=[sql stringByAppendingString:@" from "];
    sql=[sql stringByAppendingString:tbname];
    if (where) {
        sql=[sql stringByAppendingString:@" where "];
        sql=[sql stringByAppendingString:where];
    }
    [ArtLog warnWithTag:@"SqliteHelper" object:sql];
    if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &stmt, nil) == SQLITE_OK) {
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
            for (int i=0; i<[fields count]; i++) {
                char *name = (char*)sqlite3_column_text(stmt, i);
                NSString *nameStr=@"";
                if (name!=NULL) {
                    nameStr=[NSString stringWithUTF8String:name];
                }
                [dic setObject:nameStr forKey:[fields objectAtIndex:i]];
            }
            [rsArr addObject:dic];
        }
    }
    [self closeConn];
    return rsArr;
}



-(int)getCurVersion
{
    int rsInt=0;
    [self conn];
    sqlite3_stmt *stmt;
    NSString *sql=@"PRAGMA user_version";
    if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &stmt, nil) == SQLITE_OK) {
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            rsInt=sqlite3_column_int(stmt, 0);
        }
    }
    [self closeConn];
    return rsInt;
}

@end
