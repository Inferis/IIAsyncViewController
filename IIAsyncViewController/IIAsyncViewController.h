//
//  IIAsyncViewController.h
//  Copyright (c) 2014 Tom Adriaenssen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IIAsyncView.h"
#import "IIAsyncStatusView.h"

@interface IIAsyncViewController : UIViewController

@property (nonatomic, strong, readonly) UIView<IIAsyncStatusView> *statusView;
@property (nonatomic, strong, readonly) UIView<IIAsyncView> *asyncView;

/*
 * This allows you to provide a different status view instance.
 * Don't call this method directly, it will be called by the controller to load
 * the status view when needed.
 */
- (UIView<IIAsyncStatusView>*)loadStatusView;

- (void)requestAsyncData;

@end
