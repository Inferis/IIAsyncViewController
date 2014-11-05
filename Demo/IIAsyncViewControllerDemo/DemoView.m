//
//  DemoView.m
//  Copyright (c) 2014 Tom Adriaenssen. All rights reserved.
//

#import "DemoView.h"

@interface DemoView ()

@property (nonatomic, strong) IBOutlet UILabel *label;

@end

@implementation DemoView

- (void)applyDataAnimated:(BOOL)animated
{
    self.label.attributedText = self.data;
}

- (BOOL)canReloadWithNoData
{
    return NO;
}

- (BOOL)canReloadAfterError
{
    return YES;
}

@end
