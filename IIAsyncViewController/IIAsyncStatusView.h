//
//  IIAsyncStatusView.h
//  Copyright (c) 2014 Tom Adriaenssen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IIAsyncViewProtocols.h"

@interface IIAsyncStatusView : UIView<IIAsyncStatusView>

@property (nonatomic, strong, readonly) UIActivityIndicatorView *loadingIndicatorView;
@property (nonatomic, strong, readonly) UIView *errorView;
@property (nonatomic, strong, readonly) UIView *noDataMessageView;

@end
