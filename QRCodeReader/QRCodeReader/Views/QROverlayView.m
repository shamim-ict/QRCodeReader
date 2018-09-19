//
//  QROverlayView.m
//  QRCodeReader
//
//  Created by Shamim Hossain on 17/9/18.
//  Copyright © 2018 Shamim Hossain. All rights reserved.
//

#import "QROverlayView.h"

@implementation QROverlayView

- (void)awakeFromNib
{
	[super awakeFromNib];

	self.backgroundColor = [UIColor clearColor];
	self.layer.cornerRadius = 10;
	self.layer.borderColor = [UIColor whiteColor].CGColor;
	self.layer.borderWidth = 5;
}

@end
