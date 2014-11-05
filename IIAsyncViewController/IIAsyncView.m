//
//  IIAsyncView.m
//  Copyright (c) 2014 Tom Adriaenssen. All rights reserved.
//

#import "IIAsyncView.h"
#import "IIAsyncViewInternals.h"

@interface IIAsyncView ()

@property (nonatomic, assign, getter = isLoading) BOOL loading;

@end

@implementation IIAsyncView {
    BOOL _dataWasSet;
}

@synthesize error = _error;
@synthesize data = _data;
@synthesize asyncStateDelegate = _asyncStateDelegate;

- (void)setError:(NSError *)error {
    _error = error;
    [self invalidateState];
}

- (void)setData:(id)data {
    _error = nil;
    _data = data;
    _dataWasSet = YES;

    [self invalidateState];
}

- (void)reset
{
    _dataWasSet = NO;
    _data = nil;
    _error = nil;
    
    [self invalidateState];
}

- (void)invalidateState
{
    [self.asyncStateDelegate asyncViewDidInvalidateState:self];
}

- (BOOL)isLoading
{
    return !self.error && !_dataWasSet;
}



@end
