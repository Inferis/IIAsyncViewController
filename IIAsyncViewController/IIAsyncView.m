//
//  IIAsyncView.m
//  Copyright (c) 2014 Tom Adriaenssen. All rights reserved.
//

#import "IIAsyncView.h"
#import "IIAsyncData.h"
#import "IIAsyncViewInternals.h"

@implementation IIAsyncView 

@synthesize asyncData = _data;

- (id<IIAsyncData>)asyncData
{
    return (_data = _data ?: [IIAsyncData new]);
}

- (void)asyncDataApplyValueAnimated:(BOOL)animated
{
#if !defined(NS_BLOCK_ASSERTIONS)
    NSString *error = [NSString stringWithFormat:@"%@ should implement asyncApplyDataValueAnimated:", self.class];
    NSAssert(NO, error);
#endif
}



@end
