//
//  DemoView.m
//  Copyright (c) 2014 Tom Adriaenssen. All rights reserved.
//

#import "DemoView.h"

@interface DemoView ()

@property (nonatomic, strong) IBOutlet UILabel *label;

@end

@implementation DemoView {
    
}

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)asyncDataApplyValueAnimated:(BOOL)animated
{
    self.label.attributedText = self.data.value;
}

- (BOOL)asyncCanReloadWithNoData
{
    return NO;
}

- (BOOL)asyncCanReloadAfterError
{
    return YES;
}


@end
