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
    [self invalidateState];
}

- (void)setValue:(id)value {
    _error = nil;
    _value = value;
    _valueWasSet = YES;
    
    [self invalidateState];
}

- (void)reset
{
    _valueWasSet = NO;
    _value = nil;
    _error = nil;
    
    [self invalidateState];
}

- (void)invalidateState
{
    [self.asyncDataDelegate asyncDataDidInvalidateState:self];
}

- (BOOL)isLoading
{
    return !self.error && !_valueWasSet;
}

@end
