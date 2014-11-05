//
//  IIAsyncMessageView.m
//  Copyright (c) 2014 Tom Adriaenssen. All rights reserved.
//

#import "IIAsyncMessageView.h"
#import "IIAsyncViewInternals.h"

@implementation IIAsyncMessageView {
    UILabel *_messageView;
    UIButton *_reloadButton;
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
    [self initMessageView];
    [self initReloadButton];
}

- (void)initMessageView
{
    if (_messageView) return;
    _messageView = [UILabel new];
    [self addSubview:_messageView];
    [self setNeedsLayout];
}

- (void)initReloadButton
{
    if (_reloadButton) return;
    _showsReloadButton = NO;
    _reloadButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_reloadButton setTitle:NSLocalizedString(@"IIAsyncMessageView.reload", @"Reload button text for IIAsyncMessageView")
                   forState:UIControlStateNormal];
    [self addSubview:_reloadButton];
    [self setNeedsLayout];
    
    [_reloadButton addTarget:self action:@selector(reloadPressed) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Layout

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self layoutReloadButton];
    [self layoutMessageView];
    
    if (!CGRectIsEmpty(_messageView.frame) && !CGRectIsEmpty(_reloadButton.frame)) {
        // adjust
        CGFloat totalHeight = CGRectGetHeight(_messageView.frame) + 10 + CGRectGetHeight(_reloadButton.frame);
        _messageView.frame = CGRectOffset(_messageView.frame, 0, -floor((totalHeight-CGRectGetHeight(_messageView.frame))/2.0));
        _reloadButton.frame = CGRectOffset(_reloadButton.frame, 0, floor((totalHeight-CGRectGetHeight(_reloadButton.frame))/2.0));
    }
}

- (void)layoutMessageView
{
    [self layoutCenteredView:_messageView];
}

- (void)layoutReloadButton
{
    if (!_showsReloadButton) {
        _reloadButton.frame = CGRectZero;
        _reloadButton.alpha = YES;
        return;
    }
    
    [self layoutCenteredView:_reloadButton];
}

- (void)layoutCenteredView:(UIView*)view
{
    // first find the bounds to work in
    CGRect bounds = CGRectStandardize(CGRectInset(self.bounds, 5, 5));
    
    // then determine the most desirable bounds
    bounds = (CGRect) { .origin = CGPointZero, .size = [view systemLayoutSizeFittingSize:bounds.size] };
    
    // then center it
    bounds = CGRectCenterInRect(bounds, self.bounds);
    
    view.frame = bounds;
}

#pragma mark - Properties

- (void)setText:(NSString *)text
{
    _messageView.text = text;
    [self setNeedsLayout];
}

- (NSString *)text
{
    return _messageView.text;
}

- (UILabel *)messageLabel
{
    return _messageView;
}

- (void)setShowsReloadButton:(BOOL)showsReloadButton
{
    _showsReloadButton = showsReloadButton;
    [self setNeedsLayout];
}

#pragma mark - Action

- (void)reloadPressed
{
    [self.delegate asyncMessageViewDidSelectReload:self];
}


@end
