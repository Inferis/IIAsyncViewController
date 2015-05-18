//
//  IIAsyncViewControllerDemoTests.m
//  IIAsyncViewControllerDemoTests
//
//  Created by Tom Adriaenssen on 04/11/14.
//  Copyright (c) 2014 Tom Adriaenssen. All rights reserved.
//

#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>
#import "TestViewController.h"
#import "IIAsyncViewProtocols.h"

SpecBegin(IIAsyncViewController)

describe(@"when initializing", ^{
    it(@"should not call performAsyncDataRequest", ^{
        id controller = OCMPartialMock([TestViewController new]);
        [[controller reject] performAsyncDataRequest];
        OCMVerifyAll(controller);
    });

    it(@"should not access the view", ^{
        id controller = OCMPartialMock([TestViewController new]);
        [[controller reject] view];
        OCMVerifyAll(controller);
    });
});

describe(@"when accessing the controller's view", ^{
    describe(@"which is not an async view", ^{
        it(@"should throw an exception", ^{
            TestViewController *controller = OCMPartialMock([[TestViewController alloc] initWithDefaultView]);
            expect(^{ [controller view]; }).to.raise(NSInternalInconsistencyException);
        });
        
        it(@"should not load the status view", ^{
            TestViewController *controller = OCMPartialMock([[TestViewController alloc] initWithDefaultView]);
            [[(id)controller reject] loadStatusView];
            OCMVerifyAll((id)controller);
        });
    });

    describe(@"which is an async view", ^{
        it(@"should not throw an exception", ^{
            TestViewController *controller = OCMPartialMock([TestViewController new]);
            expect(^{ [controller view]; }).notTo.raise(NSInternalInconsistencyException);
        });
        
        it(@"should load the status view", ^{
            TestViewController *controller = OCMPartialMock([TestViewController new]);
            OCMExpect([controller loadStatusView]).andForwardToRealObject();
            [controller view];
            OCMVerifyAll((id)controller);
        });

        it(@"throw an exception when the status view does not conform to the correct protocol", ^{
            TestViewController *controller = OCMPartialMock([TestViewController new]);
            UIView *view = [UIView new];
            OCMStub([controller loadStatusView]).andReturn(view);
            expect(^{ [controller view]; }).to.raise(NSInternalInconsistencyException);
        });
        
        it(@"should set the async view as the original view", ^{
            TestViewController *controller = OCMPartialMock([TestViewController new]);
            expect([controller view]).to.equal([controller statusView]);
        });

        it(@"should set the status view as root view", ^{
            TestViewController *controller = OCMPartialMock([TestViewController new]);
            expect([controller view]).to.equal([controller statusView]);
        });
        
        it(@"should wrap the async view in the status view", ^{
            TestViewController *controller = OCMPartialMock([TestViewController new]);
            expect([controller asyncView].superview).to.equal([controller statusView]);
        });

        it(@"should invoke performRequestAsyncData", ^{
            TestViewController *controller = OCMPartialMock([TestViewController new]);
            OCMExpect([controller performAsyncDataRequest]);
            [controller view];
            OCMVerifyAll((id)controller);
        });
    });
});

describe(@"when interacting with the async view", ^{
    describe(@"when setting non-nil data", ^{
        it(@"receives a callback before the data changes", ^{
            TestViewController *controller = OCMPartialMock([TestViewController new]);
            OCMExpect([controller willTransitionToNewStateAnimated:YES]);
            controller.asyncView.asyncData.value = [NSObject new];
            OCMVerifyAll((id)controller);
        });
        
        it(@"receives a callback after the data changes", ^{
            TestViewController *controller = OCMPartialMock([TestViewController new]);
            OCMExpect([controller didTransitionToDataStateAnimated:YES]);
            controller.asyncView.asyncData.value = [NSObject new];
            OCMVerifyAll((id)controller);
        });
    });

    describe(@"when setting nil data", ^{
        it(@"receives a callback before the data changes", ^{
            TestViewController *controller = OCMPartialMock([TestViewController new]);
            OCMExpect([controller willTransitionToNewStateAnimated:YES]);
            controller.asyncView.asyncData.value = nil;
            OCMVerifyAll((id)controller);
        });
        
        it(@"receives a callback after the data changes", ^{
            TestViewController *controller = OCMPartialMock([TestViewController new]);
            OCMExpect([controller didTransitionToNoDataStateAnimated:YES]);
            controller.asyncView.asyncData.value = nil;
            OCMVerifyAll((id)controller);
        });
    });

    describe(@"when setting errors", ^{
        it(@"receives a callback before the error changes", ^{
            TestViewController *controller = OCMPartialMock([TestViewController new]);
            OCMExpect([controller willTransitionToNewStateAnimated:YES]);
            controller.asyncView.asyncData.value = [NSError errorWithDomain:@"test" code:123 userInfo:nil];
            OCMVerifyAll((id)controller);
        });
        
        it(@"receives a callback after the error changes", ^{
            TestViewController *controller = OCMPartialMock([TestViewController new]);
            OCMExpect([controller didTransitionToErrorStateAnimated:YES]);
            controller.asyncView.asyncData.error = [NSError errorWithDomain:@"test" code:123 userInfo:nil];
            OCMVerifyAll((id)controller);
        });
    });
    
    describe(@"when resetting", ^{
        it(@"receives a callback before resetting", ^{
            TestViewController *controller = OCMPartialMock([TestViewController new]);
            controller.asyncView.asyncData.value = [NSObject new];
            OCMExpect([controller willTransitionToNewStateAnimated:YES]);
            [controller.asyncView.asyncData reset];
            OCMVerifyAll((id)controller);
        });
        
        it(@"receives a callback after resetting", ^{
            TestViewController *controller = OCMPartialMock([TestViewController new]);
            controller.asyncView.asyncData.value = [NSObject new];
            OCMExpect([controller didTransitionToLoadingStateAnimated:YES]);
            [controller.asyncView.asyncData reset];
            OCMVerifyAll((id)controller);
        });
    });
});


SpecEnd