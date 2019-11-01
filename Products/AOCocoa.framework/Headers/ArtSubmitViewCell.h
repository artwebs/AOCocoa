//
//  ArtSubmitViewCell.h
//  LuckyNumber
//
//  Created by artwebs on 14-6-25.
//  Copyright (c) 2014年 artwebs. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    General,
    TextOnly
}
ArtSubmitViewCellStyle;
@interface ArtSubmitViewCell : UITableViewCell<UITextFieldDelegate>
{
}
@property (nonatomic,assign) ArtSubmitViewCellStyle astyle;
@property (nonatomic,retain) NSDictionary *cellData;
@property (nonatomic,retain) NSString *value;
@property (nonatomic,retain) IBOutlet UILabel *titleLabel;
@property (nonatomic,retain) IBOutlet UITextField *textField;
@property (nonatomic,retain) IBOutlet UILabel *unitLabel;

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier data:(NSDictionary *)data;
-(void)displayWithHeight:(int)heght;
-(void)getResult:(NSMutableDictionary *)rsDic;
-(void)verfiyValue:(NSString *)va;
@end
