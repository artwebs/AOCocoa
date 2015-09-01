//
//  ArtEditView.m
//  BusinessCard
//
//  Created by artwebs on 14-7-10.
//  Copyright (c) 2014年 artwebs. All rights reserved.
//

#import "ArtEditView.h"

@implementation ArtEditView
-(id)initWithCoder:(NSCoder *)aDecoder {
    self=[super initWithCoder:aDecoder];
    return [self initWithFrame:[self frame]];
}


-(id)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        self.delegate=self;
    }
    return self;
}



- (BOOL)textFieldShouldReturn:(UITextField *)tField
{
    if (self==tField) {
        [self resignFirstResponder];
    }
    return YES;
}



- (BOOL)textFieldShouldClear:(UITextField *)tField
{
    if (self==tField) {
        [self resignFirstResponder];
    }
    return NO;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self resignFirstResponder];
}
@end
