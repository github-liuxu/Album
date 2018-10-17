//
//  ViewController.m
//  Album
//
//  Created by 刘东旭 on 2018/10/17.
//  Copyright © 2018年 刘东旭. All rights reserved.
//

#import "ViewController.h"
#import "NvAlbumViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    NvAlbumViewController *album = [[NvAlbumViewController alloc] init];
    album.delegate = self;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:album];
    [self presentViewController:nav animated:YES completion:NULL];
}

- (void)nvAlbumViewControllerCancelClick:(NvAlbumViewController *)albumViewController {
    [albumViewController dismissViewControllerAnimated:YES completion:NULL];
}


@end
