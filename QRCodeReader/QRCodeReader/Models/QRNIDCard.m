//
//  QRNID.m
//  QRCodeReader
//
//  Created by Shamim Hossain on 18/9/18.
//  Copyright © 2018 Shamim Hossain. All rights reserved.
//

#import "QRNIDCard.h"

@implementation QRNIDCard

- (instancetype)initWithNID:(NSString *)ID
					  name:(NSString *)name
				  metaData:(NSString *)metaData
{
	self = [super init];

	if (self) {
		_NID = ID;
		_name = name;
		_otherMetaData = metaData;
	}

	return self;
}

- (NSString *)description
{
	NSMutableString *mutableString = [[NSMutableString alloc] initWithCapacity:0];

	[mutableString appendFormat:@"Name :%@", self.name];
	[mutableString appendFormat:@"\nID: %@", self.NID];
	[mutableString appendFormat:@"\n\nOther data: %@", self.otherMetaData];

	return mutableString;
}

@end
