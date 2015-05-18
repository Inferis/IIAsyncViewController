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


SpecEnd