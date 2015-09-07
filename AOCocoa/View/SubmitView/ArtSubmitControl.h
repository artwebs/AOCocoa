//
//  ArtSubmitControl.h
//  LuckyNumber
//
//  Created by artwebs on 14-6-25.
//  Copyright (c) 2014年 artwebs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArtSubmitViewCell.h"
@protocol ArtSubmitControlLinstener;
@interface ArtSubmitControl : NSObject<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *tableview;
    NSArray *layoutArray;
    NSMutableArray *cellArray;
    NSMutableArray *showCellArray;
    NSString *cellBgImage;
    int lineHeight;
}
@property (nonatomic,retain) id<ArtSubmitControlLinstener> delegate;
@property (nonatomic,assign) ArtSubmitViewCellStyle cellstyle;
-(id)initWithTableView:(UITableView *)tbView layout:(NSArray *)loarr ;
-(id)initWithTableView:(UITableView *)tbView layout:(NSArray *)loarr height:(int)h;
-(id)initWithTableView:(UITableView *)tbView layout:(NSArray *)loarr height:(int)h cellBgImage:(NSString *)img;
-(NSDictionary *)getResult;

@end

@protocol ArtSubmitControlLinstener <NSObject>

@end