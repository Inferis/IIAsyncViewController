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
 * Rerequests the data. Takes care of updating the loading status and invoking
 * performAsyncDataRequest. You shouldn't override this method.
 */
- (void)reloadAsyncData;

/*
 * Subclassing hook to allow you to provide a different status view instance.
 * Don't call this method directly, it will be called by the controller to load
 * the status view when needed.
 */
- (UIView<IIAsyncStatusView>*)loadStatusView;

/*
 * Subclassing hook to perform the async data request.
 */
- (void)performAsyncDataRequest;

/*
 * Subclassing hooks to get notified when the async view will/did transition to a new state.
 */
- (void)willTransitionToNewStateAnimated:(BOOL)animated;
- (void)didTransitionToLoadingStateAnimated:(BOOL)animated;
- (void)didTransitionToErrorStateAnimated:(BOOL)animated;
- (void)didTransitionToDataStateAnimated:(BOOL)animated;
- (void)didTransitionToNoDataStateAnimated:(BOOL)animated;

@end
