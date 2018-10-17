//
//  DefineConfig.h
//  demoTool
//
//  Created by ms20180425 on 2018/5/23.
//  Copyright © 2018年 ms20180425. All rights reserved.
//

#ifndef NVDefineConfig_h
#define NVDefineConfig_h

//获取屏幕尺寸
#define SCREENWIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREENHEIGTH [[UIScreen mainScreen] bounds].size.height
//是否是iPhoneX
#define KIsiPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

#define NV_STATUSBARHEIGHT [UIApplication sharedApplication].statusBarFrame.size.height
#define NV_NAV_BAR_HEIGHT 44

//视频录制保存的路径
#define LOCALDIR [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]
#define VIDEO_PATH(string) [LOCALDIR stringByAppendingPathComponent:string]

//转码保存的路径
#define CONVERTPATH [LOCALDIR stringByAppendingPathComponent:@"ConvertFile"]

//水印保存路径
#define WATEMARK_PATH [LOCALDIR stringByAppendingPathComponent:@"warkmark"]

//获取用户设置的value，参数是key
#define NV_UserInfo(key) [[NSUserDefaults standardUserDefaults] objectForKey:key];

//布局比例
#define SCREANSCALE [UIScreen mainScreen].bounds.size.width / 375.0
#define SCREANSCALEHEIGHT [UIScreen mainScreen].bounds.size.height / 667.0

//获取手机系统
#define  IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

//调试模式下做判断
#ifdef DEBUG
#define TLog(format, ...) printf("%s\n\n",[[NSString stringWithFormat:format, ## __VA_ARGS__] UTF8String])
#else
#define TLog(format, ...)
#endif

//16进制颜色值
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
//rgb颜色值
#define UIColorWithRGBA(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

#endif /* NVDefineConfig_h */
