//
//  IIAsyncMessageView.h
//  Copyright (c) 2014 Tom Adriaenssen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IIAsyncMessageView : UIView

@property (nonatomic, copy) NSString *text;
@property (nonatomic, strong, readonly) UILabel *messageLabel;

@end
