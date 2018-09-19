//
//  QRPermissionManager.h
//  QRCodeReader
//
//  Created by Shamim Hossain on 17/9/18.
//  Copyright © 2018 Shamim Hossain. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, QRDevicePermissionType) {
	QRDevicePermissionTypeCamera,
};

@interface QRPermissionManager : NSObject

+ (BOOL)hasPermission:(QRDevicePermissionType)type;
+ (void)requestPermissionFor:(QRDevicePermissionType)type;

@end
