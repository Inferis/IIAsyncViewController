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
    [self initMessageView];
}

#pragma mark - Setters

- (void)setAsyncView:(UIView<IIAsyncView> *)asyncView
{
    if (_asyncView == asyncView) return;
    
    [_asyncView removeFromSuperview];
    _asyncView = asyncView;
    [self addSubview:_asyncView];
    self.backgroundColor = asyncView.backgroundColor;
    [self setNeedsLayout];
}

#pragma mark - Overrides

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self layoutSpinner];
    [self layoutAsyncView];
    [self layoutMessageView];
}

#pragma mark - State transitioning

- (void)transitionToLoadingStateAnimated:(BOOL)animated
{
    [self animate:animated transition:^{
        [self startSpinner];
        [self hideAsyncView];
        [self hideMessageView];
    }];
}

- (void)transitionToErrorState:(NSError *)error animated:(BOOL)animated
{
    [self animate:animated transition:^{
        [self stopSpinner];
        [self hideAsyncView];
        [self showMessageView:[error localizedDescription]];
    }];
}

- (void)transitionToNoDataStateAnimated:(BOOL)animated
{
    [self animate:animated transition:^{
        [self stopSpinner];
        [self hideAsyncView];
        [self showMessageView:@"NO DATA"];
    }];
}

- (void)transitionToDataStateAnimated:(BOOL)animated
{
    [self animate:animated transition:^{
        [self stopSpinner];
        [self showAsyncView];
        [_asyncView applyDataAnimated:animated];
        [self hideMessageView];
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

- (void)initMessageView
{
    if (_messageView) return;
    
    _messageView = [UILabel new];
    [self addSubview:_messageView];
    [self setNeedsLayout];
}

- (void)layoutMessageView
{
    // first find the bounds to work in
    CGRect bounds = CGRectStandardize(CGRectInset(self.bounds, 5, 5));
    
    // then determine the most desirable bounds
    bounds = (CGRect) { .origin = CGPointZero, .size = [_messageView systemLayoutSizeFittingSize:bounds.size] };
    
    // then center it
    bounds = CGRectCenterInRect(bounds, self.bounds);
    
    _messageView.frame = bounds;
}

- (void)showMessageView:(NSString*)message
{
    _messageView.text = message;
    _messageView.alpha = 1;
    [self setNeedsLayout];
}

- (void)hideMessageView
{
    _messageView.alpha = 0;
}


@end
