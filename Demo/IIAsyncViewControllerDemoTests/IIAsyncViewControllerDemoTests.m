//
//  IIAsyncViewControllerDemoTests.m
//  IIAsyncViewControllerDemoTests
//
//  Created by Tom Adriaenssen on 04/11/14.
//  Copyright (c) 2014 Tom Adriaenssen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "IIAsyncViewController.h"

@interface IIAsyncViewControllerDemoTests : XCTestCase

@end

@implementation IIAsyncViewControllerDemoTests{
    IIAsyncViewController *_controller;
}

- (void)setUp {
    [super setUp];
    
    _controller = [IIAsyncViewController new];
}

- (void)testAccessingViewWillWrapStandardView {
    // This is an example of a functional test case.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
