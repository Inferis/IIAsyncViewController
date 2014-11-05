//
//  IIAsyncStatusView.m
//  Copyright (c) 2014 Tom Adriaenssen. All rights reserved.
//

#import "IIAsyncStatusView.h"

typedef NS_ENUM(NSUInteger, IIAsyncStatusViewState) {
    IIAsyncStatusLoading = 0,
    IIAsyncStatusError = 1,
    IIAsyncStatusNoData = 2,
    IIAsyncStatusData = 255
};

@interface IIAsyncStatusView () <IIAsyncViewDelegate>


@end

@implementation IIAsyncStatusView

@synthesize asyncView = _asyncView;

#pragma mark - Overrides

- (void)layoutSubviews
{
    [super layoutSubviews];
    _asyncView.frame = self.bounds;
}

#pragma mark - Property accessors

- (void)setAsyncView:(UIView<IIAsyncView> *)asyncView
{
    if ([asyncView isEqual:_asyncView]) return;
    
    _asyncView.asyncStateDelegate = nil;
    _asyncView = asyncView;
    _asyncView.asyncStateDelegate = self;
}

#pragma mark - Async View delegate

- (void)asyncViewDidInvalidateState:(IIAsyncView *)view
{
    [self updateState];
}

#pragma mark - State management

- (void)updateState
{
    IIAsyncStatusViewState newState;
    
    // safeguard: make sure the asyncView has self as superview
    if (_asyncView && _asyncView.superview != self) {
        [self setAsyncView:nil];
    }
    
    // determine the new state
    if (!_asyncView || ([_asyncView respondsToSelector:@selector(isLoading)] && [_asyncView isLoading])) {
        newState = IIAsyncStatusLoading;
    }
    else if ([_asyncView respondsToSelector:@selector(error)] && _asyncView.error) {
        newState = IIAsyncStatusError;
    }
    else if (![_asyncView respondsToSelector:@selector(data)] || _asyncView.data) {
        newState = IIAsyncStatusData;
    }
    else {
        newState = IIAsyncStatusNoData;
    }
}

@end
