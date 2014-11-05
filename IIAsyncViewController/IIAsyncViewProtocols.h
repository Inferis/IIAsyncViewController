//
//  IIAsyncViewProtocols.h
//  Copyright (c) 2014 Tom Adriaenssen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IIAsyncView;

@protocol IIAsyncViewDelegate <NSObject>

@required
- (void)asyncViewDidInvalidateState:(IIAsyncView*)view;
- (void)reloadAsyncView;

@end

@protocol IIAsyncView <NSObject>

@required
@property (nonatomic, assign, readonly, getter = isLoading) BOOL loading;
@property (nonatomic, strong) NSError *error;
@property (nonatomic, strong) id data;
@property (nonatomic, weak) id<IIAsyncViewDelegate> asyncStateDelegate;

- (void)reset;
- (void)invalidateState;
- (void)applyDataAnimated:(BOOL)animated;

@optional
- (NSString*)noDataMessage;
- (BOOL)canReloadAfterError;
- (BOOL)canReloadWithNoData;

@end


@protocol IIAsyncStatusView <NSObject>

@required
@property (nonatomic, strong) UIView<IIAsyncView> *asyncView;

- (void)transitionToLoadingStateAnimated:(BOOL)animated;
- (void)transitionToErrorState:(NSError*)error animated:(BOOL)animated;
- (void)transitionToNoDataStateAnimated:(BOOL)animated;
- (void)transitionToDataStateAnimated:(BOOL)animated;

@end
