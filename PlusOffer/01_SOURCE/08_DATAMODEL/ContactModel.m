//
//  ContactModel.m
//  PlusOffer
//
//  Created by Trong Vu on 4/28/14.
//  Copyright (c) 2014 Trongvm. All rights reserved.
//

#import "ContactModel.h"


@implementation ContactModel

@dynamic id;
@dynamic organization;
@dynamic email;
@dynamic im;
@dynamic phone;
@dynamic postal;
@dynamic group;

#pragma mark - Public Methods

+ (void)insertContactDataFromServer:(GDataFeedContact *)dataList
{
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *_managedObjectContext = delegate.managedObjectContext;
    
    NSArray *entries = [dataList entries];
    
    for (GDataEntryContact *contact in entries) {
       
        NSString *nameValue = [contact title];
        int numOrg = [[contact organizations] count];
        NSString *orgLabel = [NSString stringWithFormat:@"Org - %d", numOrg];
        NSString *orgValue = [[contact organizations] objectAtIndex:0];
        
        int numEmail = [[contact emailAddresses] count];
        NSString *mailLabel = [NSString stringWithFormat:@"E-mail - %d", numEmail];
        GDataEmail *emailObject = [[contact emailAddresses] objectAtIndex:0];
        NSString *emailValue = [emailObject address];
        
        NSLog(@"$@---%@",nameValue,emailValue);
        
//        int numIM = [[[self selectedContact] IMAddresses] count];
//        NSString *IMlabel = [NSString stringWithFormat:@"IM - %d", numIM];
//        [mEntrySegmentedControl setLabel:IMlabel forSegment:kIMSegment];
//        [mEntrySegmentedControl setEnabled:isDisplayingContacts forSegment:kIMSegment];
//        
//        int numPhone = [[[self selectedContact] phoneNumbers] count];
//        NSString *phoneLabel = [NSString stringWithFormat:@"Phone - %d", numPhone];
//        [mEntrySegmentedControl setLabel:phoneLabel forSegment:kPhoneSegment];
//        [mEntrySegmentedControl setEnabled:isDisplayingContacts forSegment:kPhoneSegment];
//        
//        int numPostal = [[[self selectedContact] structuredPostalAddresses] count];
//        NSString *postalLabel = [NSString stringWithFormat:@"Postal - %d", numPostal];
//        [mEntrySegmentedControl setLabel:postalLabel forSegment:kPostalSegment];
//        [mEntrySegmentedControl setEnabled:isDisplayingContacts forSegment:kPostalSegment];
//        
//        int numGroupInfos = [[[self selectedContact] groupMembershipInfos] count];
//        NSString *groupLabel = [NSString stringWithFormat:@"Group - %d", numGroupInfos];
//        [mEntrySegmentedControl setLabel:groupLabel forSegment:kGroupSegment];
//        [mEntrySegmentedControl setEnabled:isDisplayingContacts forSegment:kGroupSegment];
//        
//        int numExtProps;
//        if ([self isDisplayingContacts]) {
//            numExtProps = [[[self selectedContact] extendedProperties] count];
//        } else {
//            numExtProps = [[[self selectedGroup] extendedProperties] count];
//        }
//        NSString *extPropsLabel = [NSString stringWithFormat:@"ExtProp - %d", numExtProps];
//        [mEntrySegmentedControl setLabel:extPropsLabel forSegment:kExtendedPropsSegment];
//
//        
//        
//        NSMutableDictionary *dicJson = [SupportFunction repairingDictionaryWith:dict];
//        VKHomeActivity *item = [NSEntityDescription insertNewObjectForEntityForName:VKHOMEACTIVITY_MODEL inManagedObjectContext:_managedObjectContext];
//        
//        item.repostName = [dicJson objectForKey:@"repostName"];
//        item.repostfkKard = [dicJson objectForKey:@"repostfkKard"];
//        item.mediaType = [dicJson objectForKey:@"mediaType"];
//        item.imageSmall = [dicJson objectForKey:STRING_RESPONSE_KEY_IMAGE_SMALL];
//        item.fkUser = [dicJson objectForKey:STRING_RESPONSE_KEY_FK_USER];
//        item.fkKard = [dicJson objectForKey:STRING_RESPONSE_KEY_FK_KARD];
//        item.flgRead = [dicJson objectForKey:@"flgRead"];
//        item.idNews = [dicJson objectForKey:STRING_RESPONSE_KEY_ID_NEWS];
//        item.datecreated = [dicJson objectForKey:STRING_RESPONSE_KEY_DATE_CREATED];
//        item.countLike = [dicJson objectForKey:STRING_RESPONSE_KEY_COUNT_LIKE];
//        item.isLike = [dicJson objectForKey:STRING_RESPONSE_KEY_IS_LIKE];
//        item.timeServer = [dicJson objectForKey:STRING_RESPONSE_KEY_TIME_SERVER];
//        item.timeAgo = [dicJson objectForKey:@"timeAgo"];
//        item.imageUrl1 = [dicJson objectForKey:@"imageUrl1"];
//        item.imageUrl2 = [dicJson objectForKey:@"imageUrl2"];
//        item.imageUrl3 = [dicJson objectForKey:@"imageUrl3"];
//        item.imageUrl4 = [dicJson objectForKey:@"imageUrl4"];
//        item.optionalLocation = [dicJson objectForKey:@"optionalLocation"];
//        item.isPrivate = [dicJson objectForKey:@"isPrivate"];
//        item.fkMeKard = [dicJson objectForKey:@"fkMeKard"];
//        item.countResponse = [dicJson objectForKey:STRING_RESPONSE_KEY_COUNT_RESP];
//        item.thumbMedia = [dicJson objectForKey:STRING_RESPONSE_KEY_MEDIA_THUMB];
//        item.key_type = [dicJson objectForKey:@"key_type"];
//        item.comment = [dicJson objectForKey:STRING_RESPONSE_KEY_COMMENTS];
//        item.fullName = [dicJson objectForKey:STRING_RESPONSE_KEY_FULL_NAME_LOGIN];
//        item.blurethumbMedia = [dicJson objectForKey:@"blurethumbMedia"];
    }
    
//    [[AppViewController Shared] saveContext];
}

@end
