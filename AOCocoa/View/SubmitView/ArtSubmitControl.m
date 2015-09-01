//
//  ArtSubmitControl.m
//  LuckyNumber
//
//  Created by artwebs on 14-6-25.
//  Copyright (c) 2014年 artwebs. All rights reserved.
//

#import "ArtSubmitControl.h"
#import "ArtSubmitViewCell.h"
#import "ArtLog.h"
#import "Utils.h"
#import "DicListView.h"
#import "ArtSubmitViewCellButton.h"
static NSString *tag=@"ArtSubmitControl";

@implementation ArtSubmitControl
@synthesize cellstyle;
-(id)initWithTableView:(UITableView *)tbView layout:(NSArray *)loarr
{
    return [self initWithTableView:tbView layout:loarr height:40];
}

-(id)initWithTableView:(UITableView *)tbView layout:(NSArray *)loarr height:(int)h
{
    return [self initWithTableView:tbView layout:loarr height:h cellBgImage:nil];
}

-(id)initWithTableView:(UITableView *)tbView layout:(NSArray *)loarr height:(int)h cellBgImage:(NSString *)img
{
    if (self=[super init]) {
        tableview=tbView;
        tableview.dataSource=self;
        tableview.delegate=self;
        tableview.backgroundColor = [UIColor colorWithRed:00.0f/255.0f green:00.0f/255.0f blue:00.0f/255.0f alpha:0.0f];
        tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        layoutArray=loarr;
        cellArray=[[NSMutableArray alloc]init];
        showCellArray=[[NSMutableArray alloc]init];
        cellBgImage=img;
        lineHeight=h;
        cellstyle=TextOnly;
        
        [self initShowCellArray];
    }
    return self;
}

-(NSDictionary *)getResult
{
//    [tableview setContentOffset:CGPointMake(0, tableview.contentSize.height -tableview.bounds.size.height) animated:YES]; 
    NSMutableDictionary *rsdic=[[NSMutableDictionary alloc] init];
    int j=0;
    for (int i=0; i<[layoutArray count]; i++) {
        NSDictionary *dic=(NSDictionary*)[layoutArray objectAtIndex:i];
        if ([@"false" isEqual:[Utils Dictionary:dic key:@"display"]]) {
            [rsdic setObject:[Utils Dictionary:dic key:@"value"] forKey:[Utils Dictionary:dic key:@"name"]];
            continue;
        }
        
        @try {
            ArtSubmitViewCell *cell=[cellArray objectAtIndex:j++];
            [cell getResult:rsdic];
        }
        @catch (NSException *exception) {
            [tableview setContentOffset:CGPointMake(0.0, lineHeight*(j-1)) animated:YES];
            @throw exception;
        }
    }
    return rsdic;
}

-(void)initShowCellArray
{
    int num=0;
    for (int i=0; i<[layoutArray count]; i++) {
        NSDictionary *dic=(NSDictionary *)[layoutArray objectAtIndex:i];
        if (![@"false" isEqualToString:[Utils Dictionary:dic key:@"display"]]) {
            [showCellArray addObject:dic];
            
            
            NSString *CellIdentifier = [NSString stringWithFormat:@"cell%d",num++];
            ArtSubmitViewCell *cell ;
            if ([@"button" isEqual:[Utils Dictionary:dic key:@"type"]]) {
                //            [cell.textField addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchDown];
                cell = [[ArtSubmitViewCellButton alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier data:dic];
            }else{
                cell = [[ArtSubmitViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier data:dic];
            }
            
            cell.backgroundColor=[UIColor clearColor];
            cell.astyle=cellstyle;
            [cell displayWithHeight:lineHeight];
            if (cellBgImage) {
                UIEdgeInsets insets = UIEdgeInsetsMake(0, 20, 0, 20);
                cell.layer.contents=(id)[[UIImage imageNamed:cellBgImage] resizableImageWithCapInsets:insets].CGImage;
            }
            [cellArray addObject:cell];
        }
    }
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [showCellArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tblView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    ArtSubmitViewCell *cell = (ArtSubmitViewCell *)[cellArray objectAtIndex:(int)indexPath.row];
//    NSMutableDictionary *dic;
////    cell.backgroundColor=[UIColor clearColor];
//    
//    if (!cell) {
//        if (indexPath.row<[showCellArray count]) {
//            dic=[showCellArray objectAtIndex:indexPath.row];
//        }
//        if ([@"button" isEqual:[Utils Dictionary:dic key:@"type"]]) {
////            [cell.textField addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchDown];
//            cell = [[ArtSubmitViewCellButton alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier data:dic];
//            
//        }else{
//            cell = [[ArtSubmitViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier data:dic];
//        }
//        cell.astyle=cellstyle;
//        [cell displayWithHeight:lineHeight];
//        
//        
//        
//        if (cellBgImage) {
//            cell.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:cellBgImage]];
//        }
//        if ([cellArray count]<=indexPath.row) {
//            [cellArray addObject:cell];
//        }
//        
//    }
    return [cellArray objectAtIndex:(int)indexPath.row];
}

-(IBAction)onClick:(id)sender
{
    [ArtLog warnWithTag:tag object:@"onClick"];
    DicListView *dicView=[[DicListView alloc]init];
    [tableview.superview addSubview:dicView];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return lineHeight;
}



#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tblView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (self.delegate) {
//        [self.delegate tableView:tblView didSelectRowAtIndexPath:indexPath];
//    }
}



@end
