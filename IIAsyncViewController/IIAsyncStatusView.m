//
//  IIAsyncStatusView.m
//  Copyright (c) 2014 Tom Adriaenssen. All rights reserved.
//

#import "IIAsyncStatusView.h"
#import "IIAsyncViewInternals.h"

@interface IIAsyncStatusView () <IIAsyncMessageViewDelegate>


@end

@implementation IIAsyncStatusView {
    UIActivityIndicatorView *_spinner;
    IIAsyncMessageView *_messageView;
    IIAsyncMessageView *_errorView;
}

@synthesize asyncView = _asyncView;

#pragma mark - initialisation

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
        [_asyncView asyncDataApplyValueAnimated:animated];
        [self hideErrorView];
        [self hideNoDataView];
    }];
}

- (void)animate:(BOOL)animated transition:(void(^)(void))animations
{
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
}

#pragma mark - Spinner

- (void)initSpinner
{
    if (_spinner) return;
    
    _spinner = [UIActivityIndicatorView new];
    _spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    _spinner.hidesWhenStopped = NO;
    [self addSubview:_spinner];
    [self didLoadLoadingIndicatorView];
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

- (void)didLoadLoadingIndicatorView
{
    // empty
}

- (UIActivityIndicatorView *)loadingIndicatorView
{
    return _spinner;
}

#pragma mark - Async view

- (void)setAsyncView:(UIView<IIAsyncView> *)asyncView
{
    if (_asyncView == asyncView) return;
    
    [_asyncView removeFromSuperview];
    _asyncView = asyncView;
    _asyncView.translatesAutoresizingMaskIntoConstraints = YES;
    [self addSubview:_asyncView];
    self.backgroundColor = asyncView.backgroundColor;
    [self setNeedsLayout];
}

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
    
    _messageView = [IIAsyncMessageView new];
    _messageView.delegate = self;
    [self addSubview:_messageView];
    [self didLoadNoDataMessageView];
    [self setNeedsLayout];
}

- (IIAsyncMessageView *)noDataMessageView
{
    return _messageView;
}

- (void)layoutNoDataView
{
    _messageView.frame = self.bounds;
}

- (void)showNoDataView
{
    // get the no data message
    NSString *message = nil;
    if ([_asyncView respondsToSelector:@selector(asyncNoDataMessage)]) {
        message = [_asyncView asyncNoDataMessage];
    }
    message = message ?: NSLocalizedString(@"IIAsyncStatusView.nodata", @"Message to show when no data is present");
    
    _messageView.text = message;
    _messageView.alpha = 1;

    // show reload button if supported
    BOOL canReload = NO;
    if ([_asyncView respondsToSelector:@selector(asyncCanReloadWithNoData)]) {
        canReload = [_asyncView asyncCanReloadWithNoData];
    }
    _messageView.showsReloadButton = canReload;
}

- (void)hideNoDataView
{
    _messageView.alpha = 0;
}

- (void)didLoadNoDataMessageView
{
    _errorView.messageLabel.textColor = [UIColor orangeColor];
}


#pragma mark - error view

- (void)initErrorView
{
    if (_errorView) return;
    
    _errorView = [IIAsyncMessageView new];
    _errorView.delegate = self;
    [self addSubview:_errorView];
    [self didLoadErrorView];
    [self setNeedsLayout];
}

- (IIAsyncMessageView *)errorView
{
    return _errorView;
}

- (void)layoutErrorView
{
    _errorView.frame = self.bounds;
}

- (void)showErrorView:(NSError*)error
{
    _errorView.text = [error localizedDescription];
    _errorView.alpha = 1;
    
    BOOL canReload = NO;
    if ([_asyncView respondsToSelector:@selector(asyncCanReloadAfterError)]) {
        canReload = [_asyncView asyncCanReloadAfterError];
    }
    _errorView.showsReloadButton = canReload;
}

- (void)hideErrorView
{
    _errorView.alpha = 0;
}

- (void)didLoadErrorView
{
    _errorView.messageLabel.textColor = [UIColor redColor];
}

#pragma mark - IIAsyncMessageViewDelegate

- (void)asyncMessageViewDidSelectReload:(IIAsyncMessageView *)messageView
{
    [self.asyncView.data.asyncDataDelegate reloadAsyncData];
}


@end
