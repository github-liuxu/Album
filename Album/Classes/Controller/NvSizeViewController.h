//
//  NvSizeViewController.h
//  SDKDemo
//
//  Created by Meicam on 2018/5/30.
//  Copyright © 2018年 meishe. All rights reserved.
//

#import "NvSizeView.h"

@interface NvSizeViewController : UIViewController

- (void)selectSizeTypeBlock:(void(^)(NvEditMode type))block;

@end
