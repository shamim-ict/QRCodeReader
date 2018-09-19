//
//  QRPermissionManager.m
//  QRCodeReader
//
//  Created by Shamim Hossain on 17/9/18.
//  Copyright © 2018 Shamim Hossain. All rights reserved.
//

#import "QRPermissionManager.h"
#import <AVFoundation/AVFoundation.h>

@interface QRPermissionManager()

@property(nonatomic, strong) NSArray *permissions;

@end

@implementation QRPermissionManager

+ (BOOL)isCameraAccessAuthorized
{
	switch ([AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo]) {
		case AVAuthorizationStatusDenied:
		case AVAuthorizationStatusRestricted:
			return YES;
			break;

		default:
			return NO;
			break;
	}
}

+ (void)requestCameraAccess
{
	[AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo
							 completionHandler:^(BOOL granted) {
								 //This time, it is not required to follow
							 }];
}

+ (BOOL)hasPermission:(QRDevicePermissionType)type
{
	switch (type) {
		case QRDevicePermissionTypeCamera:
			return [[self class] isCameraAccessAuthorized];
			break;
	}

	return NO;
}

+ (void)requestPermissionFor:(QRDevicePermissionType)type
{
	switch (type) {
		case QRDevicePermissionTypeCamera:
			[[self class] requestCameraAccess];
			break;
	}
}

@end
