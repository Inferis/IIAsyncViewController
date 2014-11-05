//
//  IIAsyncMessageView.m
//  Copyright (c) 2014 Tom Adriaenssen. All rights reserved.
//

#import "IIAsyncMessageView.h"
#import "IIAsyncViewInternals.h"

@implementation IIAsyncMessageView {
    UILabel *_messageView;
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
}

- (void)initMessageView
{
    _messageView = [UILabel new];
    [self addSubview:_messageView];
    [self setNeedsLayout];
}

#pragma mark - Layout

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self layoutMessageView];
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


@end
