//
//  NvButton.h
//  wangyi
//
//  Created by dx on 2018/3/28.
//  Copyright © 2018年 meicam.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NvButton : UIButton

@property(assign, nonatomic) float expandCofficient;
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent*)event;
@end
