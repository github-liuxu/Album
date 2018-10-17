//
//  UIButton+NvButton.m
//  SDKDemo
//
//  Created by Meicam on 2018/5/25.
//  Copyright © 2018年 刘东旭. All rights reserved.
//

#import "UIButton+NvButton.h"
#import <objc/runtime.h>

static const void *NvButtonBlockKey = &NvButtonBlockKey;

@implementation UIButton (NvButton)

+ (instancetype)nv_buttonWithTitle:(NSString *)title textColor:(UIColor *)textColor {
    return [[self class]  nv_buttonWithTitle:title textColor:textColor fontSize:-1];
}

+ (instancetype)nv_buttonWithTitle:(NSString *)title textColor:(UIColor *)textColor fontSize:(float)fontSize {
    return [[self class]  nv_buttonWithTitle:title textColor:textColor fontSize:fontSize image:nil];
}

+ (instancetype)nv_buttonWithTitle:(NSString *)title textColor:(UIColor *)textColor fontSize:(float)fontSize image:(UIImage *)image {
    UIButton *button = [[self class] buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:textColor forState:UIControlStateNormal];
    if (image) {
        [button setImage:image forState:UIControlStateNormal];
    }
    if (fontSize != -1) {
        UIFont *font = [UIFont fontWithName:@"PingFangSC-Semibold" size:fontSize];
        if (font) {
            button.titleLabel.font = font;
        } else {
            UIFont *font = [UIFont systemFontOfSize:fontSize];
            button.titleLabel.font = font;
        }
        
    }
    return button;
}

#pragma mark  按钮点击Block
-(void)nv_BtnClickHandler:(void(^)(void))clickHandler{
    objc_setAssociatedObject(self, NvButtonBlockKey, clickHandler, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:self action:@selector(nv_actionTouched:) forControlEvents:UIControlEventTouchUpInside];
}
-(void)nv_actionTouched:(UIButton *)btn{
    void(^block)(void) = objc_getAssociatedObject(self, NvButtonBlockKey);
    if (block) {
        block();
    }
}

@end
