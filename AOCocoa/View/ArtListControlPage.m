//
//  ArtListControlPage.m
//  BusinessCard
//
//  Created by artwebs on 14-6-12.
//  Copyright (c) 2014年 artwebs. All rights reserved.
//

#import "ArtListControlPage.h"

@implementation ArtListControlPage
@synthesize delegate,rowData;
-(id)initWithTableView:(UITableView *)tblView pageSize:(int)size
{
    return [self initWithTableView:tblView pageSize:size height:60];
}


-(id)initWithTableView:(UITableView *)tblView pageSize:(int)size height:(int)h
{
    if (self=[super init]) {
        tableView=tblView;
        tableView.dataSource=self;
        tableView.delegate=self;
        pageSize=size;
        lineHeight=h;
        rowData=[[NSMutableArray alloc] init];
    }
    return self;
}

-(void)loadData
{
    if (self.delegate) {
        page=1;
        [rowData removeAllObjects];
    }
    [self.delegate loadMoreDateWithPage:page pageSize:pageSize];
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [rowData count];
}


- (UITableViewCell *)tableView:(UITableView *)tblView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return [self.delegate tableView:tblView cellForRowAtIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return lineHeight;
}



#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tblView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate) {
        [self.delegate tableView:tblView didSelectRowAtIndexPath:indexPath];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y + (scrollView.frame.size.height) > scrollView.contentSize.height) {
        [self.delegate loadMoreDateWithPage:page pageSize:pageSize];
    }
}

-(void)notifyAddData:(NSArray *)tmpData
{
    for (int i=0; i<tmpData.count; i++) {
        [rowData addObject:[tmpData objectAtIndex:i]];
    }
    page++;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
           [tableView reloadData];
        });
    });
    
}

-(void)notifyRemoveData:(NSIndexPath *)indexPath
{
    [rowData removeObjectAtIndex:indexPath.row];
    [tableView reloadData];
}


@end
