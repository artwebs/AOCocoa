//
//  ArtAlert.m
//  LuckyNumber
//
//  Created by artwebs on 14-6-17.
//  Copyright (c) 2014年 artwebs. All rights reserved.
//

#import "ArtAlert.h"
#import <UIKit/UIKit.h>
@implementation ArtAlert
+ (void)show:(NSObject *)msg
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"%@",msg] delegate:self cancelButtonTitle:NSLocalizedStringFromTable(@"sure", @"ArtLocalizedString", NULL) otherButtonTitles:nil];
            [alertView show];
        });
    });
}
@end
