//
//  NvAlbumCollectionView.h
//  SDKDemo
//
//  Created by Meicam on 2018/5/29.
//  Copyright © 2018年 meishe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NvFetchAlbum.h"
@class NvAlbumCollectionView;

@protocol NvAlbumCollectionViewDelegate
//全选
- (void)nvAlbumCollectionView:(NvAlbumCollectionView *)nvAlbumCollectionView selectAssets:(NSMutableArray <NvAlbumAsset *>*)selectAssets;
//反全选
- (void)nvAlbumCollectionView:(NvAlbumCollectionView *)nvAlbumCollectionView deselectAssets:(NSMutableArray <NvAlbumAsset *>*)selectAssets;
//单选
- (void)nvAlbumCollectionView:(NvAlbumCollectionView *)nvAlbumCollectionView selectAsset:(NvAlbumAsset *)selectAsset;

@end

@interface NvAlbumCollectionView : UIView

@property (weak, nonatomic) id delegate;

@property (nonatomic, strong) NSMutableArray<NvAlbumItem *> *assetDataSource;

@property (nonatomic, assign) BOOL mutableSelect; //是否多选，默认YES,单选不会有数字标记

@property (nonatomic, assign) BOOL hiddenSelectAll; //是否隐藏全选按钮

- (instancetype)initWithFrame:(CGRect)frame withMediaType:(NvAlbumAssetType)type;

- (void)realoadData;


@end
