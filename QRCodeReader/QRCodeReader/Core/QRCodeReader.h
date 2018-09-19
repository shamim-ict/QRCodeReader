//
//  QRCodeReader.h
//  QRCodeReader
//
//  Created by Shamim Hossain on 17/9/18.
//  Copyright © 2018 Shamim Hossain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^QRReaderCompletionBlock)(NSString *output, NSError *error);

@interface QRCodeReader : NSObject

@property(nonatomic, strong, readonly) NSArray *metadataObjectTypes;
@property(nonatomic, strong, readonly) UIView *previewView;

- (instancetype)init __unavailable;

- (instancetype)initWithMetadataObjectTypes:(NSArray *)types previewView:(UIView *)previewView;

- (void)startScanningWithCompletion:(QRReaderCompletionBlock)completion;
- (void)stopScanning;

- (void)toggleCamera;
- (void)toggleTorchLight;

@end
