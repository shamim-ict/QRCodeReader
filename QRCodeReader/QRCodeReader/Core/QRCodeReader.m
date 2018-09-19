//
//  QRCodeReader.m
//  QRCodeReader
//
//  Created by Shamim Hossain on 17/9/18.
//  Copyright © 2018 Shamim Hossain. All rights reserved.
//

#import "QRCodeReader.h"
#import <AVFoundation/AVFoundation.h>

@interface QRCodeReader()<AVCaptureMetadataOutputObjectsDelegate>

@property(nonatomic, strong) AVCaptureSession *captureSession;
@property(nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;

@property(nonatomic, strong) AVCaptureDevice *frontCamera;
@property(nonatomic, strong) AVCaptureDevice *backCamera;

@property(nonatomic, copy) QRReaderCompletionBlock completionBlock;

@end

@implementation QRCodeReader

- (instancetype)initWithMetadataObjectTypes:(NSArray *)types previewView:(UIView *)previewView
{
	self = [super init];

	if (self) {
		_metadataObjectTypes = [types copy];
		_previewView = previewView;

		[self setupSessionComponents];
	}

	return self;
}

- (void)setupSessionComponents
{
	AVCaptureSession *captureSession = [[AVCaptureSession alloc] init];

	self.backCamera = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];

	NSError *error = nil;
	AVCaptureInput *captureInput = [AVCaptureDeviceInput deviceInputWithDevice:self.backCamera error:&error];

	if (!error && captureInput ) {
		[captureSession addInput:captureInput];
	}

	AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
	[captureSession addOutput:output];

	NSMutableSet *available = [NSMutableSet setWithArray:[output availableMetadataObjectTypes]];
	NSSet *desired = [NSSet setWithArray:self.metadataObjectTypes];
	[available intersectSet:desired];

	[output setMetadataObjectTypes:available.allObjects];
	[output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];

	AVCaptureVideoPreviewLayer *previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:captureSession];
	previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
	previewLayer.frame = self.previewView.bounds;

	[self.previewView.layer insertSublayer:previewLayer atIndex:0];

	[self setPreviewLayer:previewLayer];
	[self setCaptureSession:captureSession];

	for (AVCaptureDevice *device in [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo]) {
		if (device.position == AVCaptureDevicePositionFront) {
			self.frontCamera = device;
		}
	}
}

- (void)toggleCamera
{
	[self.captureSession beginConfiguration];

	AVCaptureDeviceInput *currentInput = [self.captureSession.inputs firstObject];
	[self.captureSession removeInput:currentInput];

	AVCaptureDevice *newDevice = (currentInput.device.position == AVCaptureDevicePositionFront) ? self.backCamera : self.frontCamera;

	AVCaptureDeviceInput *newDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:newDevice error:nil];
	[self.captureSession addInput:newDeviceInput];

	[self.captureSession commitConfiguration];
}

- (void)toggleTorchLight
{
	NSError *error = nil;

	[self.backCamera lockForConfiguration:&error];

	if (error == nil) {
		AVCaptureTorchMode mode = self.backCamera.torchMode;

		self.backCamera.torchMode = mode == AVCaptureTorchModeOn ? AVCaptureTorchModeOff : AVCaptureTorchModeOn;
	}

	[self.backCamera unlockForConfiguration];
}

#pragma Scanning

- (void)startScanningWithCompletion:(QRReaderCompletionBlock)completion;
{
	self.completionBlock = completion;
	self.previewLayer.frame = self.previewView.bounds;

	if (![self.captureSession isRunning]) {
		[self.captureSession startRunning];
	}
}

- (void)stopScanning
{
	if ([self.captureSession isRunning]) {
		[self.captureSession stopRunning];
	}

	self.completionBlock = nil;
}

#pragma AVCaptureMetadataOutputObjectsDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
	for (AVMetadataObject *current in metadataObjects) {
		if ([current isKindOfClass:[AVMetadataMachineReadableCodeObject class]]
			&& [_metadataObjectTypes containsObject:current.type]) {
			NSString *scannedResult = [(AVMetadataMachineReadableCodeObject *)current stringValue];
			NSLog(@"result: %@", scannedResult);
			if (self.completionBlock) {
				self.completionBlock(scannedResult, nil);
			}

			self.completionBlock = nil;

			break;
		}
	}
}

@end
