//
//  NvSizeView.h
//  SDKDemo
//
//  Created by Meicam on 2018/5/30.
//  Copyright © 2018年 meishe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlbumUtils.h"
@class NvSizeView;

@protocol NvSizeViewDelegate

@optional
- (void)nvSizeView:(NvSizeView *)nvSizeView selectType:(NvEditMode)type;

@end

@interface NvSizeView : UIView

@property (nonatomic, weak)id delegate;

@end
