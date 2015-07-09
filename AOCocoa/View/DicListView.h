//
//  DicListView.h
//  LuckyNumber
//
//  Created by artwebs on 14-6-26.
//  Copyright (c) 2014年 artwebs. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol DicListViewDelegate;
@interface DicListView : UIView<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *list;
    UIView *contentView;
    UIView *playerView;
    UITextField *searchTFied;
    UIButton *searchBtn;
    UITableView *itemTblView;
    UIButton *sureBtn;
    UIButton *cancelBtn;
    float x;
    float y;
    float w;
    float h;
    
    NSString *rkey;
    NSString *rvalue;
}
@property (nonatomic,retain)id<DicListViewDelegate>delegate;
@property (nonatomic,retain)NSArray *source;
@property (nonatomic,retain)NSString *keyField, *valueField;
-(void)loadSerialize:(NSString *)key;
-(void)reLoad;
-(IBAction)btnOnClick:(id)sender;
@end

@protocol DicListViewDelegate <NSObject>

-(void)sendTokey:(NSString *)key value:(NSString *)value;

@end