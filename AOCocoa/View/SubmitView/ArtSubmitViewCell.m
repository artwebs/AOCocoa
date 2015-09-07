//
//  ArtSubmitViewCell.m
//  LuckyNumber
//
//  Created by artwebs on 14-6-25.
//  Copyright (c) 2014年 artwebs. All rights reserved.
//

#import "ArtSubmitViewCell.h"
#import "Utils.h"

@implementation ArtSubmitViewCell
@synthesize astyle,value,textLabel,textField,unitLabel;

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier data:(NSDictionary *)data
{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.cellData=data;
        self.astyle=General;
    }
    return self;
}

-(void)displayWithHeight:(int)heght
{
    float h=30.0f;
    float y=(heght-h)/2.0f;
    switch (astyle) {
        case TextOnly:
        {
            self.textField=[[UITextField alloc] initWithFrame:CGRectMake(10.0f, y, self.frame.size.width-20.0f,h)];
            [self.contentView addSubview:self.textField];
            
            self.textField.placeholder=[Utils Dictionary:self.cellData key:@"cname"];
            self.textField.text=[Utils Dictionary:self.cellData key:@"value"];
            break;
        }
        default:
        {
            self.titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(10.0f, y, 70.0f,h)];
            [self.contentView addSubview:self.titleLabel];
            
            self.textField=[[UITextField alloc] initWithFrame:CGRectMake(90.0f, y, self.frame.size.width-160.0f,h)];
            [self.contentView addSubview:self.textField];
            
            self.unitLabel=[[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width-70.0f, y, 60.0f,h)];
            [self.contentView addSubview:self.unitLabel];
            
            self.titleLabel.text=[Utils Dictionary:self.cellData key:@"cname"];
            self.textField.placeholder=[Utils Dictionary:self.cellData key:@"dicvalue"];
            self.value=[Utils Dictionary:self.cellData key:@"value"];
            self.unitLabel.text=@"";
            
            
            NSString *unitStr=[Utils Dictionary:self.cellData key:@"unit"];
            if (![@"" isEqual:unitStr]) {
                self.unitLabel.text=unitStr;
            }

            break;
        }
    }
    if ([@"true" isEqual:[Utils Dictionary:self.cellData key:@"readonly"]]) {
        self.textField.enabled=NO;
    }
   

}



-(void)getResult:(NSMutableDictionary *)rsDic
{
    NSString *tmpValue=self.textField.text;
    if (![@"textbox" isEqual:[Utils Dictionary:self.cellData key:@"type"]]) {
        tmpValue=self.value;
    }else if ([@"" isEqual:tmpValue]&&astyle==General) {
        tmpValue=self.textField.placeholder;
    }
    [self verfiyValue:tmpValue];
    [rsDic setObject:tmpValue forKey:[Utils Dictionary:self.cellData key:@"name"]];
}

-(void)verfiyValue:(NSString *)va
{
    NSString *matcheRegex=[self.cellData objectForKey:@"mache"];
    if (matcheRegex) {
        NSPredicate *matche = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", matcheRegex];
        if (![matche evaluateWithObject:va]) {
            NSException *e=[NSException exceptionWithName:[NSString stringWithFormat:@"%@ %@",[Utils Dictionary:self.cellData key:@"cname"],NSLocalizedStringFromTable(@"notice1", @"ArtLocalizedString", NULL)] reason:@"" userInfo:nil];
            @throw e;
        }
    }
    NSString *minStr=[self.cellData objectForKey:@"minvalue"];
    if (minStr) {
        if ([va floatValue]<[minStr floatValue]) {
            NSException *e=[NSException exceptionWithName:[NSString stringWithFormat:@"%@ 不能小于%d",[Utils Dictionary:self.cellData key:@"cname"],[minStr intValue]] reason:@"" userInfo:nil];
            @throw e;
        }
    }
}

-(void)setTextField:(UITextField *)tField
{
    textField=tField;
    textField.delegate=self;
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
    [textField resignFirstResponder];
}
@end
