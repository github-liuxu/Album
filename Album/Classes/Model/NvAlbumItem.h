//
//  NvAlbumItem.h
//  SDKDemo
//
//  Created by Meicam on 2018/5/28.
//  Copyright © 2018年 meishe. All rights reserved.
//

#import <Foundation/Foundation.h>
@import Photos;

@interface NvAlbumAsset : NSObject

//是否需要展示蒙层
@property (nonatomic, assign) BOOL isShowLayer;
//被选择的个数
@property (nonatomic, assign) NSInteger number;

@property (nonatomic, strong) PHAsset *asset;
//显示cell的时候被赋值
@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, strong) UIImage *coverImage;

@end

@interface NvAlbumItem : NSObject

@property (nonatomic, strong) NSMutableArray<NvAlbumAsset *> *collectionList;

@property (nonatomic, strong) NSDate *startDate;

@property (nonatomic, assign) BOOL isSelectAll;

@end
