//
//  QRNIDCardTableViewCell.m
//  QRCodeReader
//
//  Created by Shamim Hossain on 19/9/18.
//  Copyright © 2018 Shamim Hossain. All rights reserved.
//

#import "QRNIDCardTableViewCell.h"
#import "QRNIDCard.h"

@implementation QRNIDCardTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setupCellInformation:(QRNIDCard*)card
{
	self.nameLabel.text = card.name;
	self.NIDLabel.text = [NSString stringWithFormat:@"NID: %@",card.NID];
}

@end
