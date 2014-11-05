//
//  IIAsyncStatusView.m
//  Copyright (c) 2014 Tom Adriaenssen. All rights reserved.
//

#import "IIAsyncStatusView.h"
#import "IIAsyncViewInternals.h"

@interface IIAsyncStatusView ()


@end

@implementation IIAsyncStatusView {
    UIActivityIndicatorView *_spinner;
    UILabel *_messageView;
    UILabel *_errorView;
}

@synthesize asyncView = _asyncView;

#pragma mark - initialisation

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    [self initSpinner];
    [self initNoDataView];
    [self initErrorView];
}

#pragma mark - Properties

- (void)setAsyncView:(UIView<IIAsyncView> *)asyncView
{
    if (_asyncView == asyncView) return;
    
    [_asyncView removeFromSuperview];
    _asyncView = asyncView;
    [self addSubview:_asyncView];
    self.backgroundColor = asyncView.backgroundColor;
    [self setNeedsLayout];
}

- (UIActivityIndicatorView *)loadingIndicatorView
{
    return _spinner;
}

- (UIView *)noDataMessageView
{
    return _messageView;
}

- (UIView *)errorView
{
    return _errorView;
}

#pragma mark - Overrides

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self layoutSpinner];
    [self layoutAsyncView];
    [self layoutNoDataView];
    [self layoutErrorView];
}

#pragma mark - State transitioning

- (void)transitionToLoadingStateAnimated:(BOOL)animated
{
    [self animate:animated transition:^{
        [self startSpinner];
        [self hideAsyncView];
        [self hideNoDataView];
        [self hideErrorView];
    }];
}

- (void)transitionToErrorState:(NSError *)error animated:(BOOL)animated
{
    [self animate:animated transition:^{
        [self stopSpinner];
        [self hideAsyncView];
        [self hideNoDataView];
        [self showErrorView:error];
    }];
}

- (void)transitionToNoDataStateAnimated:(BOOL)animated
{
    [self animate:animated transition:^{
        [self stopSpinner];
        [self hideAsyncView];
        [self hideErrorView];
        [self showNoDataView];
    }];
}

- (void)transitionToDataStateAnimated:(BOOL)animated
{
    [self animate:animated transition:^{
        [self stopSpinner];
        [self showAsyncView];
        [_asyncView applyDataAnimated:animated];
        [self hideErrorView];
        [self hideNoDataView];
    }];
}

- (void)animate:(BOOL)animated transition:(void(^)(void))animations
{
    dispatch_sync_main(^{
        if (animated) {
            [UIView animateWithDuration:0.25 animations:^{
                animations();
            }];
        }
        else {
            [UIView performWithoutAnimation:^{
                animations();
            }];
        }
    });
}

#pragma mark - Spinner

- (void)initSpinner
{
    if (_spinner) return;
    
    _spinner = [UIActivityIndicatorView new];
    _spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    _spinner.hidesWhenStopped = NO;
    [self addSubview:_spinner];
    [self setNeedsLayout];
}

- (void)layoutSpinner
{
    // center spinner
    _spinner.frame = CGRectCenterInRect(_spinner.frame, self.bounds);
}

- (void)startSpinner
{
    [_spinner startAnimating];
    _spinner.alpha = 1;
}

- (void)stopSpinner
{
    [_spinner stopAnimating];
    _spinner.alpha = 0;
}

#pragma mark - Async view

- (void)layoutAsyncView
{
    // async view should show all
    _asyncView.frame = self.bounds;
}


- (void)showAsyncView
{
    _asyncView.alpha = 1;
}

- (void)hideAsyncView
{
    _asyncView.alpha = 0;
}

#pragma mark - message view

- (void)initNoDataView
{
    if (_messageView) return;
    
    _messageView = [UILabel new];
    _messageView.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_messageView];
    [self setNeedsLayout];
}

- (void)layoutNoDataView
{
    _messageView.frame = self.bounds;
}

- (void)showNoDataView
{
    _messageView.text = @"NO DATA";
    _messageView.alpha = 1;
}

- (void)hideNoDataView
{
    _messageView.alpha = 0;
}

#pragma mark - error view

- (void)initErrorView
{
    if (_errorView) return;
    
    _errorView = [UILabel new];
    _errorView.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_errorView];
    [self setNeedsLayout];
}

- (void)layoutErrorView
{
    _errorView.frame = self.bounds;
}

- (void)showErrorView:(NSError*)error
{
    _errorView.text = [error localizedDescription];
    _errorView.alpha = 1;
}

- (void)hideErrorView
{
    _errorView.alpha = 0;
}


@end
