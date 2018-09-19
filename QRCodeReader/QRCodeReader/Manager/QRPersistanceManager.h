//
//  QRStorageManager.h
//  QRCodeReader
//
//  Created by Shamim Hossain on 17/9/18.
//  Copyright © 2018 Shamim Hossain. All rights reserved.
//

#import <Foundation/Foundation.h>

@class QRNIDCard;
@interface QRPersistanceManager : NSObject

+ (instancetype)sharedInstance;

- (void)saveNIDCardIntoDB:(QRNIDCard *)card completionHandler:(void(^)(BOOL success, NSError *error))completion;

- (void)fetchNIDCardsWithOffset:(NSInteger)offset limit:(NSInteger)limit completionHandler:(void(^)(NSArray<QRNIDCard *> *output, NSError *error))block;

@end
