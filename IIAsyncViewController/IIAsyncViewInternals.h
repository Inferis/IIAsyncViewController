//
//  IIAsyncViewInternals.h
//  Copyright (c) 2014 Tom Adriaenssen. All rights reserved.
//

// dispatches a block on the main queue
// blocks the calling queue/thread
static inline void dispatch_sync_main(dispatch_block_t block) {
    if ([NSThread isMainThread]) {
        block();
    }
    else {
        dispatch_sync(dispatch_get_main_queue(), block);
    }
}