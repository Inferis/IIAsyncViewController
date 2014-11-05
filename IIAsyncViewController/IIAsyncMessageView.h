//
//  IIAsyncMessageView.h
//  Copyright (c) 2014 Tom Adriaenssen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IIAsyncMessageView;

@protocol IIAsyncMessageViewDelegate <NSObject>

@required
- (void)asyncMessageViewDidSelectReload:(IIAsyncMessageView*)messageView;

@end

@interface IIAsyncMessageView : UIView

@property (nonatomic, copy) NSString *text;
@property (nonatomic, strong, readonly) UILabel *messageLabel;
@property (nonatomic, assign) BOOL showsReloadButton;
@property (nonatomic, weak) id<IIAsyncMessageViewDelegate> delegate;

@end
