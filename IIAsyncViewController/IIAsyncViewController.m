//
//  IIAsyncViewController.m
//  Copyright (c) 2014 Tom Adriaenssen. All rights reserved.
//

#import "IIAsyncViewController.h"
#import "IIAsyncStatusView.h"
#import "IIAsyncViewInternals.h"

typedef NS_ENUM(NSUInteger, IIAsyncStatusViewState) {
    IIAsyncStatusLoading = 0,
    IIAsyncStatusError = 1,
    IIAsyncStatusNoData = 2,
    IIAsyncStatusData = 255
};


@interface IIAsyncViewController () <IIAsyncDataDelegate>

@end


@implementation IIAsyncViewController {
    IIAsyncStatusViewState _currentState;
}

- (void)viewDidLoad
{
    [self wrapWithStatusView];
    
    // call regular viewDidLoad
    [super viewDidLoad];

    // force an update of the state to loading
    [self updateState:YES];

    [self performAsyncDataRequest];
}

- (UIView<IIAsyncStatusView> *)statusView
{
    return [super.view conformsToProtocol:@protocol(IIAsyncStatusView)] ? (UIView<IIAsyncStatusView> *)super.view : nil;
}

- (UIView<IIAsyncView> *)asyncView
{
    return (UIView<IIAsyncView> *)(self.statusView.asyncView ?: self.view);
}

- (void)wrapWithStatusView
{
    // don't wrap if there's a status view already
    if (self.statusView) return;
    

    // get async view. This is the default view when first wrapping.
    UIView<IIAsyncView> *asyncView = (UIView<IIAsyncView>*)self.view;
    NSAssert([asyncView conformsToProtocol:@protocol(IIAsyncView)], @"[%@ view] should provide a view confirming to IIAsyncView (currently: %@).", self.class, self.view.class);
    
    // now create the status view
    UIView<IIAsyncStatusView> *statusView = [self loadStatusView];
    NSAssert([statusView conformsToProtocol:@protocol(IIAsyncStatusView)], @"[%@ loadStatusView] should provide a view confirming to IIAsyncStatusView.", self.class);
    statusView.frame = asyncView.frame;
    statusView.asyncView = asyncView;
    asyncView.data.asyncDataDelegate = self;
    
    // make main view the wrapping view
    [super setView:statusView];
}

- (void)performAsyncDataRequest
{
    // default: empty. Override this.
}

- (UIView<IIAsyncStatusView>*)loadStatusView
{
    return [IIAsyncStatusView new];
}

#pragma mark - Async View delegate

- (void)asyncDataDidInvalidateState:(id<IIAsyncData>)data
{
    [self updateState:NO];
}

- (void)reloadAsyncData
{
    [self.asyncView.data reset];
    [self performAsyncDataRequest];
}

#pragma mark - State management

- (void)updateState:(BOOL)forcedUpdate
{
    IIAsyncStatusViewState newState = [self determineState];
    BOOL shouldUpdate = forcedUpdate || newState != _currentState;
    _currentState = newState;
    if (!shouldUpdate) return;
    
    BOOL animated = !forcedUpdate;
    [self willTransitionToNewStateAnimated:animated];
    
    switch (newState) {
        case IIAsyncStatusLoading: {
            dispatch_sync_main(^{
                [self.statusView transitionToLoadingStateAnimated:animated];
                [self didTransitionToLoadingStateAnimated:animated];
            });
            break;
        }

        case IIAsyncStatusError: {
            dispatch_sync_main(^{
                [self.statusView transitionToErrorState:self.asyncView.data.error animated:animated];
                [self didTransitionToErrorStateAnimated:animated];
            });
            break;
        }

        case IIAsyncStatusData: {
            dispatch_sync_main(^{
                [self.statusView transitionToDataStateAnimated:animated];
                [self didTransitionToDataStateAnimated:animated];
            });
            break;
        }

        case IIAsyncStatusNoData:
        default: {
            dispatch_sync_main(^{
                [self.statusView transitionToNoDataStateAnimated:animated];
                [self didTransitionToNoDataStateAnimated:animated];
            });
            break;
        }
    }
    
}

- (IIAsyncStatusViewState)determineState
{
    // determine the new state
    if (!self.asyncView || [self.asyncView.data isLoading]) {
        return IIAsyncStatusLoading;
    }
    else if (self.asyncView.data.error) {
        return IIAsyncStatusError;
    }
    else if (self.asyncView.data.value) {
        return IIAsyncStatusData;
    }
    else {
        return IIAsyncStatusNoData;
    }
}

#pragma mark - Subclassing hooks

- (void)willTransitionToNewStateAnimated:(BOOL)animated
{
    // empty. Can be overridden.
}

- (void)didTransitionToLoadingStateAnimated:(BOOL)animated
{
    // empty. Can be overridden.
}

- (void)didTransitionToErrorStateAnimated:(BOOL)animated
{
    // empty. Can be overridden.
}

- (void)didTransitionToDataStateAnimated:(BOOL)animated
{
    // empty. Can be overridden.
}

- (void)didTransitionToNoDataStateAnimated:(BOOL)animated
{
    // empty. Can be overridden.
}


@end
