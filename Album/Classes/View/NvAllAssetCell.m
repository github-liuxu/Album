//
//  NvAllAssetCell.m
//  SDKDemo
//
//  Created by Meicam on 2018/5/25.
//  Copyright © 2018年 meishe. All rights reserved.
//

#import "NvAllAssetCell.h"
#import "NvAlbumUtils.h"
@import Photos;

@interface NvAllAssetCell ()

@property (nonatomic, strong) UIView *layerView;
@property (nonatomic, strong) UILabel *numLabel;
@property (nonatomic, strong) UIImageView *bottomBackView;
@property (nonatomic, strong) UILabel *durationLabel;


@property (nonatomic, strong) NSDictionary *attribtDic;

@end

@implementation NvAllAssetCell

- (void)dealloc {
    NSLog(@"%s",__func__);
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.mutableSelect = YES;
        self.contentView.backgroundColor = [UIColor nv_colorWithHexRGB:@"#242728"];
        self.imageView = [UIImageView new];
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.imageView.layer.masksToBounds = YES;
        [self.contentView addSubview:self.imageView];
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(@0);
        }];
        
        self.layerView = [UIView new];
        self.layerView.backgroundColor = [UIColor nv_colorWithHexRGB:@"#4A90E2"];
        self.layerView.alpha = 0.6;
        [self.contentView addSubview:self.layerView];
        [self.layerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(@0);
        }];
        self.layerView.hidden = YES;
        
        self.numLabel = [UILabel new];
        self.numLabel.textColor = [UIColor whiteColor];
        self.numLabel.textAlignment = NSTextAlignmentCenter;
        self.numLabel.font = [NvAlbumUtils fontWithSize:32*SCREANSCALE];
        [self.layerView addSubview:self.numLabel];
        [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(self.contentView);
            make.height.equalTo(@(45*SCREANSCALE));
            make.center.equalTo(self.layerView);
        }];
        
        _durationLabel = UILabel.new;
        NSShadow *shadow = [NSShadow new];
        shadow.shadowBlurRadius = 4;
        shadow.shadowColor = [UIColor blackColor];
        shadow.shadowOffset =CGSizeMake(0,2);
        self.attribtDic = @{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle],
                                     NSShadowAttributeName: shadow
                                     };
        NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:@"00:00" attributes:self.attribtDic];
        _durationLabel.attributedText = attribtStr;
        _durationLabel.font = [NvAlbumUtils fontWithSize:10];
        _durationLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:_durationLabel];
        [_durationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.imageView.mas_right).offset(-5);
            make.bottom.equalTo(self.imageView.mas_bottom).offset(-5);
        }];
        
        self.bottomBackView = [UIImageView new];
        self.bottomBackView.image = [NvAlbumUtils imageWithName:@"videocam - material"];
        [self.contentView addSubview:self.bottomBackView];
        [self.bottomBackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.durationLabel.mas_left).offset(-3*SCREANSCALE);
            make.centerY.equalTo(self.durationLabel.mas_centerY);
            make.height.equalTo(@(12*SCREANSCALE));
            make.width.equalTo(@(18*SCREANSCALE));
        }];

    }
    return self;
}

- (void)showLayer:(BOOL)isShow withNum:(NSInteger)num {
    self.layerView.hidden = !isShow;
    if (!self.mutableSelect) {
        self.numLabel.text = @"";
    } else {
        self.numLabel.text = [NSString stringWithFormat:@"%ld",num];
    }
}

- (void)renderCellWithItem:(NvAlbumAsset *)item {
    [self showLayer:item.isShowLayer withNum:item.number];
    if (!item.coverImage) {
        __weak typeof(self)weakSelf = self;
        [[PHImageManager defaultManager] requestImageForAsset:item.asset targetSize:CGSizeMake(SCREEN_WDITH/4, SCREEN_WDITH/4) contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            __strong typeof(weakSelf)self = weakSelf;
            self.imageView.image = result;
            item.coverImage = result;
        }];
    } else {
        self.imageView.image = item.coverImage;
    }
    if (item.asset.mediaType == PHAssetMediaTypeImage) {
        _durationLabel.hidden = YES;
        self.bottomBackView.hidden = YES;
    } else {
        _durationLabel.hidden = NO;
        self.bottomBackView.hidden = NO;
        NSInteger minutes = (NSInteger)(item.asset.duration / 60.0);
        NSInteger seconds = (NSInteger)round(item.asset.duration - 60.0 * (double)minutes);
        NSString *text = [NSString stringWithFormat:@"%02ld:%02ld", (long)minutes, (long)seconds];
        NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:text attributes:self.attribtDic];
        _durationLabel.attributedText = attribtStr;
    }
}

@end
