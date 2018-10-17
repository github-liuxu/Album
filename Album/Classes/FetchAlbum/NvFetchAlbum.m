//
//  NvFetchAlbum.m
//  SDKDemo
//
//  Created by Meicam on 2018/5/29.
//  Copyright © 2018年 meishe. All rights reserved.
//

#import "NvFetchAlbum.h"
#import "NvAlbumItem.h"

@import Photos;

@interface NvFetchAlbum ()

@property (nonatomic, strong) NSMutableArray<NvAlbumItem *> *assetDataSource;
@property (nonatomic, strong) NSMutableArray<NvAlbumItem *> *imageDataSource;
@property (nonatomic, strong) NSMutableArray<NvAlbumItem *> *videoDataSource;

@end

@implementation NvFetchAlbum

- (void)dealloc {
    NSLog(@"%s",__func__);
}

- (instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}

// MARK: 查询PHAsset数据
- (void)loadAssetWithType:(NvAlbumAssetType)type complete:(void(^)(NSMutableArray <NvAlbumItem *>*dataSource))complete {
    CFAbsoluteTime state = CFAbsoluteTimeGetCurrent();
    // 获得相机时刻
    self.assetDataSource = [NSMutableArray array];
    __weak typeof(self)weakSelf = self;
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (status == PHAuthorizationStatusAuthorized) {
            PHFetchResult<PHAssetCollection *> *collections = [PHAssetCollection fetchMomentsWithOptions:nil];
            for (int i = (int)collections.count-1; i>=0; i--) {
                PHAssetCollection *collectionList = collections[i];
                NvAlbumItem *item = [NvAlbumItem new];
                item.startDate = collectionList.startDate;
                PHFetchOptions *options = [[PHFetchOptions alloc] init];
                options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
                PHFetchResult<PHAsset *> *phAsset = [PHAsset fetchAssetsInAssetCollection:collectionList options:options];
                NSMutableArray *assetArray = [NSMutableArray array];
                [phAsset enumerateObjectsUsingBlock:^(PHAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if (type == NvAlbumAssetAll) {
                        NvAlbumAsset *albumAsset = [NvAlbumAsset new];
                        albumAsset.asset = obj;
                        [assetArray insertObject:albumAsset atIndex:0];
                    } else if (type == NvAlbumAssetAllVideo) {
                        if (obj.mediaType == PHAssetMediaTypeVideo) {
                            NvAlbumAsset *albumAsset = [NvAlbumAsset new];
                            albumAsset.asset = obj;
                            [assetArray insertObject:albumAsset atIndex:0];
                        }
                    } else if (type == NvAlbumAssetAllImage) {
                        if (obj.mediaType == PHAssetMediaTypeImage) {
                            NvAlbumAsset *albumAsset = [NvAlbumAsset new];
                            albumAsset.asset = obj;
                            [assetArray insertObject:albumAsset atIndex:0];
                        }
                    }
                    
                }];
                
                item.collectionList = assetArray;
                //此时如果数组不大于0证明此项section里没有数据(可能在图片模式下和视频模式下没有数据)
                if (item.collectionList.count > 0) {
                    [weakSelf.assetDataSource addObject:item];
                }
            }
            complete(weakSelf.assetDataSource);
            CFAbsoluteTime end = CFAbsoluteTimeGetCurrent();
            NSLog(@"执行时间：t2-t1=%f",end-state);
            NSLog(@"结束了");
        }
    }];
}

- (void)loadAssetcomplete:(void(^)(NSMutableArray <NvAlbumItem *>*dataSource, NSMutableArray <NvAlbumItem *>*videoDataSource, NSMutableArray <NvAlbumItem *>*imageDataSource))complete {
    CFAbsoluteTime state = CFAbsoluteTimeGetCurrent();
    // 获得相机时刻
    self.assetDataSource = [NSMutableArray array];
    self.imageDataSource = [NSMutableArray array];
    self.videoDataSource = [NSMutableArray array];
    __weak typeof(self)weakSelf = self;
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (status == PHAuthorizationStatusAuthorized) {
            PHFetchResult<PHAssetCollection *> *collections = [PHAssetCollection fetchMomentsWithOptions:nil];
            for (int i = (int)collections.count-1; i>=0; i--) {
                PHAssetCollection *collectionList = collections[i];
                
                NvAlbumItem *allItem = [NvAlbumItem new];
                NvAlbumItem *videoItem = [NvAlbumItem new];
                NvAlbumItem *imageItem = [NvAlbumItem new];
                allItem.startDate = collectionList.startDate;
                videoItem.startDate = collectionList.startDate;
                imageItem.startDate = collectionList.startDate;
                
                PHFetchOptions *options = [[PHFetchOptions alloc] init];
                options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
                PHFetchResult<PHAsset *> *phAsset = [PHAsset fetchAssetsInAssetCollection:collectionList options:options];
                
                NSMutableArray *assetArray = [NSMutableArray array];
                NSMutableArray *videoArray = [NSMutableArray array];
                NSMutableArray *imageArray = [NSMutableArray array];
                
                [phAsset enumerateObjectsUsingBlock:^(PHAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if (obj.localIdentifier) {
                        if (obj.mediaType == PHAssetMediaTypeVideo) {
                            NvAlbumAsset *albumAsset = [NvAlbumAsset new];
                            albumAsset.asset = obj;
                            [assetArray insertObject:albumAsset atIndex:0];
                            [videoArray insertObject:albumAsset atIndex:0];
                        } else if (obj.mediaType == PHAssetMediaTypeImage) {
                            NvAlbumAsset *albumAsset = [NvAlbumAsset new];
                            albumAsset.asset = obj;
                            [assetArray insertObject:albumAsset atIndex:0];
                            [imageArray insertObject:albumAsset atIndex:0];
                        }
                    }
                }];
                
                allItem.collectionList = assetArray;
                //此时如果数组不大于0证明此项section里没有数据(可能在图片模式下和视频模式下没有数据)
                if (allItem.collectionList.count > 0) {
                    [weakSelf.assetDataSource addObject:allItem];
                }
                
                videoItem.collectionList = videoArray;
                //此时如果数组不大于0证明此项section里没有数据(可能在图片模式下和视频模式下没有数据)
                if (videoItem.collectionList.count > 0) {
                    [weakSelf.videoDataSource addObject:videoItem];
                }
                
                imageItem.collectionList = imageArray;
                //此时如果数组不大于0证明此项section里没有数据(可能在图片模式下和视频模式下没有数据)
                if (imageItem.collectionList.count > 0) {
                    [weakSelf.imageDataSource addObject:imageItem];
                }
            }
            complete(weakSelf.assetDataSource,weakSelf.videoDataSource,weakSelf.imageDataSource);
            CFAbsoluteTime end = CFAbsoluteTimeGetCurrent();
            NSLog(@"执行时间：t2-t1=%f",end-state);
            NSLog(@"结束了");
        }
    }];
}

@end
