//
//  ArtSubmitViewCellButton.h
//  LuckyNumber
//
//  Created by artwebs on 14-6-26.
//  Copyright (c) 2014年 artwebs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArtSubmitViewCell.h"
#import "DicListView.h"
@interface ArtSubmitViewCellButton : ArtSubmitViewCell<DicListViewDelegate>
-(IBAction)onClick:(id)sender;
@end
