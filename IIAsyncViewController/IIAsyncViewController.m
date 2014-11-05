//
//  IIAsyncViewController.m
//  Copyright (c) 2014 Tom Adriaenssen. All rights reserved.
//

#import "IIAsyncViewController.h"
#import "IIAsyncStatusView.h"

@implementation IIAsyncViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self wrapWithStatusView];
    [self requestAsyncData];
}

- (void)wrapWithStatusView
{
    // don't wrap if there's a status view already
    if (self.statusView) return;
    
    // get async view. This is the default view when first wrapping.
    UIView<IIAsyncView> *asyncView = (UIView<IIAsyncView>*)self.view;
    
    // now create the status view
    UIView<IIAsyncStatusView> *statusView = [self loadStatusView];
    statusView.frame = asyncView.frame;
    statusView.asyncView = asyncView;
    
    // make main view the wrapping view
    [super setView:statusView];
}

- (void)requestAsyncData
{
    // default: empty. Override this.
}

- (UIView<IIAsyncStatusView>*)loadStatusView
{
    return [IIAsyncStatusView new];
}


@end
