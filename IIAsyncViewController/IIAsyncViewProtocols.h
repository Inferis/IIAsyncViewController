//
//  IIAsyncViewProtocols.h
//  Copyright (c) 2014 Tom Adriaenssen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IIAsyncView <NSObject>

@end


@protocol IIAsyncStatusView <NSObject>

@property (nonatomic, strong) UIView<IIAsyncView> *asyncView;


@end
