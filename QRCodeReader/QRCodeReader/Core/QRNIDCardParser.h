//
//  QRNIDCardParser.h
//  QRCodeReader
//
//  Created by Shamim Hossain on 18/9/18.
//  Copyright © 2018 Shamim Hossain. All rights reserved.
//

#import <Foundation/Foundation.h>

@class QRNIDCard;
@interface QRNIDCardParser : NSObject

+ (QRNIDCard *)parseNIDCardFromScannedOutput:(NSString *)output;

@end
