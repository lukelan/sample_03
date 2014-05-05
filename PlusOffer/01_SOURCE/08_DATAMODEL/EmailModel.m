//
//  EmailModel.m
//  PlusOffer
//
//  Created by Trong Vu on 5/5/14.
//  Copyright (c) 2014 Trongvm. All rights reserved.
//

#import "EmailModel.h"


@implementation EmailModel

@dynamic identifier;
@dynamic email;
@dynamic name;

+ (EmailModel*) getEmailWithID:(NSString*)email  {
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *_managedObjectContext = delegate.managedObjectContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.includesSubentities = NO;
    NSEntityDescription *entity = [NSEntityDescription entityForName:[EmailModel description] inManagedObjectContext:_managedObjectContext];
    [fetchRequest setEntity:entity];
    
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"email"  ascending:YES selector:@selector(caseInsensitiveCompare:)];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    // init predicate to search
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"email == %@", email];
    [fetchRequest setPredicate:pred];

    
    NSError *error;
    NSArray *items = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if (items.count == 0) {
        return nil;
    }
    
    return [items objectAtIndex:0];
}

+ (void)insertEmailDataFromServer:(GDataFeedContact *)dataList
{
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *_managedObjectContext = delegate.managedObjectContext;
    
    NSArray *entries = [dataList entries];
    
    for (GDataEntryContact *contact in entries) {
        // ID
        NSString *idValue = [contact identifier];
        
        // Name
        GDataTextConstruct *nameObject = [contact title];
        NSString *nameValue = [nameObject stringValue];
        
        // Email
        for (GDataEmail *emailObject in  [contact emailAddresses]) {
            NSString *emailValue = [emailObject address];
            EmailModel *item;
            
            // Check Email exist
            item = [EmailModel getEmailWithID:emailValue];
            
            if (item != nil) {
            // email already existed - Do nothing
                
            } else {
                item = [NSEntityDescription insertNewObjectForEntityForName:[EmailModel description] inManagedObjectContext:_managedObjectContext];
                item.name = nameValue;
                item.email = emailValue;
                item.identifier = idValue;
            }
        }
    }
    
    [delegate saveContext];
}

@end
