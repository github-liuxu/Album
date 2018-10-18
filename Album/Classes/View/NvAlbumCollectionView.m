//
//  NvAlbumCollectionView.m
//  SDKDemo
//
//  Created by Meicam on 2018/5/29.
//  Copyright © 2018年 meishe. All rights reserved.
//

#import "NvAlbumCollectionView.h"
#import "NvAllAssetCell.h"
#import "NvAlbumItem.h"
#import "NvAlbumUtils.h"
#import "NvAlbumViewController.h"
@import Photos;

@interface NvAlbumCollectionView ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *allAssetColloection;

@property (nonatomic, strong) NSMutableArray <NvAlbumAsset *>*selectAssetSource;//被选择的资源

@property (nonatomic, strong) NvFetchAlbum *fetchAlbum;
@property (nonatomic, assign) NvAlbumAssetType type;

@end

static NSString *kAllPHAssetIdentify = @"kAllPHAssetIdentify";
static NSString *kHeaderPHAssetIdentify = @"kHeaderPHAssetIdentify";

@implementation NvAlbumCollectionView

- (void)dealloc {
    NSLog(@"%s",__func__);
}

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame withMediaType:NvAlbumAssetAll];
}

- (instancetype)initWithFrame:(CGRect)frame withMediaType:(NvAlbumAssetType)type {
    if (self = [super initWithFrame:frame]) {
        self.mutableSelect = YES;
        self.type = type;
        [self initData];
        [self initSubViews];
//        [self loadAsset];
    }
    return self;
}

// MARK: 初始化数据
- (void)initData {
    self.assetDataSource = [NSMutableArray new];
    self.selectAssetSource = [NSMutableArray new];
}

- (void)realoadData {
    [self.allAssetColloection reloadData];
}

// MARK: 全选
- (void)selectAllClick:(UIButton *)button withIndexPath:(NSIndexPath *)indexPath {
    NvAlbumItem *item = self.assetDataSource[indexPath.section];
    for (int i = 0; i < item.collectionList.count; i++) {
        NvAlbumAsset *asset = item.collectionList[i];
        asset.isShowLayer = YES;
    }
    
    if ([self.delegate respondsToSelector:@selector(nvAlbumCollectionView:selectAssets:)]) {
        [self.delegate nvAlbumCollectionView:self selectAssets:item.collectionList];
    }
}

// MARK: 反全选
- (void)deselectAllClick:(UIButton *)button withIndexPath:(NSIndexPath *)indexPath {
    NvAlbumItem *item = self.assetDataSource[indexPath.section];
    for (int i = 0; i < item.collectionList.count; i++) {
        NvAlbumAsset *asset = item.collectionList[i];
        asset.isShowLayer = NO;
    }
    
    if ([self.delegate respondsToSelector:@selector(nvAlbumCollectionView:deselectAssets:)]) {
        [self.delegate nvAlbumCollectionView:self deselectAssets:item.collectionList];
    }
}

// MARK: UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if (collectionView == self.allAssetColloection) {
        return self.assetDataSource.count;
    }
    return 0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView == self.allAssetColloection) {
        NvAlbumItem *item = self.assetDataSource[section];
        return item.collectionList.count;
    }
    return 0;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.allAssetColloection) {
        NvAllAssetCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kAllPHAssetIdentify forIndexPath:indexPath];
        cell.mutableSelect = self.mutableSelect;
        NvAlbumItem *item = self.assetDataSource[indexPath.section];
        NvAlbumAsset *albumAsset = item.collectionList[indexPath.item];
        albumAsset.indexPath = indexPath;
        [cell renderCellWithItem:albumAsset];
        return cell;
    }
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NvAlbumItem *item = self.assetDataSource[indexPath.section];
    NvAlbumAsset *albumAsset = item.collectionList[indexPath.item];
    if (albumAsset.isShowLayer) {
        albumAsset.isShowLayer = NO;
    } else {
        albumAsset.isShowLayer = YES;
    }
    [self.delegate nvAlbumCollectionView:self selectAsset:albumAsset];

}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kHeaderPHAssetIdentify forIndexPath:indexPath];
    __weak typeof(self)weakSelf = self;
    if (![header viewWithTag:1000]) {
        header.backgroundColor = [UIColor nv_colorWithHexRGB:@"#242728"];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10*SCREANSCALE, 0, 100, header.frame.size.height)];
        NvAlbumItem *item = self.assetDataSource[indexPath.section];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd";
        NSString *dateText = [formatter stringFromDate:item.startDate];
        NSDate *datenow = [NSDate date];
        NSString *currentTimeString = [formatter stringFromDate:datenow];
        if ([currentTimeString isEqualToString:dateText]) {
            label.text = @"今天";
        } else {
            label.text = dateText;
        }
        label.font = [UIFont systemFontOfSize:13];
        label.textColor = [UIColor whiteColor];
        label.tag = 1000;
        [header addSubview:label];
        NvButton *button = [NvButton nv_buttonWithTitle:@"全选" textColor:[UIColor nv_colorWithHexString:@"#4A90E2"] fontSize:13];
        button.tag = 1001;
        if (item.isSelectAll) {
            [button setTitle:@"反全选" forState:UIControlStateNormal];
        } else {
            [button setTitle:@"全选" forState:UIControlStateNormal];
        }
        __weak typeof(button)weakButton = button;
        __weak typeof(item)weakItem = item;
        [button nv_BtnClickHandler:^{
            if (weakItem.isSelectAll) {
                [weakButton setTitle:@"全选" forState:UIControlStateNormal];
                [weakSelf deselectAllClick:weakButton withIndexPath:indexPath];
            } else {
                [weakButton setTitle:@"反全选" forState:UIControlStateNormal];
                [weakSelf selectAllClick:weakButton withIndexPath:indexPath];
            }
//            weakItem.isSelectAll = !weakItem.isSelectAll;
        }];
        [header addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(header.mas_right).offset(-13*SCREANSCALE);
            make.top.bottom.equalTo(@0);
        }];
        if (!self.mutableSelect || self.hiddenSelectAll) {//如果是单选，或者hiddenSelectAll为true则隐藏按钮
            button.hidden = YES;
        } else {
            button.hidden = NO;
        }
    } else {
        UILabel *label = [header viewWithTag:1000];
        NvButton *button = [header viewWithTag:1001];
        NvAlbumItem *item = self.assetDataSource[indexPath.section];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd";
        NSString *dateText = [formatter stringFromDate:item.startDate];
        
        NSDate *datenow = [NSDate date];
        NSString *currentTimeString = [formatter stringFromDate:datenow];
        if ([currentTimeString isEqualToString:dateText]) {
            label.text = @"今天";
        } else {
            label.text = dateText;
        }
        
        if (item.isSelectAll) {
            [button setTitle:@"反全选" forState:UIControlStateNormal];
        } else {
            [button setTitle:@"全选" forState:UIControlStateNormal];
        }
        __weak typeof(button)weakButton = button;
        __weak typeof(item)weakItem = item;
        [button nv_BtnClickHandler:^{
            if (weakItem.isSelectAll) {
                [weakButton setTitle:@"全选" forState:UIControlStateNormal];
                [weakSelf deselectAllClick:weakButton withIndexPath:indexPath];
            } else {
                [weakButton setTitle:@"反全选" forState:UIControlStateNormal];
                [weakSelf selectAllClick:weakButton withIndexPath:indexPath];
            }
//            weakItem.isSelectAll = !weakItem.isSelectAll;
        }];
        if (!self.mutableSelect || self.hiddenSelectAll) { //如果是单选，或者hiddenSelectAll为true则隐藏按钮
            button.hidden = YES;
        } else {
            button.hidden = NO;
        }
    }
    
    return header;
}

- (void)initSubViews {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.minimumLineSpacing = 4*SCREANSCALE;
    flowLayout.minimumInteritemSpacing = 4*SCREANSCALE;
    flowLayout.itemSize = CGSizeMake(85*SCREANSCALE, 85*SCREANSCALE);
    flowLayout.headerReferenceSize = CGSizeMake(SCREEN_WDITH, 39*SCREANSCALE);
    self.allAssetColloection = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    self.allAssetColloection.delegate = self;
    self.allAssetColloection.dataSource = self;
    self.allAssetColloection.backgroundColor = [UIColor nv_colorWithHexRGB:@"#242728"];
    [self.allAssetColloection registerClass:[NvAllAssetCell class] forCellWithReuseIdentifier:kAllPHAssetIdentify];
    
    [self.allAssetColloection registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kHeaderPHAssetIdentify];
    
    [self addSubview:self.allAssetColloection];
    [self.allAssetColloection mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
