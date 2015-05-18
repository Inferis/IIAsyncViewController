//
//  ViewController.m
//  IIAsyncViewControllerDemo
//
//  Created by Tom Adriaenssen on 04/11/14.
//  Copyright (c) 2014 Tom Adriaenssen. All rights reserved.
//

#import "ViewController.h"
#import "LaggyBackend.h"

@interface ViewController ()

@property (nonatomic, strong) LaggyBackend *backend;

@end

@implementation ViewController

- (void)viewDidLoad
{
    self.backend = [LaggyBackend new];
    [super viewDidLoad];
}

- (void)performAsyncDataRequest
{
    [self.backend thatReallySlowCall:^(id result) {
        self.asyncView.asyncData.value = result;
    } error:^(NSError* error) {
        self.asyncView.asyncData.error = error;
    }];
}



@end
