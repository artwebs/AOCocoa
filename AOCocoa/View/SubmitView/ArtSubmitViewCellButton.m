//
//  ArtSubmitViewCellButton.m
//  LuckyNumber
//
//  Created by artwebs on 14-6-26.
//  Copyright (c) 2014年 artwebs. All rights reserved.
//

#import "ArtSubmitViewCellButton.h"
#import "Utils.h"
#import "ArtLog.h"
#import "DicListView.h"
static NSString *tag=@"ArtSubmitViewCellButton";
@implementation ArtSubmitViewCellButton

-(void)displayWithHeight:(int)heght
{
    [super displayWithHeight:heght];
    [self.textField addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchDown];
    
}

-(void)getResult:(NSMutableDictionary *)rsDic
{
    [self verfiyValue:self.value];
    [rsDic setObject:self.value forKey:[Utils Dictionary:self.cellData key:@"name"]];
}

-(IBAction)onClick:(id)sender
{
    [ArtLog warnWithTag:tag object:@"onClick"];
    DicListView *dicView=[[DicListView alloc]init];
    [dicView loadSerialize:[Utils Dictionary:self.cellData key:@"serialize"]];
    dicView.keyField=@"id";
    dicView.valueField=@"name";
    dicView.delegate=self;
    [dicView reLoad];
    [self.superview.superview.superview addSubview:dicView];
}

-(void)sendTokey:(NSString *)key value:(NSString *)value
{
    self.value=key;
    [self.textField setText:value];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    return NO;
    
}

@end
