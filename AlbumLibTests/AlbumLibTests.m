//
//  AlbumLibTests.m
//  AlbumLibTests
//
//  Created by 刘东旭 on 2018/10/18.
//  Copyright © 2018年 刘东旭. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NvAlbumViewController.h"

@interface AlbumLibTests : XCTestCase

@end

@implementation AlbumLibTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    NvAlbumViewController *album = [[NvAlbumViewController alloc] init];
    album.delegate = self;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:album];
    [self presentViewController:nav animated:YES completion:NULL];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
