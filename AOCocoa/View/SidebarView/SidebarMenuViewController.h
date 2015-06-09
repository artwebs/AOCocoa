//
//  SidebarMenuViewController.h
//  BusinessCard
//
//  Created by artwebs on 14-5-27.
//  Copyright (c) 2014年 artwebs. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SideBarSelectDelegate ;

@interface SidebarMenuViewController : UIViewController
@property (assign,nonatomic)id<SideBarSelectDelegate>delegate;
@end
