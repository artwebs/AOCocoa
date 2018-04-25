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
#import "NSObject+AOCocoa.h"
@interface SqliteHelper(){
     sqlite3 *db;
}
-(int)getCurVersion;
@end

@implementation SqliteHelper
@synthesize delegate;
-(id)init:(NSString *)name version:(int)version
{
    if (self=[super init]) {
        dbVersion=version;
        dbName=name;
        if(self.delegate)
            [self.delegate onCreate];
        curVersion=[self getCurVersion];
        if (curVersion<dbVersion) {
            if(self.delegate)
                [self.delegate onUpdate:curVersion newVersion:dbVersion];
            [self exec:[NSString stringWithFormat:@"PRAGMA user_version=%d",dbVersion]];
            curVersion=dbVersion;
        }
    }
    return self;
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

-(void)close
{
    sqlite3_close(db);
}

-(int)exec:(NSString *)sql
{
    [self conn];
    int rs=0;
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &stmt, nil) == SQLITE_OK&&sqlite3_step(stmt)==SQLITE_DONE) {
        rs=sqlite3_changes(db);
    }else{
        NSLog(@"数据库操作数据失败!");
    }
    [self close];
    [self log:[NSString stringWithFormat:@"%@=>%d",sql,rs],nil];
    return rs;
}

-(NSArray  *)query:(NSString * )sql{
    [self conn];
    [self log:sql,nil];
    sqlite3_stmt *stmt;
    NSMutableArray *rsArr=[[NSMutableArray alloc]init];
    [self log:sql,nil];
    if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &stmt, nil) == SQLITE_OK) {
        int num_cols = sqlite3_column_count(stmt);
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
            for (int i=0; i<num_cols; i++) {
                const char* col_name = sqlite3_column_name(stmt, i);
                if (col_name) {
                    NSString *colName = [NSString stringWithUTF8String:col_name];
                    id value = nil;
                    // fetch according to type
                    switch (sqlite3_column_type(stmt, i)) {
                        case SQLITE_INTEGER: {
                            int i_value = sqlite3_column_int(stmt, i);
                            value = [NSNumber numberWithInt:i_value];
                            break;
                        }
                        case SQLITE_FLOAT: {
                            double d_value = sqlite3_column_double(stmt, i);
                            value = [NSNumber numberWithDouble:d_value];
                            break;
                        }
                        case SQLITE_TEXT: {
                            char *c_value = (char *)sqlite3_column_text(stmt, i);
                            value = [[NSString alloc] initWithUTF8String:c_value];
                            break;
                        }
                        case SQLITE_BLOB: {
                            value = (__bridge id)(sqlite3_column_blob(stmt, i));
                            break;
                        }
                    }
                    if (value) {
                        [dic setObject:value forKey:colName];
                    }else{
                        [dic setObject:@"NULL" forKey:colName];
                    }
                }
            }
            [rsArr addObject:dic];
        }
    }
    [self close];
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
    [self close];
    return rsInt;
}

@end
