//
//  ViewController.m
//  IIAsyncViewControllerDemo
//
//  Created by Tom Adriaenssen on 04/11/14.
//  Copyright (c) 2014 Tom Adriaenssen. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)performAsyncDataRequest
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSUInteger dice = arc4random() % 3;
        switch (dice) {
            case 0:
                // no data
                self.asyncView.data = nil;
                break;
                
            case 1: {
                // data
                NSAttributedString *data = [[NSAttributedString alloc] initWithString:@"test" attributes:nil];
                self.asyncView.data = data;
                break;
            }

            case 2:
                // error
                self.asyncView.error = [NSError errorWithDomain:@"ViewController" code:404 userInfo:@{ NSLocalizedDescriptionKey: @"404 - Not Found" }];
                break;
        }
    });
}

@end
