//
//  ContactModel.m
//  PlusOffer
//
//  Created by Trong Vu on 4/28/14.
//  Copyright (c) 2014 Trongvm. All rights reserved.
//

#import "ContactModel.h"


@implementation ContactModel

@dynamic identifier;
@dynamic organization;
@dynamic email;
@dynamic name;
@dynamic im;
@dynamic phone;
@dynamic postal;
@dynamic group;

#pragma mark - Public Methods

+ (ContactModel*) getContactWithID:(NSString*)identifier  {
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *_managedObjectContext = delegate.managedObjectContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.includesSubentities = NO;
    NSEntityDescription *entity = [NSEntityDescription entityForName:[ContactModel description] inManagedObjectContext:_managedObjectContext];
    [fetchRequest setEntity:entity];
    
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"identifier"  ascending:YES selector:@selector(caseInsensitiveCompare:)];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    // init predicate to search
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"identifier == %@", identifier];
    [fetchRequest setPredicate:pred];
    
    
    NSError *error;
    NSArray *items = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if (items.count == 0) {
        return nil;
    }
    
    return [items objectAtIndex:0];
}

+ (void)insertContactDataFromServer:(GDataFeedContact *)dataList
{
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *_managedObjectContext = delegate.managedObjectContext;
    
    NSArray *entries = [dataList entries];
    
    for (GDataEntryContact *contact in entries) {
       
        // ID
        NSString *idValue = [contact identifier];
        
        
        GDataTextConstruct *nameObject = [contact title];
        NSString *nameValue = [nameObject stringValue];
        
        // Org
        NSString *orgLabel = @"";
        for (NSString *orgValue in  [contact organizations]) {
            orgLabel = [NSString stringWithFormat:@"%@,%@",orgLabel,orgValue];
        }
        
        
        // Email
        int numEmail = [[contact emailAddresses] count];
        NSString *mailLabel = @"";
        for (GDataEmail *emailObject in  [contact emailAddresses]) {
            NSString *emailValue = [emailObject address];
            if ([mailLabel  isEqual: @""]) {
                mailLabel = emailValue;
            } else {
                mailLabel = [NSString stringWithFormat:@"%@,%@",mailLabel,emailValue];
            }
        }
        
        // IM
        int numIM = [[contact IMAddresses] count];
        NSString *IMLabel = @"";
        for (GDataIM *IMObject in  [contact IMAddresses]) {
            NSString *IMValue = [IMObject address];
            if ([IMLabel  isEqual: @""]) {
                IMLabel = IMValue;
            } else {
                IMLabel = [NSString stringWithFormat:@"%@,%@",IMLabel,IMValue];
            }
        }
        
        // Phone
        int numPhone = [[contact phoneNumbers] count];
        NSString *phoneLabel = @"";
        for (GDataPhoneNumber *phoneObject in  [contact phoneNumbers]) {
            NSString *phoneValue = [phoneObject stringValue];
            if ([phoneLabel  isEqual: @""]) {
                phoneLabel = phoneValue;
            } else {
                phoneLabel = [NSString stringWithFormat:@"%@,%@",phoneLabel,phoneValue];
            }
        }
        
        
        // Group
        int numGroupInfos = [[contact groupMembershipInfos] count];
        NSString *groupLabel = @"";
        for (GDataGroupMembershipInfo *groupObject in  [contact groupMembershipInfos]) {
            NSString *groupValue = [groupObject href];
            if ([groupLabel  isEqual: @""]) {
                groupLabel = groupValue;
            } else {
                groupLabel = [NSString stringWithFormat:@"%@,%@",groupLabel,groupValue];
            }
        }

        
        // Postal
        int numPostal = [[contact structuredPostalAddresses] count];
        NSString *postalLabel = @"";
        for (GDataStructuredPostalAddress *postalObject in  [contact structuredPostalAddresses]) {
             //TODO: need to prepare the DB and store later
        }
        
        
        // ExtProps
        int numExtProps = [[contact extendedProperties] count];
        NSString *extlLabel = @"";
        for (GDataExtendedProperty *extObject in  [contact extendedProperties]) {
            //TODO: need to prepare the DB and store later
        }

        ContactModel *item;
        
        item = [ContactModel getContactWithID:idValue];
        
        if (item != nil) {
            // Do nothing
        } else {
            item = [NSEntityDescription insertNewObjectForEntityForName:[ContactModel description] inManagedObjectContext:_managedObjectContext];
            item.name = nameValue;
            item.organization = orgLabel;
            item.email = mailLabel;
            item.im = IMLabel;
            item.phone = phoneLabel;
            item.group = groupLabel;
            item.identifier = idValue;
        }
        
        
      
    }
    
    [delegate saveContext];
}

@end
