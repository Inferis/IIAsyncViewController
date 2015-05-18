//
//  LaggyBackend.m
//  IIAsyncViewControllerDemo
//
//  Created by Tom Adriaenssen on 18/05/15.
//  Copyright (c) 2015 Tom Adriaenssen. All rights reserved.
//

#import "LaggyBackend.h"

@implementation LaggyBackend

- (void)thatReallySlowCall:(void (^)(id))completion error:(void (^)(NSError *))error
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSUInteger dice = arc4random() % 3;
        switch (dice) {
            case 0:
                // no data
                completion(nil);
                break;
                
            case 1: {
                // data
                completion([NSString stringWithFormat:@"Today %@!", [NSDate date]]);
                break;
            }
                
            case 2:
                // error
                error([NSError errorWithDomain:@"LaggyBackend" code:404 userInfo:@{ NSLocalizedDescriptionKey: @"500 - Complete failure" }]);
                break;
        }
    });
}

@end
