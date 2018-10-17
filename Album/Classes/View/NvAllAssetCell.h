//
//  NvAllAssetCell.h
//  SDKDemo
//
//  Created by Meicam on 2018/5/25.
//  Copyright © 2018年 meishe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NvAlbumItem.h"

@interface NvAllAssetCell : UICollectionViewCell

@property (nonatomic, assign) BOOL mutableSelect; //是否多选，默认YES,单选不会有数字标记

@property (nonatomic, strong) UIImageView *imageView;

- (void)showLayer:(BOOL)isShow withNum:(NSInteger)num;

- (void)renderCellWithItem:(NvAlbumAsset *)item;

@end
