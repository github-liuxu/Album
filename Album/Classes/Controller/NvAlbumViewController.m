//
//  NvAlbumViewController.m
//  SDKDemo
//
//  Created by Meicam on 2018/5/25.
//  Copyright © 2018年 刘东旭. All rights reserved.
//

#import "NvAlbumViewController.h"
#import "NvAllAssetCell.h"
#import "NvAlbumItem.h"
#import "NvAlbumCollectionView.h"
#import "NvSizeViewController.h"
#import "NvFetchAlbum.h"
#import "NvAlbumUtils.h"

@import Photos;

@interface NvAlbumViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIView *tabView;
@property (nonatomic, strong) UIButton *allButton;
@property (nonatomic, strong) UIButton *videoButton;
@property (nonatomic, strong) UIButton *imageButton;
@property (nonatomic, strong) UIView *bottomLine;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) NvAlbumCollectionView *albumCollectionView;
@property (nonatomic, strong) NvAlbumCollectionView *videoCollectionView;
@property (nonatomic, strong) NvAlbumCollectionView *imageCollectionView;

@property (nonatomic, assign) NSInteger selectAssetCount;
@property (nonatomic, assign) NSInteger selectVideoAssetCount;
@property (nonatomic, assign) NSInteger selectImageAssetCount;
@property (nonatomic, strong) UIImage *selectImage;
@property (nonatomic, strong) NvFetchAlbum *album;

@property (nonatomic, strong) NSMutableArray <NvAlbumAsset *>*selectAssetSource;//被选择的资源
@property (nonatomic, assign) NSInteger selectIndex;//被选择的资源index用于计算被选择的个数

@property (nonatomic, strong) NSString *nextText;

@end

@implementation NvAlbumViewController

- (void)dealloc {
    NSLog(@"%s",__func__);
    //[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init {
    if (self = [super init]) {
        self.selectAssetSource = [NSMutableArray array];
        self.mutableSelect = YES;
        
        self.maxSelectCount = 0;
        self.minSelectCount = 1;
        self.hiddenSelectAll = NO;
    }
    return self;
}

#pragma mark viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.translucent = NO;
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:0.001],
                                 NSForegroundColorAttributeName:[UIColor clearColor]};
    [item setTitleTextAttributes:attributes forState:UIControlStateNormal];
    [self.navigationController.navigationBar setBarTintColor:[UIColor blackColor]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:UIColor.whiteColor, NSFontAttributeName:[UIFont systemFontOfSize:19]}];
    
    self.view.backgroundColor = [UIColor blackColor];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, [NvAlbumUtils fontWithSize:19], NSFontAttributeName, nil]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[self leftNavigationBarItemView]];
    [self initSubViews];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(realodData) name:@"NvReloadAlbumData" object:nil];
}

// MARK: 设置标题
- (void)setTitleWithCount:(NSInteger)count {
    if (count == 0) {
        self.title = @"选择内容";
    } else {
        if (!self.mutableSelect) {
            self.title = @"已选择";
        } else {
            self.title = [NSString stringWithFormat:@"已选%ld项",(long)count];
        }
    }
}

- (UIView *)leftNavigationBarItemView {
    UIButton *backButton;
    backButton = [UIButton nv_buttonWithTitle:nil textColor:nil fontSize:15 image:[NvAlbumUtils imageWithName:@"icon_back"]];
    backButton.frame = CGRectMake(0, 0, 44, 44);
    __weak typeof(self)weakSelf = self;
    [backButton nv_BtnClickHandler:^{
        if ([weakSelf.delegate respondsToSelector:@selector(nvAlbumViewControllerCancelClick:)]) {
            [weakSelf.delegate nvAlbumViewControllerCancelClick:weakSelf];
        } else {
            if (self.navigationController.viewControllers.count == 1) {
                [weakSelf dismissViewControllerAnimated:YES completion:NULL];
            } else {
                if (weakSelf.navigationController.topViewController != weakSelf) {
                    [weakSelf dismissViewControllerAnimated:YES completion:NULL];
                } else {
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                }
            }
        }
    }];
    return backButton;
}

- (void)setSelectIndex:(NSInteger)selectIndex {
    _selectIndex = selectIndex;
    
    self.selectAssetCount = selectIndex;
    [self setTitleWithCount:selectIndex];
    
    if (_selectIndex > 0) {
        UIView *bottomViews = [self.view viewWithTag:10000];
        NvButton *button = [bottomViews viewWithTag:10001];
        //如果被选择的个数大于最小限制值，则允许点击按钮
        if (selectIndex >= self.minSelectCount) {
            button.userInteractionEnabled = YES;
            [button setTitleColor:[UIColor nv_colorWithHexRGB:@"#4A90E2"] forState:UIControlStateNormal];
        } else {//否则置灰按钮
            [button setTitleColor:[UIColor nv_colorWithHexRGB:@"#FFA3A3A3"] forState:UIControlStateNormal];
            button.userInteractionEnabled = NO;
        }
        if (bottomViews) {
            return;
        }
        //显示开始制作按钮
        UIView *bottomView = [UIView new];
        bottomView.tag = 10000;
        [self.view addSubview:bottomView];
        bottomView.backgroundColor = [UIColor blackColor];
        NvButton *makeButton = [NvButton nv_buttonWithTitle:@"开始制作" textColor:[UIColor nv_colorWithHexRGB:@"#4A90E2"] fontSize:19];
        makeButton.tag = 10001;
        //如果被选择的个数大于最小限制值，则允许点击按钮
        if (selectIndex >= self.minSelectCount) {
            makeButton.userInteractionEnabled = YES;
            [makeButton setTitleColor:[UIColor nv_colorWithHexRGB:@"#4A90E2"] forState:UIControlStateNormal];
        } else {//否则置灰按钮
            [makeButton setTitleColor:[UIColor nv_colorWithHexARGB:@"#FFA3A3A3"] forState:UIControlStateNormal];
            makeButton.userInteractionEnabled = NO;
        }
        
        if (self.nextText && ![self.nextText isEqualToString:@""]) {
            [makeButton setTitle:self.nextText forState:UIControlStateNormal];
        }
        
        [bottomView addSubview:makeButton];
        __weak typeof(self)weakSelf = self;
        [makeButton nv_BtnClickHandler:^{
            if ([weakSelf.delegate respondsToSelector:@selector(nvAlbumViewController:selectAlbumAssets:)]) {
                [weakSelf.delegate nvAlbumViewController:weakSelf selectAlbumAssets:weakSelf.selectAssetSource];
            }
        }];
        [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(@0);
            if (@available(iOS 11.0, *)) {
                make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
            } else {
                // Fallback on earlier versions
                make.bottom.equalTo(@0);
            }
            make.height.equalTo(@(49*SCREANSCALE));
        }];
        [makeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(@0);
            make.height.equalTo(@(49*SCREANSCALE));
        }];
        
        [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(@0);
            if (@available(iOS 11.0, *)) {
                make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-49*SCREANSCALE);
            } else {
                make.bottom.equalTo(@(-49*SCREANSCALE));
            }
            make.top.equalTo(self.tabView.mas_bottom);
        }];

        float collectionViewHeight = 0;
        if (self.isOnlyImage || self.isOnlyVideo) {
            collectionViewHeight = SCREEN_HEIGTH - NV_STATUSBARHEIGHT - 44- 49*SCREANSCALE;
        } else {
            collectionViewHeight = SCREEN_HEIGTH - NV_STATUSBARHEIGHT - 44 - 44*SCREANSCALE - 49*SCREANSCALE;
        }
        
        if (self.isOnlyImage) {
            [self.imageCollectionView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@(collectionViewHeight-INDICATOR));
            }];
        } else if (self.isOnlyVideo) {
            [self.videoCollectionView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@(collectionViewHeight-INDICATOR));
            }];
        } else {
            [self.albumCollectionView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@(collectionViewHeight-INDICATOR));
            }];
            [self.videoCollectionView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@(collectionViewHeight-INDICATOR));
            }];
            [self.imageCollectionView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@(collectionViewHeight-INDICATOR));
            }];
        }
        [bottomView layoutIfNeeded];
        [self.scrollView layoutIfNeeded];
    } else {
        //隐藏开始制作按钮
        UIView *bottomView = [self.view viewWithTag:10000];
        if (bottomView) {
            for (NvButton *button in [bottomView subviews]) {
                [button removeFromSuperview];
            }
            [bottomView removeFromSuperview];
            bottomView = nil;
        }
        [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(@0);
            make.bottom.equalTo(@0);
            make.top.equalTo(self.tabView.mas_bottom);
        }];
        
        float collectionViewHeight = 0;
        if (self.isOnlyImage || self.isOnlyVideo) {
            collectionViewHeight = SCREEN_HEIGTH - NV_STATUSBARHEIGHT - 44;
        } else {
            collectionViewHeight = SCREEN_HEIGTH - NV_STATUSBARHEIGHT - 44 - 44*SCREANSCALE;
        }
        
        if (self.isOnlyImage) {
            [self.imageCollectionView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@(collectionViewHeight));
            }];
        } else if (self.isOnlyVideo) {
            [self.videoCollectionView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@(collectionViewHeight));
            }];
        } else {
            [self.albumCollectionView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@(collectionViewHeight));
            }];
            [self.videoCollectionView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@(collectionViewHeight));
            }];
            [self.imageCollectionView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@(collectionViewHeight));
            }];
        }
        
        [self.scrollView layoutIfNeeded];
    }
}

- (void)customSelectAssetButtonText:(NSString *)text {
    self.nextText = text;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// MARK: 分类点击
- (void)allContentsClick {
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [self.allButton setTitleColor:[UIColor nv_colorWithHexRGB:@"#4A90E2"] forState:UIControlStateNormal];
    [self.videoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.imageButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.bottomLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.allButton.mas_left);
        make.width.equalTo(self.allButton);
        make.height.equalTo(@(3*SCREANSCALE));
        make.bottom.equalTo(@0);
    }];
    [self setTitleWithCount:self.selectAssetCount];
}

- (void)videoClick {
    [self.scrollView setContentOffset:CGPointMake(SCREEN_WDITH, 0) animated:YES];
    [self.allButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.videoButton setTitleColor:[UIColor nv_colorWithHexRGB:@"#4A90E2"] forState:UIControlStateNormal];
    [self.imageButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.bottomLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.allButton.mas_right);
        make.width.equalTo(self.allButton);
        make.height.equalTo(@(3*SCREANSCALE));
        make.bottom.equalTo(@0);
    }];
    [self setTitleWithCount:self.selectAssetCount];
}

- (void)imageClick {
    [self.scrollView setContentOffset:CGPointMake(2*SCREEN_WDITH, 0) animated:YES];
    [self.allButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.videoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.imageButton setTitleColor:[UIColor nv_colorWithHexRGB:@"#4A90E2"] forState:UIControlStateNormal];
    [self.bottomLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.videoButton.mas_right);
        make.width.equalTo(self.allButton);
        make.height.equalTo(@(3*SCREANSCALE));
        make.bottom.equalTo(@0);
    }];
    [self setTitleWithCount:self.selectAssetCount];
}

- (void)realodData {
    [self.albumCollectionView realoadData];
    [self.videoCollectionView realoadData];
    [self.imageCollectionView realoadData];
}

// MARK: 初始化试图
- (void)initSubViews {
    self.title = @"选择内容";
    __weak typeof(self)weakSelf = self;
    self.tabView = [[UIView alloc] init];
    self.tabView.backgroundColor = [UIColor nv_colorWithHexRGB:@"#363738"];
    [self.view addSubview:self.tabView];
    float tabViewHeight = 44*SCREANSCALE;
    if (self.isOnlyImage||self.isOnlyVideo) {
        tabViewHeight = 0;
    }
    [self.tabView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(0));
        make.left.right.equalTo(@0);
        make.height.equalTo(@(tabViewHeight));
    }];
    //如果是图片模式或者是视频模式不显示“所有内容”，“视频”，“图片”选项卡
    if (!self.isOnlyImage && !self.isOnlyVideo) {
        self.allButton = [UIButton nv_buttonWithTitle:@"所有内容" textColor:[UIColor nv_colorWithHexRGB:@"#4A90E2"] fontSize:15];
        [self.tabView addSubview:self.allButton];
        [self.allButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(0*SCREANSCALE));
            make.top.equalTo(@(0*SCREANSCALE));
            make.bottom.equalTo(@(0*SCREANSCALE));
            make.width.equalTo(@(SCREEN_WDITH/3.0));
        }];
        
        [self.allButton nv_BtnClickHandler:^{
            [weakSelf allContentsClick];
        }];
        
        self.videoButton = [UIButton nv_buttonWithTitle:@"视频" textColor:[UIColor whiteColor] fontSize:15];
        [self.tabView addSubview:self.videoButton];
        [self.videoButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.tabView);
            make.top.bottom.equalTo(self.allButton);
            make.width.equalTo(self.allButton);
        }];
        [self.videoButton nv_BtnClickHandler:^{
            [weakSelf videoClick];
        }];

        self.imageButton = [UIButton nv_buttonWithTitle:@"图片" textColor:[UIColor whiteColor] fontSize:15];
        [self.tabView addSubview:self.imageButton];
        [self.imageButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@(0*SCREANSCALE));
            make.top.bottom.equalTo(self.allButton);
            make.width.equalTo(self.allButton);
        }];
        [self.imageButton nv_BtnClickHandler:^{
            [weakSelf imageClick];
        }];

        self.bottomLine = [UIView new];
        self.bottomLine.backgroundColor = [UIColor nv_colorWithHexRGB:@"#4A90E2"];
        [self.tabView addSubview:self.bottomLine];
        [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.allButton.mas_left);
            make.width.equalTo(self.allButton);
            make.height.equalTo(@(3*SCREANSCALE));
            make.bottom.equalTo(@0);
        }];
    }
    
    self.scrollView = [[UIScrollView alloc] init];
    [self.view addSubview:self.scrollView];
    self.scrollView.delegate = self;
    self.scrollView.bounces = NO;
    self.scrollView.pagingEnabled = YES;
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.top.equalTo(self.tabView.mas_bottom);
        make.bottom.equalTo(@0);
    }];
    float collectionViewHeight = 0;
    if (self.isOnlyImage || self.isOnlyVideo) {
        collectionViewHeight = SCREEN_HEIGTH - NV_STATUSBARHEIGHT - 44;
    } else {
        collectionViewHeight = SCREEN_HEIGTH - NV_STATUSBARHEIGHT - 44 - 44*SCREANSCALE;
    }
    NvAlbumAssetType type;
    if (self.isOnlyImage) {
        type = NvAlbumAssetAllImage;
    } else if (self.isOnlyVideo) {
        type = NvAlbumAssetAllVideo;
    } else {
        type = NvAlbumAssetAll;
    }
    //图片
    if (self.isOnlyImage) {
        self.imageCollectionView = [[NvAlbumCollectionView alloc] initWithFrame:CGRectZero withMediaType:NvAlbumAssetAllImage];
        self.imageCollectionView.mutableSelect = self.mutableSelect;
        self.imageCollectionView.hiddenSelectAll = self.hiddenSelectAll;
        [self.scrollView addSubview:self.imageCollectionView];
        self.imageCollectionView.delegate = self;
        [self.imageCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.bottom.equalTo(@0);
            make.left.equalTo(@0);
            make.width.equalTo(@(SCREEN_WDITH));
            make.height.equalTo(@(collectionViewHeight)).priorityLow();
        }];
        self.album = [NvFetchAlbum new];
        [self.album loadAssetcomplete:^(NSMutableArray<NvAlbumItem *> *dataSource, NSMutableArray<NvAlbumItem *> *videoDataSource, NSMutableArray<NvAlbumItem *> *imageDataSource) {
            weakSelf.imageCollectionView.assetDataSource = imageDataSource;
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.imageCollectionView realoadData];
            });
        }];
    } else if (self.isOnlyVideo) {//视频
        self.videoCollectionView = [[NvAlbumCollectionView alloc] initWithFrame:CGRectZero withMediaType:NvAlbumAssetAllVideo];
        self.videoCollectionView.mutableSelect = self.mutableSelect;
        self.videoCollectionView.hiddenSelectAll = self.hiddenSelectAll;
        [self.scrollView addSubview:self.videoCollectionView];
        self.videoCollectionView.delegate = self;
        [self.videoCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.bottom.equalTo(@0);
            make.left.equalTo(@0);
            make.width.equalTo(@(SCREEN_WDITH));
            make.height.equalTo(@(collectionViewHeight)).priorityLow();
        }];
        self.album = [NvFetchAlbum new];
        [self.album loadAssetcomplete:^(NSMutableArray<NvAlbumItem *> *dataSource, NSMutableArray<NvAlbumItem *> *videoDataSource, NSMutableArray<NvAlbumItem *> *imageDataSource) {
            weakSelf.videoCollectionView.assetDataSource = videoDataSource;
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.videoCollectionView realoadData];
            });
        }];
    } else {//所有
        self.albumCollectionView = [[NvAlbumCollectionView alloc] initWithFrame:CGRectZero withMediaType:type];
        self.albumCollectionView.mutableSelect = self.mutableSelect;
        self.albumCollectionView.hiddenSelectAll = self.hiddenSelectAll;
        [self.scrollView addSubview:self.albumCollectionView];
        self.albumCollectionView.delegate = self;
        [self.albumCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.equalTo(@0);
            make.width.equalTo(@(SCREEN_WDITH));
            make.height.equalTo(@(collectionViewHeight)).priorityLow();
        }];
        
        self.videoCollectionView = [[NvAlbumCollectionView alloc] initWithFrame:CGRectZero withMediaType:NvAlbumAssetAllVideo];
        self.videoCollectionView.mutableSelect = self.mutableSelect;
        self.videoCollectionView.hiddenSelectAll = self.hiddenSelectAll;
        [self.scrollView addSubview:self.videoCollectionView];
        self.videoCollectionView.delegate = self;
        [self.videoCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(@0);
            make.width.equalTo(@(SCREEN_WDITH));
            make.height.equalTo(@(collectionViewHeight)).priorityLow();
            make.left.equalTo(self.albumCollectionView.mas_right);
        }];
        
        self.imageCollectionView = [[NvAlbumCollectionView alloc] initWithFrame:CGRectZero withMediaType:NvAlbumAssetAllImage];
        self.imageCollectionView.mutableSelect = self.mutableSelect;
        self.imageCollectionView.hiddenSelectAll = self.hiddenSelectAll;
        [self.scrollView addSubview:self.imageCollectionView];
        self.imageCollectionView.delegate = self;
        [self.imageCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.bottom.equalTo(@0);
            make.left.equalTo(self.videoCollectionView.mas_right);
            make.width.equalTo(@(SCREEN_WDITH));
            make.height.equalTo(@(collectionViewHeight)).priorityLow();
        }];
        
        self.album = [NvFetchAlbum new];
        [self.album loadAssetcomplete:^(NSMutableArray<NvAlbumItem *> *dataSource, NSMutableArray<NvAlbumItem *> *videoDataSource, NSMutableArray<NvAlbumItem *> *imageDataSource) {
            weakSelf.albumCollectionView.assetDataSource = dataSource;
            weakSelf.videoCollectionView.assetDataSource = videoDataSource;
            weakSelf.imageCollectionView.assetDataSource = imageDataSource;
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.albumCollectionView realoadData];
                [weakSelf.videoCollectionView realoadData];
                [weakSelf.imageCollectionView realoadData];
            });
        }];
    }
}

- (void)addAsset:(NvAlbumAsset *)selectAsset removeContains:(BOOL)isRemoveContains {
    if ([self.selectAssetSource containsObject:selectAsset]) {
        if (isRemoveContains) {
            [self.selectAssetSource removeObject:selectAsset];
        }
    } else {
        [self.selectAssetSource addObject:selectAsset];
    }
    [self ascendingWithSelectAsset];
    self.selectIndex = self.selectAssetSource.count;
}

- (void)removeAsset:(NvAlbumAsset *)selectAsset {
    if ([self.selectAssetSource containsObject:selectAsset]) {
        [self.selectAssetSource removeObject:selectAsset];
    }
    
    [self ascendingWithSelectAsset];
    self.selectIndex = self.selectAssetSource.count;
}

// 重新排序被选择的asset
- (void)ascendingWithSelectAsset {
    for (int i = 0; i<self.selectAssetSource.count; i++) {
        NvAlbumAsset *asset = self.selectAssetSource[i];
        if (asset.isShowLayer) {
            asset.number = i+1;
        }
    }
}

//判断是否全选
- (void)reserIsSelectAll {
    for (int i = 0; i < self.albumCollectionView.assetDataSource.count; i++) {
        NvAlbumItem *item = self.albumCollectionView.assetDataSource[i];
        NSMutableArray<NvAlbumAsset *> *assets = item.collectionList;
        BOOL isContains = NO;
        for (int j = 0; j < assets.count; j++) {
            NvAlbumAsset *asset = assets[j];
            isContains = [self.selectAssetSource containsObject:asset];
            if (isContains) {
                continue;
            } else {
                break;
            }
        }
        item.isSelectAll = isContains;
    }
    for (int i = 0; i < self.videoCollectionView.assetDataSource.count; i++) {
        NvAlbumItem *item = self.videoCollectionView.assetDataSource[i];
        NSMutableArray<NvAlbumAsset *> *assets = item.collectionList;
        BOOL isContains = NO;
        for (int j = 0; j < assets.count; j++) {
            NvAlbumAsset *asset = assets[j];
            isContains = [self.selectAssetSource containsObject:asset];
            if (isContains) {
                continue;
            } else {
                break;
            }
        }
        item.isSelectAll = isContains;
    }
    for (int i = 0; i < self.imageCollectionView.assetDataSource.count; i++) {
        NvAlbumItem *item = self.imageCollectionView.assetDataSource[i];
        NSMutableArray<NvAlbumAsset *> *assets = item.collectionList;
        BOOL isContains = NO;
        for (int j = 0; j < assets.count; j++) {
            NvAlbumAsset *asset = assets[j];
            isContains = [self.selectAssetSource containsObject:asset];
            if (isContains) {
                continue;
            } else {
                break;
            }
        }
        item.isSelectAll = isContains;
    }
}

// MARK: UIScrollViewDelegate
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    if ((*targetContentOffset).x/SCREEN_WDITH == 0) {
        [self allContentsClick];
    } else if ((*targetContentOffset).x/SCREEN_WDITH == 1) {
        [self videoClick];
    } else {
        [self imageClick];
    }
}

// MARK: NvAlbumCollectionViewDelegate
//cell单独被选中
- (void)nvAlbumCollectionView:(NvAlbumCollectionView *)nvAlbumCollectionView selectAsset:(NvAlbumAsset *)selectAsset {
    //如果不允许多选
    if (!self.mutableSelect) {
        if (![self.selectAssetSource containsObject:selectAsset]) {
            if (self.selectAssetSource.count != 0) {
                for (int i = 0; i < self.selectAssetSource.count; i++) {
                    NvAlbumAsset *asset = self.selectAssetSource[i];
                    asset.isShowLayer = NO;
                }
                [self.selectAssetSource removeAllObjects];
            }
            [self.selectAssetSource addObject:selectAsset];
        } else {
            [self.selectAssetSource removeObject:selectAsset];
        }

        self.selectIndex = self.selectAssetSource.count;

        [self realodData];
    } else {//如果允许多选
        //如果所选的内容不包含在已选择的里面，并且已选择的个数大于最大限制个数给出回调
        if (![self.selectAssetSource containsObject:selectAsset] && self.selectAssetSource.count >= self.maxSelectCount && self.maxSelectCount!=0) {
            selectAsset.isShowLayer = NO;
            [self realodData];
            if ([self.delegate respondsToSelector:@selector(nvAlbumViewController:selectAlbumAssetsOverMaxCountLimit:)]) {
                [self.delegate nvAlbumViewController:self selectAlbumAssetsOverMaxCountLimit:self.selectAssetSource];
            }
        } else {
            [self addAsset:selectAsset removeContains:YES];
            [self reserIsSelectAll];
            [self realodData];
        }
    }
}

//点击全选
- (void)nvAlbumCollectionView:(NvAlbumCollectionView *)nvAlbumCollectionView selectAssets:(NSMutableArray <NvAlbumAsset *>*)selectAssets {
    for (NvAlbumAsset *asset in selectAssets) {
        [self addAsset:asset removeContains:NO];
    }
    
    [self reserIsSelectAll];
    [self realodData];
}

//点击反全选
- (void)nvAlbumCollectionView:(NvAlbumCollectionView *)nvAlbumCollectionView deselectAssets:(NSMutableArray <NvAlbumAsset *>*)selectAssets {
    for (NvAlbumAsset *asset in selectAssets) {
        [self removeAsset:asset];
    }
    
    [self reserIsSelectAll];
    [self realodData];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
