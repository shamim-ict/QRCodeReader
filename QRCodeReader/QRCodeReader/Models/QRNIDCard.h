//
//  QRNID.h
//  QRCodeReader
//
//  Created by Shamim Hossain on 18/9/18.
//  Copyright © 2018 Shamim Hossain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QRNIDCard : NSObject

@property(nonatomic, strong) NSString *NID;
@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *otherMetaData;

- (instancetype)initWithNID:(NSString *)ID
					  name:(NSString *)name
				  metaData:(NSString *)metaData;

@end
