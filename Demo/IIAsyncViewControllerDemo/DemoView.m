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

- (void)asyncDataApplyValueAnimated:(BOOL)animated
{
    self.label.text = [NSString stringWithFormat:@"We got: \"%@\"", self.asyncData.value];
}

- (BOOL)asyncCanReload
{
    return self.asyncData.error != nil;
}

- (IBAction)reload:(id)sender {
    [self.asyncData.asyncDataDelegate reloadAsyncData];
}



@end
