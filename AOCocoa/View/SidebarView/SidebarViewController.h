//
//  ViewController.h
//  SideBarNavDemo
//
//  Created by JianYe on 12-12-11.
//  Copyright (c) 2012年 JianYe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SideBarSelectedDelegate.h"
#import "SidebarMenuViewController.h"
@interface SidebarViewController : UIViewController<SideBarSelectDelegate,UINavigationControllerDelegate>



@property (strong,nonatomic)IBOutlet UIView *contentView;
@property (strong,nonatomic)IBOutlet UIView *navBackView;
@property (readonly,nonatomic)SidebarMenuViewController *leftSideBarViewController,*rightSideBarViewController;

+ (id)share;
-(void)setLeftSideBarViewController:(SidebarMenuViewController *)viewController;
-(void)setRightSideBarViewController:(SidebarMenuViewController *)viewController;

@end
