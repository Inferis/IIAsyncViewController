//
//  IIAsyncDataSpec.m
//  IIAsyncViewControllerDemo
//
//  Created by Tom Adriaenssen on 18/05/15.
//  Copyright (c) 2015 Tom Adriaenssen. All rights reserved.
//

#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>
#import "IIAsyncData.h"

@interface TestDataDelegate : NSObject<IIAsyncDataDelegate>
@end

SpecBegin(IIAsyncData)

describe(@"when setting the delegate", ^{
    __block IIAsyncData *data;
    __block TestDataDelegate *delegate;
    
    beforeEach(^{
        data = [IIAsyncData new];
        delegate = [TestDataDelegate new];
    });

    it(@"should remember the object", ^{
        data.asyncDataDelegate = delegate;
        expect(data.asyncDataDelegate).to.beIdenticalTo(delegate);
    });

    it(@"should not retain the object", ^{
        data.asyncDataDelegate = delegate;
        delegate = nil;
//        waitUntil(^(DoneCallback done) {
//            // give it some time
//            [NSThread sleepForTimeInterval:1];
            expect(data.asyncDataDelegate).to.beNil();
//            done();
//        });
    });
});

it(@"should be loading by default", ^{
    IIAsyncData *data = [IIAsyncData new];
    expect(data.isLoading).to.beTruthy();
});

describe(@"when setting the value", ^{
    __block IIAsyncData *data;
    __block id theValue;
    __block OCMockObject<IIAsyncDataDelegate> *delegate;
    
    beforeEach(^{
        data = [IIAsyncData new];
        delegate = OCMStrictProtocolMock(@protocol(IIAsyncDataDelegate));
        data.asyncDataDelegate = delegate;
    });

    describe(@"to a non-nil value", ^{
        beforeEach(^{
            theValue = [NSObject new];
        });
        
        it(@"should remember the data", ^{
            OCMStub([delegate asyncData:OCMOCK_ANY didInvalidateStateForced:NO]);
            data.value = theValue;
            expect(data.value).to.beIdenticalTo(theValue);
        });
        
        it(@"should call the delegate", ^{
            OCMExpect([delegate asyncData:OCMOCK_ANY didInvalidateStateForced:NO]);
            data.value = theValue;
            OCMVerifyAll(delegate);
        });
        
        it(@"should no longer be loading", ^{
            OCMStub([delegate asyncData:OCMOCK_ANY didInvalidateStateForced:NO]);
            data.value = theValue;
            expect(data.isLoading).to.beFalsy();
        });
    });

    describe(@"to a nil value", ^{
        beforeEach(^{
            theValue = nil;
        });
        
        it(@"should not contain data", ^{
            OCMStub([delegate asyncData:OCMOCK_ANY didInvalidateStateForced:NO]);
            data.value = theValue;
            expect(data.value).to.beNil();
        });
        
        it(@"should call the delegate", ^{
            OCMExpect([delegate asyncData:OCMOCK_ANY didInvalidateStateForced:NO]);
            data.value = theValue;
            OCMVerifyAll(delegate);
        });
        
        it(@"should no longer be loading", ^{
            OCMStub([delegate asyncData:OCMOCK_ANY didInvalidateStateForced:NO]);
            data.value = theValue;
            expect(data.isLoading).to.beFalsy();
        });
    });
});


describe(@"when setting the error", ^{
    __block IIAsyncData *data;
    __block OCMockObject<IIAsyncDataDelegate> *delegate;
    __block NSError* theError;

    beforeEach(^{
        data = [IIAsyncData new];
        delegate = OCMStrictProtocolMock(@protocol(IIAsyncDataDelegate));
        data.asyncDataDelegate = delegate;
        theError = [NSError errorWithDomain:@"test" code:123 userInfo:nil];
    });
    
    it(@"should remember the error", ^{
        OCMStub([delegate asyncData:OCMOCK_ANY didInvalidateStateForced:NO]);
        data.error = theError;
        expect(data.error).to.beIdenticalTo(theError);
    });
    
    it(@"should call the delegate", ^{
        OCMExpect([delegate asyncData:OCMOCK_ANY didInvalidateStateForced:NO]);
        data.error = theError;
        OCMVerifyAll(delegate);
    });

    it(@"should no longer be loading", ^{
        OCMStub([delegate asyncData:OCMOCK_ANY didInvalidateStateForced:NO]);
        data.error = theError;
        expect(data.isLoading).to.beFalsy();
    });
});

describe(@"when resetting", ^{
    __block IIAsyncData *data;
    __block OCMockObject<IIAsyncDataDelegate> *delegate;

    beforeEach(^{
        data = [IIAsyncData new];
        delegate = OCMStrictProtocolMock(@protocol(IIAsyncDataDelegate));
    });

    describe(@"after an error", ^{
        beforeEach(^{
            data.error = [NSError errorWithDomain:@"test" code:123 userInfo:nil];
            data.asyncDataDelegate = delegate;
        });
        
        it(@"should not contain any error", ^{
            OCMStub([delegate asyncData:OCMOCK_ANY didInvalidateStateForced:NO]);
            [data reset];
            expect(data.error).to.beNil();
        });

        it(@"should not contain any data", ^{
            OCMStub([delegate asyncData:OCMOCK_ANY didInvalidateStateForced:NO]);
            [data reset];
            expect(data.value).to.beNil();
        });

        it(@"should call the delegate", ^{
            OCMExpect([delegate asyncData:data didInvalidateStateForced:NO]);
            [data reset];
            OCMVerifyAll(delegate);
        });

        it(@"should be loading", ^{
            OCMStub([delegate asyncData:OCMOCK_ANY didInvalidateStateForced:NO]);
            [data reset];
            expect(data.isLoading).to.beTruthy();
        });
    });

    describe(@"after a data value", ^{
        beforeEach(^{
            data.value = [NSObject new];
            data.asyncDataDelegate = delegate;
        });
        
        it(@"should not contain any error", ^{
            OCMStub([delegate asyncData:OCMOCK_ANY didInvalidateStateForced:NO]);
            [data reset];
            expect(data.error).to.beNil();
        });
        
        it(@"should not contain any data", ^{
            OCMStub([delegate asyncData:OCMOCK_ANY didInvalidateStateForced:NO]);
            [data reset];
            expect(data.value).to.beNil();
        });
        
        it(@"should call the delegate", ^{
            OCMExpect([delegate asyncData:OCMOCK_ANY didInvalidateStateForced:NO]);
            [data reset];
            OCMVerifyAll(delegate);
        });
        
        it(@"should be loading", ^{
            OCMStub([delegate asyncData:OCMOCK_ANY didInvalidateStateForced:NO]);
            [data reset];
            expect(data.isLoading).to.beTruthy();
        });
    });

});

SpecEnd

@implementation TestDataDelegate

- (void)asyncData:(id<IIAsyncData>)data didInvalidateStateForced:(BOOL)forced
{
    
}

- (void)reloadAsyncData
{
    
}

@end
