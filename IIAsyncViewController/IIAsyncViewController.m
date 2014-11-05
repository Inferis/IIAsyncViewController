//
//  IIAsyncViewController.m
//  Copyright (c) 2014 Tom Adriaenssen. All rights reserved.
//

#import "IIAsyncViewController.h"
#import "IIAsyncStatusView.h"

typedef NS_ENUM(NSUInteger, IIAsyncStatusViewState) {
    IIAsyncStatusLoading = 0,
    IIAsyncStatusError = 1,
    IIAsyncStatusNoData = 2,
    IIAsyncStatusData = 255
};


@interface IIAsyncViewController () <IIAsyncViewDelegate>

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
    
    // now create the status view
    UIView<IIAsyncStatusView> *statusView = [self loadStatusView];
    NSAssert([statusView conformsToProtocol:@protocol(IIAsyncStatusView)], @"[%@ loadStatusView] should provide a view confirming to IIAsyncStatusView.", self.class);
    statusView.frame = asyncView.frame;
    statusView.asyncView = asyncView;
    asyncView.asyncStateDelegate = self;
    
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

- (void)asyncViewDidInvalidateState:(IIAsyncView *)view
{
    [self updateState:NO];
}

- (void)reloadAsyncView
{
    [self reloadAsyncData];
}

- (void)reloadAsyncData
{
    [self.asyncView reset];
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
        case IIAsyncStatusLoading:
            [self.statusView transitionToLoadingStateAnimated:animated];
            [self didTransitionToLoadingStateAnimated:animated];
            break;

        case IIAsyncStatusError:
            [self.statusView transitionToErrorState:self.asyncView.error animated:animated];
            [self didTransitionToErrorStateAnimated:animated];
            break;

        case IIAsyncStatusData:
            [self.statusView transitionToDataStateAnimated:animated];
            [self didTransitionToDataStateAnimated:animated];
            break;

        case IIAsyncStatusNoData:
        default:
            [self.statusView transitionToNoDataStateAnimated:animated];
            [self didTransitionToNoDataStateAnimated:animated];
            break;
    }
    
}

- (IIAsyncStatusViewState)determineState
{
    // determine the new state
    if (!self.asyncView || ([self.asyncView respondsToSelector:@selector(isLoading)] && [self.asyncView isLoading])) {
        return IIAsyncStatusLoading;
    }
    else if ([self.asyncView respondsToSelector:@selector(error)] && self.asyncView.error) {
        return IIAsyncStatusError;
    }
    else if (![self.asyncView respondsToSelector:@selector(data)] || self.asyncView.data) {
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
