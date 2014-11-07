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

#define CGRectCenterInRect(rect, inRect) ({ __typeof__(rect) __r = (rect); __typeof__(rect) __ir = (inRect); (CGRect) { CGRectGetMinX(__ir) + floorf((__ir.size.width-__r.size.width)/2.0f), CGRectGetMinY(__ir) + floorf((__ir.size.height-__r.size.height)/2.0f), __r.size }; })
