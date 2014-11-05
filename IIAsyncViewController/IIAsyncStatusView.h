//
//  IIAsyncStatusView.h
//  Copyright (c) 2014 Tom Adriaenssen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IIAsyncViewProtocols.h"
#import "IIAsyncMessageView.h"

@interface IIAsyncStatusView : UIView<IIAsyncStatusView>

@property (nonatomic, strong, readonly) UIActivityIndicatorView *loadingIndicatorView;
@property (nonatomic, strong, readonly) IIAsyncMessageView *errorView;
@property (nonatomic, strong, readonly) IIAsyncMessageView *noDataMessageView;

// These three allow you to override the styling in a subclass
- (void)didLoadErrorView;
- (void)didLoadNoDataMessageView;
- (void)didLoadLoadingIndicatorView;

@end
