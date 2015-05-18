//
//  IIAsyncState.m
//  IIAsyncViewControllerDemo
//
//  Created by Tom Adriaenssen on 17/05/15.
//  Copyright (c) 2015 Tom Adriaenssen. All rights reserved.
//

#import "IIAsyncData.h"

@interface IIAsyncData ()

@property (nonatomic, assign, getter = isLoading) BOOL loading;

@end

@implementation IIAsyncData {
    BOOL _valueWasSet;
}

@synthesize error = _error;
@synthesize value = _value;
@synthesize asyncDataDelegate = _asyncDataDelegate;

- (void)setError:(NSError *)error {
    _error = error;
    [self invalidateStateForced:NO];
}

- (void)setValue:(id)value {
    _error = nil;
    BOOL forced = _valueWasSet && _value == value;
    _value = value;
    _valueWasSet = YES;
    
    [self invalidateStateForced:forced];
}

- (void)reset
{
    _valueWasSet = NO;
    _value = nil;
    _error = nil;
    
    [self invalidateStateForced:NO];
}

- (void)invalidateState
{
    [self invalidateStateForced:YES];
}

- (void)invalidateStateForced:(BOOL)forced
{
    [self.asyncDataDelegate asyncData:self didInvalidateStateForced:forced];
}

- (BOOL)isLoading
{
    return !self.error && !_valueWasSet;
}

@end
