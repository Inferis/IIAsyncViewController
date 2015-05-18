//
//  TestViewController.m
//  IIAsyncViewControllerDemo
//
//  Created by Tom Adriaenssen on 18/05/15.
//  Copyright (c) 2015 Tom Adriaenssen. All rights reserved.
//

#import "TestViewController.h"

@interface TestViewController ()

@end

@implementation TestViewController {
    UIView *_theAsyncView;
}

- (instancetype)init
{
    if (self = [super init]) {
        _theAsyncView = [TestView new];
    }
    return self;
}

- (instancetype)initWithDefaultView
{
    if (self = [self init]) {
        _theAsyncView = nil;
    }
    return self;
}

- (void)loadView
{
    if (_theAsyncView) {
        self.view = _theAsyncView;
    }
    else {
        [super loadView];
    }
}

@end

@implementation TestView

- (void)asyncDataApplyValueAnimated:(BOOL)animated
{
    
}

@end