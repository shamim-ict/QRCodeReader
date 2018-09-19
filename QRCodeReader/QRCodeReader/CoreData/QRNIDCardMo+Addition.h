//
//  QRNIDCardMo+Addition.h
//  QRCodeReader
//
//  Created by Shamim Hossain on 18/9/18.
//  Copyright © 2018 Shamim Hossain. All rights reserved.
//

#import "NIDCardsMo+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN
@class QRNIDCard;
@interface NIDCardsMo (Addition)

+ (NIDCardsMo *)findCardWithID:(NSString *)ID
					 inContext:(NSManagedObjectContext *)context;
+ (instancetype)newObjectForContext:(NSManagedObjectContext*)context
						withNIDCard:(QRNIDCard *)card;
@end

NS_ASSUME_NONNULL_END

