//
//  NvAlbumUtils.h
//  SDKDemo
//
//  Created by 刘东旭 on 2018/10/18.
//  Copyright © 2018年 meishe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "NVDefineConfig.h"
#import "Masonry.h"
#import "UIColor+NvColor.h"
#import "UIButton+NvButton.h"
#import "UILabel+NvLabel.h"
#import "UIView+Dimension.h"

#import "NvButton.h"

@interface NvAlbumUtils : NSObject

+ (NSString *)convertTimecode:(int64_t)time;
+ (NSString *)convertTimecodePrecision:(int64_t)time;

+ (UIImage *)imageWithName:(NSString *)name withScale:(float)scale;
+ (UIImage *)imageWithName:(NSString *)name;
+ (UIFont*)fontWithSize:(float)size;

@end
