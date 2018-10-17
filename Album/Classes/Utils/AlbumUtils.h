//
//  AlbumUtils.h
//  Album
//
//  Created by 刘东旭 on 2018/10/17.
//  Copyright © 2018年 刘东旭. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIColor+NvColor.h"
#import "UIButton+NvButton.h"
#import "UILabel+NvLabel.h"
#import "UIView+Dimension.h"
@import UIKit;

NS_ASSUME_NONNULL_BEGIN

typedef enum {
    NvEditMode16v9 = 0,
    NvEditMode1v1,
    NvEditMode9v16,
    NvEditMode3v4,
    NvEditMode4v3
} NvEditMode;

@interface AlbumUtils : NSObject

+ (UIFont*)fontWithSize:(float)size;

+ (UIImage *)imageWithName:(NSString *)name withScale:(float)scale;
+ (UIImage *)imageWithName:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
