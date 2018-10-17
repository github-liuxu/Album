//
//  AlbumUtils.m
//  Album
//
//  Created by 刘东旭 on 2018/10/17.
//  Copyright © 2018年 刘东旭. All rights reserved.
//

#import "AlbumUtils.h"

@implementation AlbumUtils

+ (UIFont*)fontWithSize:(float)size {
    UIFont *font;
    if (![UIFont fontWithName:@"PingFangSC-Semibold" size:size]) {
        font = [UIFont boldSystemFontOfSize:size];
    } else {
        font = [UIFont fontWithName:@"PingFangSC-Semibold" size:size];
    }
    return font;
}

+ (UIImage *)imageWithName:(NSString *)name withScale:(float)scale {
    if (!name)
        return nil;
    NSString *path = [self getImagePath:name scale:scale];
    if ([path isEqualToString:@""]) {
        return [UIImage new];
    }
    UIImage* img=[UIImage imageWithContentsOfFile:path];
    return img;
}

+ (UIImage *)imageWithName:(NSString *)name {
    if (!name)
        return nil;
//    return [UIImage imageNamed:name];
    NSInteger scale = (NSInteger)[[UIScreen mainScreen] scale];
    NSString *path = [self getImagePath:name scale:scale];
    if ([path isEqualToString:@""]) {
        return [UIImage imageNamed:name];
    }
    UIImage* img=[UIImage imageWithContentsOfFile:path];
    return img;
}

+ (NSString *)getImagePath:(NSString *)name scale:(NSInteger)scale{
    //他们时候这里会取到空值，那我只能给它一个占位图，我们没有占位图，所以我随便找了一张
    if (name.length == 0 ||scale == 0) {
        NSLog(@"这张图不存在");
        name = @"NvsSliderHandle";
    };
    
    NSURL *bundleUrl = [[NSBundle bundleForClass:self.class] URLForResource:@"AlbumImage" withExtension:@"bundle"];
    if (bundleUrl == nil) {
        return @"";
    }
    NSBundle *customBundle = [NSBundle bundleWithURL:bundleUrl];
    NSString *bundlePath = [customBundle bundlePath];
    NSString *imgPath = [bundlePath stringByAppendingPathComponent:name];
    NSString *pathExtension = [imgPath pathExtension];
    //没有后缀加上PNG后缀
    if (!pathExtension || pathExtension.length == 0) {
        pathExtension = @"png";
    }
    //Scale是根据屏幕不同选择使用@2x还是@3x的图片
    NSString *imageName = nil;
    if (scale == 1) {
        imageName = [NSString stringWithFormat:@"%@.%@", [[imgPath lastPathComponent] stringByDeletingPathExtension], pathExtension];
    }
    else {
        imageName = [NSString stringWithFormat:@"%@@%ldx.%@", [[imgPath lastPathComponent] stringByDeletingPathExtension], (long)scale, pathExtension];
    }
    
    //返回删掉旧名称加上新名称的路径
    return [[imgPath stringByDeletingLastPathComponent] stringByAppendingPathComponent:imageName];
}

@end
