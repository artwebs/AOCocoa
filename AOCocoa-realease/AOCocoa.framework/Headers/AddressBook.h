//
//  AddressBook.h
//  BusinessCard
//
//  Created by artwebs on 14-7-4.
//  Copyright (c) 2014年 artwebs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>
@interface AddressBook : NSObject
{
    
}

+(void)conn;
+(NSArray *)queryAllPeople;
+(BOOL)savePeople:(ABRecordRef)person;
+(NSString *)toString:(ABRecordRef)person propertyID:(ABPropertyID)pid;
+(NSString *)toString:(ABMultiValueRef)values index:(CFIndex) index;
+(NSString *)toStringLable:(ABMultiValueRef)values index:(CFIndex) index;
@end
