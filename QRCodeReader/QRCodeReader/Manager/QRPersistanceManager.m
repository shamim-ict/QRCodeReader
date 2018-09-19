//
//  QRStorageManager.m
//  QRCodeReader
//
//  Created by Shamim Hossain on 17/9/18.
//  Copyright © 2018 Shamim Hossain. All rights reserved.
//

#import "QRPersistanceManager.h"
#import <CoreData/CoreData.h>
#import "QRNIDCardMo+Addition.h"
#import "QRNIDCard.h"

@interface QRPersistanceManager()

@property (nonatomic, strong) NSPersistentContainer *persistentContainer;

@end

@implementation QRPersistanceManager

+ (instancetype)sharedInstance
{
	static QRPersistanceManager *instance = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		instance = [[self alloc] init];
	});

	return instance;
}

- (instancetype)init
{
	self = [super init];

	if (self) {
		[self setupCoreStack];
	}

	return self;
}

- (void)setupCoreStack
{
	self.persistentContainer = [[NSPersistentContainer alloc] initWithName:@"QRCodeReader"];
	[self.persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription * _Nonnull storeDescription, NSError * _Nullable error) {
		NSLog(@"Core stack is ready to use with error:%@", error.localizedDescription);
	}];
}

- (BOOL)saveContext
{
	NSManagedObjectContext *context = self.persistentContainer.viewContext;
	NSError *error = nil;

	if ([context hasChanges] && ![context save:&error]) {
		NSLog(@"Unresolved error %@, %@", error, error.userInfo);
		NSAssert(0, @"Failed to save context with error:%@", error.localizedDescription);
		return NO;
	}

	return YES;
}

- (void)saveNIDCardIntoDB:(QRNIDCard *)card completionHandler:(void(^)(BOOL success, NSError *error))completion
{
	__weak __typeof(self) weakSelf = self;

	[self.persistentContainer performBackgroundTask:^(NSManagedObjectContext * _Nonnull context) {
		NIDCardsMo *cardMo = [NIDCardsMo findCardWithID:card.NID inContext:context];

		[[NSOperationQueue mainQueue] addOperationWithBlock:^{
			NSError *error = nil;
			BOOL success = NO;
			if (cardMo != nil) {
				//Already exist
				error = [NSError errorWithDomain:@"scanner.error.domain" code:1001 userInfo:@{NSLocalizedDescriptionKey:@"Already exist"}];
			} else {
				NIDCardsMo *newCardMo = [NIDCardsMo newObjectForContext:context withNIDCard:card];
				if (newCardMo) {
					success = [context save:&error];

					if (success) {
						success = [weakSelf saveContext];
					}
				}
			}

			if (completion) {
				completion(success, error);
			}
		}];
	}];
}

- (void)fetchNIDCardsWithOffset:(NSInteger)offset limit:(NSInteger)limit completionHandler:(void(^)(NSArray<QRNIDCard *> *output, NSError *error))block
{
	[self.persistentContainer performBackgroundTask:^(NSManagedObjectContext * _Nonnull context) {
		NSFetchRequest *request = [NIDCardsMo fetchRequest];
		request.fetchOffset = offset;
		request.fetchLimit = limit;

		NSError *error = nil;
		NSArray *results = [context executeFetchRequest:request error:&error];

		NSMutableArray *outputArray = [NSMutableArray arrayWithCapacity:results.count];

		for (NIDCardsMo *cardMo in results) {
			QRNIDCard *card = [[QRNIDCard alloc] initWithNID:cardMo.identifier name:cardMo.name metaData:cardMo.metaData];
			[outputArray addObject:card];
		}

		if (block) {
			[[NSOperationQueue mainQueue] addOperationWithBlock:^{
				block(outputArray, error);
			}];
		}
	}];
}

@end
