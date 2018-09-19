//
//  QRNIDCardTableViewCell.h
//  QRCodeReader
//
//  Created by Shamim Hossain on 19/9/18.
//  Copyright © 2018 Shamim Hossain. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QRNIDCard;
@interface QRNIDCardTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *NIDLabel;

- (void)setupCellInformation:(QRNIDCard*)card;

@end
