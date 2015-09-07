//
//  AddressBook.m
//  BusinessCard
//
//  Created by artwebs on 14-7-4.
//  Copyright (c) 2014年 artwebs. All rights reserved.
//

#import "AddressBook.h"
#import "ArtLog.h"
static NSString *tag=@"AddressBook";
static ABAddressBookRef ab;
@implementation AddressBook
+(void)conn
{
    if (ab==nil) {
        ab = ABAddressBookCreate();
        __block BOOL accessGranted = NO;
        if (ABAddressBookRequestAccessWithCompletion != NULL) {
            
            // we're on iOS 6
            NSLog(@"on iOS 6 or later, trying to grant access permission");
            
            dispatch_semaphore_t sema = dispatch_semaphore_create(0);
            ABAddressBookRequestAccessWithCompletion(ab, ^(bool granted, CFErrorRef error) {
                accessGranted = granted;
                dispatch_semaphore_signal(sema);
            });
            dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        }
        else { // we're on iOS 5 or older
            
            NSLog(@"on iOS 5 or older, it is OK");
            accessGranted = YES;
        }
    }
}

+(NSArray *)queryAllPeople
{
    [AddressBook conn];
    NSMutableArray *rsArr=[[NSMutableArray alloc]init];
    CFArrayRef results = ABAddressBookCopyArrayOfAllPeople(ab);
    for(int i = 0; i < CFArrayGetCount(results); i++)
    {
        ABRecordRef person = CFArrayGetValueAtIndex(results, i);
        NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
        [dic setObject:[AddressBook toString:person propertyID:kABPersonFirstNameProperty] forKey:@"FirstName"];
        [dic setObject:[AddressBook toString:person propertyID:kABPersonMiddleNameProperty] forKey:@"MiddleName"];
        [dic setObject:[AddressBook toString:person propertyID:kABPersonLastNameProperty] forKey:@"LastName"];
        
        
        ABMultiValueRef phone = ABRecordCopyValue(person, kABPersonPhoneProperty);
        NSMutableArray *phoneArr=[[NSMutableArray alloc]init];
        for (int k = 0; k<ABMultiValueGetCount(phone); k++)
        {
            [phoneArr addObject:@{@"label":[AddressBook toStringLable:phone index:k],@"number": [AddressBook toString:phone index:k]}];
        }
        [dic setObject:phoneArr forKey:@"phone"];
        
        [rsArr addObject:dic];
    }
    
    [ArtLog warnWithTag:tag object:rsArr];

    return rsArr;
}

+(BOOL)savePeople:(ABRecordRef)person
{
    [AddressBook conn];
    CFErrorRef error = NULL;
    ABAddressBookAddRecord(ab, person, &error);
    ABAddressBookSave(ab, &error);
    CFRelease(ab);
    if (error) {
        return NO;
    }
    return YES;
}

+(NSString *)toString:(ABRecordRef)person propertyID:(ABPropertyID)pid
{
    CFTypeRef type=ABRecordCopyValue(person, pid);
    if (type!=NULL) {
         return [NSString stringWithFormat:@"%@",type];
    }
    else
    {
        return @"";
    }
}
//CFTypeRef ABMultiValueCopyValueAtIndex(ABMultiValueRef multiValue, CFIndex index);
+(NSString *)toString:(ABMultiValueRef)values index:(CFIndex) index
{
    CFTypeRef type=ABMultiValueCopyValueAtIndex(values, index);
    if (type!=NULL) {
        return [NSString stringWithFormat:@"%@",type];
    }
    else
    {
        return @"";
    }
}

//AB_EXTERN CFStringRef ABAddressBookCopyLocalizedLabel(CFStringRef label);
+(NSString *)toStringLable:(ABMultiValueRef)values index:(CFIndex) index
{
    CFStringRef type=ABAddressBookCopyLocalizedLabel(ABMultiValueCopyLabelAtIndex(values, index));
    if (type!=NULL) {
        return [NSString stringWithFormat:@"%@",type];
    }
    else
    {
        return @"";
    }
}

@end

