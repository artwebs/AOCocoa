//
//  ArtListControlPage.h
//  BusinessCard
//
//  Created by artwebs on 14-6-12.
//  Copyright (c) 2014年 artwebs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@protocol  ArtListControlPageDelegate;
@interface ArtListControlPage : NSObject<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *tableView;
    int page;
    int pageSize;
    int lineHeight;
}
@property (nonatomic,retain) id<ArtListControlPageDelegate> delegate;
@property (nonatomic,readonly) NSMutableArray *rowData;
-(id)initWithTableView:(UITableView *)tblView pageSize:(int)size;
-(id)initWithTableView:(UITableView *)tblView pageSize:(int)size height:(int)h;
-(void)loadData;
-(void)notifyAddData:(NSArray *)tmpData;
-(void)notifyRemoveData:(NSIndexPath *)indexPath;
@end


@protocol  ArtListControlPageDelegate<NSObject>
-(void)loadMoreDateWithPage:(int)page pageSize:(int)size;
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
@end