//
//  ViewController.m
//  QRCodeReader
//
//  Created by Shamim Hossain on 17/9/18.
//  Copyright © 2018 Shamim Hossain. All rights reserved.
//

#import "QRReaderViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "QRCodeReader.h"
#import "QRNIDCardParser.h"
#import "QRNIDCard.h"
#import "QRPersistanceManager.h"
#import "QRPermissionManager.h"
#import "QROverlayView.h"

@interface QRReaderViewController ()
@property (weak, nonatomic) IBOutlet UIButton *scanButton;
@property (weak, nonatomic) IBOutlet QROverlayView *overlayView;

@property (weak, nonatomic) IBOutlet UIView *previewView;
@property (nonatomic, strong) QRCodeReader *reader;
@property (nonatomic, strong) QRPersistanceManager *persistanceManager;

@end

@implementation QRReaderViewController

- (void)viewDidLoad {
	[super viewDidLoad];

	self.persistanceManager = [QRPersistanceManager sharedInstance];

	if (![QRPermissionManager hasPermission:QRDevicePermissionTypeCamera]) {
		[QRPermissionManager requestPermissionFor:QRDevicePermissionTypeCamera];
	}

	self.reader = [[QRCodeReader alloc] initWithMetadataObjectTypes:@[AVMetadataObjectTypePDF417Code] previewView:self.previewView];
}

- (void)updateUIControlsForHide:(BOOL)hidden
{
	[self.scanButton setHidden:hidden];
	[self.overlayView setHidden:!hidden];
}

- (IBAction)scanButtonAction:(id)sender
{
	[self updateUIControlsForHide:YES];

	__weak __typeof(self) weakSelf = self;

	[self.reader startScanningWithCompletion:^(NSString *output, NSError *error) {
		[weakSelf.reader stopScanning];
		QRNIDCard *card = [QRNIDCardParser parseNIDCardFromScannedOutput:output];
		[weakSelf showSaveAlert:card];
		[weakSelf updateUIControlsForHide:NO];
	}];
}

- (void)showSaveAlert:(QRNIDCard *)card
{
	__weak __typeof(self) weakSelf = self;

	UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"Do you want to save?" message:card.description preferredStyle:UIAlertControllerStyleAlert];
	UIAlertAction *saveAction = [UIAlertAction actionWithTitle:@"Save" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
		[weakSelf.persistanceManager saveNIDCardIntoDB:card completionHandler:^(BOOL success, NSError *error) {
			if (error) {
				UIAlertController *failureController = [UIAlertController alertControllerWithTitle:@"Failed to save" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
				[failureController addAction:[UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleDefault handler:nil]];
				[weakSelf presentViewController:failureController animated:YES completion:nil];
			}
		}];
	}];

	[controller addAction:saveAction];

	UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Discard" style:UIAlertActionStyleCancel handler:nil];
	[controller addAction:cancelAction];

	[self presentViewController:controller animated:YES completion:nil];
}

@end
