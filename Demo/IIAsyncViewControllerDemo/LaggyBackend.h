//
//  LaggyBackend.h
//  IIAsyncViewControllerDemo
//
//  Created by Tom Adriaenssen on 18/05/15.
//  Copyright (c) 2015 Tom Adriaenssen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LaggyBackend : NSObject

- (void)thatReallySlowCall:(void(^)(id result))completion error:(void(^)(NSError *))error;

@end
