//
//  QRNIDCardMo+Addition.m
//  QRCodeReader
//
//  Created by Shamim Hossain on 18/9/18.
//  Copyright © 2018 Shamim Hossain. All rights reserved.
//

#import "QRNIDCardMo+Addition.h"
#import "NIDCardsMo+CoreDataProperties.h"
#import "QRNIDCard.h"

@implementation NIDCardsMo (Addition)

+ (instancetype)newObjectForContext:(NSManagedObjectContext*)context
{
	return  [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
}

+ (instancetype)newObjectForContext:(NSManagedObjectContext*)context withNIDCard:(QRNIDCard *) card
{
	NIDCardsMo *cardMo = [[self class] newObjectForContext:context];
	cardMo.identifier = card.NID;
	cardMo.name = card.name;
	cardMo.metaData = card.otherMetaData;

	return cardMo;
}

+ (NIDCardsMo *)findCardWithID:(NSString *)ID
					 inContext:(NSManagedObjectContext *)context
{
	__block NIDCardsMo *cardMo = nil;

	[context performBlockAndWait: ^{
		NSFetchRequest *request = [NIDCardsMo fetchRequest];
		request.predicate = [NSPredicate predicateWithFormat:
							 @"identifier == %@",ID];;
		request.fetchLimit = 1;

		NSError * error = nil;
		NSArray *possibleIDs = [context executeFetchRequest:request error: &error];

		if (possibleIDs == nil) {
			NSLog(@"Something went wrong while look-up %@", ID);
		} else {
			cardMo = possibleIDs.firstObject;
		}
	}];

	return cardMo;
}

@end
