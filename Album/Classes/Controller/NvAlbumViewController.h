//
//  NvAlbumViewController.h
//  SDKDemo
//
//  Created by Meicam on 2018/5/25.
//  Copyright © 2018年 刘东旭. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NvAlbumItem.h"
@class NvAlbumViewController;

typedef enum : NSUInteger {
    NvSelectAssetAll,
    NvSelectAssetVideo,
    NvSelectAssetImage,
} NvSelectAssetType;

@protocol NvAlbumViewControllerDelegate

@optional
- (void)nvAlbumViewController:(NvAlbumViewController *)albumViewController selectAlbumAssets:(NSMutableArray <NvAlbumAsset *>*)assets;

- (void)nvAlbumViewController:(NvAlbumViewController *)albumViewController selectAlbumAssetsOverMaxCountLimit:(NSMutableArray <NvAlbumAsset *>*)assets;

- (void)nvAlbumViewControllerCancelClick:(NvAlbumViewController *)albumViewController;

@end

@interface NvAlbumViewController : UIViewController

@property (nonatomic, weak) id delegate;

/**
 isOnlyImage和isOnlyVideo互斥，不要同时设置
 */

@property (nonatomic, assign) BOOL isOnlyImage; //是否仅现实图片
@property (nonatomic, assign) BOOL isOnlyVideo; //是否仅为视频
@property (nonatomic, assign) BOOL mutableSelect; //是否多选，默认YES,单选不会有数字标记

@property (nonatomic, assign) NSInteger maxSelectCount; //最多选择的个数
@property (nonatomic, assign) NSInteger minSelectCount; //最少选择的个数

@property (nonatomic, assign) BOOL hiddenSelectAll; //是否隐藏全选按钮

//自定义下一步按钮的文字
- (void)customSelectAssetButtonText:(NSString *)text;

@end
