//
//  NvAlbumUtils.m
//  SDKDemo
//
//  Created by 刘东旭 on 2018/10/18.
//  Copyright © 2018年 meishe. All rights reserved.
//

#import "NvAlbumUtils.h"

@implementation NvAlbumUtils

+ (NSString *)convertTimecode:(int64_t)time {
    time = (time + 550000) / 1000000;
    int min = (int)time / 60;
    int sec = (int)time % 60;
    if (min >= 10 && sec >= 10)
        return [NSString stringWithFormat:@"%d:%d", min, sec];
    else if (min >= 10)
        return [NSString stringWithFormat:@"%d:0%d", min, sec];
    else if (sec >= 10)
        return [NSString stringWithFormat:@"0%d:%d", min, sec];
    else
        return [NSString stringWithFormat:@"0%d:0%d", min, sec];
}

+ (NSString *)convertTimecodePrecision:(int64_t)time {
    time += 50000;
    int min = (int)(time / 60000000);
    int sec = (int)((time % 60000000) / 100000);
    int decimal = sec % 10;
    sec /= 10;
    if (min >= 10 && sec >= 10)
        return [NSString stringWithFormat:@"%d:%d.%d", min, sec, decimal];
    else if (min >= 10)
        return [NSString stringWithFormat:@"%d:0%d.%d", min, sec, decimal];
    else if (sec >= 10)
        return [NSString stringWithFormat:@"0%d:%d.%d", min, sec, decimal];
    else
        return [NSString stringWithFormat:@"0%d:0%d.%d", min, sec, decimal];
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
    
    NSURL *bundleUrl = [[NSBundle bundleForClass:self.class] URLForResource:@"NvAlbumImage" withExtension:@"bundle"];
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

+ (UIFont*)fontWithSize:(float)size {
    UIFont *font;
    if (![UIFont fontWithName:@"PingFangSC-Semibold" size:size]) {
        font = [UIFont boldSystemFontOfSize:size];
    } else {
        font = [UIFont fontWithName:@"PingFangSC-Semibold" size:size];
    }
    return font;
}

@end
