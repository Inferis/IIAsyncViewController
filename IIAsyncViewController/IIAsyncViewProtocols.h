//
//  IIAsyncViewProtocols.h
//  Copyright (c) 2014 Tom Adriaenssen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IIAsyncView;
@protocol IIAsyncData;

@protocol IIAsyncDataDelegate <NSObject>

@required
- (void)asyncData:(id<IIAsyncData>)data didInvalidateStateForced:(BOOL)forced;
- (void)reloadAsyncData;

@end

@protocol IIAsyncData <NSObject>

@required
@property (nonatomic, assign, readonly, getter = isLoading) BOOL loading;
@property (nonatomic, strong) NSError *error;
@property (nonatomic, strong) id value;
@property (nonatomic, weak) id<IIAsyncDataDelegate> asyncDataDelegate;

- (void)reset;
- (void)invalidateState;

@end

@protocol IIAsyncView <NSObject>

@required
@property (nonatomic, strong, readonly) id<IIAsyncData> asyncData;

- (void)asyncDataApplyValueAnimated:(BOOL)animated;

@optional

- (NSString*)asyncNoDataMessage;
- (BOOL)asyncCanReload;

@end


@protocol IIAsyncStatusView <NSObject>

@required
@property (nonatomic, strong) UIView<IIAsyncView> *asyncView;

- (void)transitionToLoadingStateAnimated:(BOOL)animated;
- (void)transitionToErrorState:(NSError*)error animated:(BOOL)animated;
- (void)transitionToNoDataStateAnimated:(BOOL)animated;
- (void)transitionToDataStateAnimated:(BOOL)animated;

@end
