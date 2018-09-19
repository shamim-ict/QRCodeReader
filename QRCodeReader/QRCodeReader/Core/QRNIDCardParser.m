//
//  QRNIDCardParser.m
//  QRCodeReader
//
//  Created by Shamim Hossain on 18/9/18.
//  Copyright © 2018 Shamim Hossain. All rights reserved.
//

#import "QRNIDCardParser.h"
#import "QRNIDCard.h"

@implementation QRNIDCardParser

+ (NSString *)parse:(NSString *)string withKey:(NSString *)key
{
	NSRange location = [string rangeOfString:key];

	if (location.location != NSNotFound) {
		return [string substringFromIndex:location.location+location.length];
	}

	return nil;
}

+ (QRNIDCard *)parseNIDCardFromScannedOutput:(NSString *)output
{
	NSArray *components = [output componentsSeparatedByString:@"\x1d"];

	if (components.count == 0) {
		return nil;
	}

	NSString *ID = nil;
	NSString *name = nil;

	if (components.count > 0) {
		name = [self parse:[components objectAtIndex:0] withKey:@"NM"];
	}

	if (components.count > 1) {
		ID = [self parse:[components objectAtIndex:1] withKey:@"NW"];
	}

	return [[QRNIDCard alloc] initWithNID:ID name:name metaData:output];;
}

@end
