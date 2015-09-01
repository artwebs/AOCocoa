//
//  DicListView.m
//  LuckyNumber
//
//  Created by artwebs on 14-6-26.
//  Copyright (c) 2014年 artwebs. All rights reserved.
//

#import "DicListView.h"
#import "Utils.h"
@implementation DicListView
@synthesize source,keyField,valueField,delegate;

-(id)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        rkey=@"";
        rvalue=@"";
        
        list=[[NSMutableArray alloc]init];
        
        CGSize size=[UIScreen mainScreen].bounds.size;
        contentView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
        contentView.backgroundColor=[UIColor colorWithRed:255 green:255 blue:255 alpha:1];
        [self addSubview:contentView];
        
        x=10.0f;
        y=10.0f;
        w=size.width-20;
        h= size.height-87;
        playerView=[[UIView alloc] initWithFrame:CGRectMake(x, y, w, h) ];
        playerView.layer.borderWidth = 1.0;
        playerView.backgroundColor=[UIColor whiteColor];
        [contentView addSubview:playerView];
        
        x+=10;
        y+=10;
        searchTFied=[[UITextField alloc] initWithFrame:CGRectMake(x, y, w-100.0f, 30.0f)];
        searchTFied.layer.borderWidth = 1.0;
        searchTFied.delegate=self;
        [contentView addSubview:searchTFied];
        
        
        searchBtn=[[UIButton alloc]initWithFrame:CGRectMake(x+10.0f+(w-100.0f), y, 60.0f, 30.0f)];
        searchBtn.layer.borderWidth = 1.0;
        [searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
        [searchBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
        [searchBtn addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:searchBtn];
        
        y+=40;
        
        itemTblView=[[UITableView alloc]initWithFrame:CGRectMake(x, y, w-x, h-y-50.0f)];
        itemTblView.layer.borderWidth = 1.0;
        itemTblView.delegate=self;
        itemTblView.dataSource=self;
        [contentView addSubview:itemTblView];
        
        y+=h-y-50.0f;
        y+=10;
        
        sureBtn=[[UIButton alloc] initWithFrame:CGRectMake(x+40.0f, y, 80.0f, 30.0f)];
        sureBtn.layer.borderWidth = 1.0;
        [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [sureBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
        [sureBtn addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:sureBtn];
        
        cancelBtn=[[UIButton alloc] initWithFrame:CGRectMake(x+160.0f, y, 80.0f, 30.0f)];
        cancelBtn.layer.borderWidth = 1.0;
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:cancelBtn];
    }
    return self;
}


-(void)loadSerialize:(NSString *)key
{
    source=[Utils JSONOjbectFromString:[Utils readSerializeValue:key]];
}

-(void)reLoad
{
    [list removeAllObjects];
    if ([@"" isEqual:searchTFied.text]) {
        [list addObjectsFromArray:source];
    }else
    {
        for (int i=0; i<[source count]; i++) {
            NSDictionary *dic=[source objectAtIndex:i];
            NSRange range = [[Utils Dictionary:dic key:valueField]  rangeOfString:searchTFied.text];
            if (range.location!=NSNotFound) {
                [list addObject:dic];
            }
        }
    }
    [itemTblView reloadData];
}

-(IBAction)btnOnClick:(id)sender
{
    [searchTFied resignFirstResponder];
    if ([searchBtn isEqual:sender]) {
        if (![@"" isEqual:searchTFied.text]) {
            [self reLoad];
        }
        
    }else if([sureBtn isEqual:sender])
    {
        if (self.delegate) {
            [self.delegate sendTokey:rkey value:rvalue];
            
        }
        [self removeFromSuperview];
    }else if([cancelBtn isEqual:sender])
    {
        [self removeFromSuperview];
    }
    return;
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [list count];
}


- (UITableViewCell *)tableView:(UITableView *)tblView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cell";
    UITableViewCell *cell = (UITableViewCell *)[tblView dequeueReusableCellWithIdentifier:CellIdentifier];
    NSMutableDictionary *dic;
    //    cell.backgroundColor=[UIColor clearColor];
    if (indexPath.row<[list count]) {
        dic=[list objectAtIndex:indexPath.row];
    }
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text=[Utils Dictionary:dic key:valueField];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}



#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tblView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic=[list objectAtIndex:indexPath.row];
    rkey=[dic valueForKey:keyField];
    rvalue=[dic valueForKey:valueField];
    [searchTFied resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)tField
{
    [tField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)tField
{
    [tField resignFirstResponder];
    return NO;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [searchTFied resignFirstResponder];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    
    return YES;
}
@end
