//
//  WatchdogRunLoopObserver.m
//  PreviewDebugger
//
//  Created by Eugene Kovs on 14.10.2025.
//  https://github.com/kovs705
//

/*
 This class, `WatchdogRunLoopObserver`, essentially wraps CFRunLoopObserver with a nicer, easier-to-use API.
 It calculates the time spent on each run loop iteration and reports to its delegate when your specified threshold is exceeded.
 It uses a default threshold of 4 seconds
 */

#import "WatchdogRunLoopObserver.h"
#include <mach/mach_time.h>

static const NSTimeInterval DefaultStallingThreshold = 4;

@interface WatchdogRunLoopObserver ()

@property (nonatomic, assign, readonly) CFRunLoopRef runLoop;
@property (nonatomic, assign, readonly) CFRunLoopObserverRef observer;
@property (nonatomic, assign, readonly) NSTimeInterval threshold;
@property (nonatomic, assign) uint64_t startTime;

@end

@implementation WatchdogRunLoopObserver

- (instancetype)init {
    return [self initWithRunLoop:CFRunLoopGetMain()
               stallingThreshold:DefaultStallingThreshold];
}

- (instancetype)initWithRunLoop:(CFRunLoopRef)runLoop
              stallingThreshold:(NSTimeInterval)threshold {
    NSParameterAssert(runLoop != NULL);
    NSParameterAssert(threshold > 0);

    self = [super init];
    if (self == nil) {
        return nil;
    }

    _runLoop = (CFRunLoopRef)CFRetain(runLoop);
    _threshold = threshold;

    // Pre-calculate timebase information.
    mach_timebase_info_data_t timebase;
    mach_timebase_info(&timebase);

    NSTimeInterval secondsPerMachTime = timebase.numer / timebase.denom / 1e9;

    __weak typeof(self) weakSelf = self;

    // Observe at an extremely low order so that we can catch stalling even in
    // high-priority operations (like UI redrawing or animation).
    _observer = CFRunLoopObserverCreateWithHandler(NULL, kCFRunLoopAllActivities, YES, INT_MIN,
                                                   ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
        typeof(self) strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }

        switch (activity) {
                // What we consider one "iteration" might start with any one of these events.
            case kCFRunLoopEntry:
            case kCFRunLoopBeforeTimers:
            case kCFRunLoopAfterWaiting:
            case kCFRunLoopBeforeSources:
                if (strongSelf.startTime == 0) {
                    strongSelf.startTime = mach_absolute_time();
                }
                break;

            case kCFRunLoopBeforeWaiting:
            case kCFRunLoopExit: {
                uint64_t endTime = mach_absolute_time();
                if (strongSelf.startTime <= 0) {
                    break;
                }

                uint64_t elapsed = endTime - strongSelf.startTime;

                NSTimeInterval duration = elapsed * secondsPerMachTime;
                if (duration > strongSelf.threshold) {
                    [strongSelf iterationStalledWithDuration:duration];
                }

                strongSelf.startTime = 0;
                break;
            }

            default:
                NSAssert(NO, @"WatchdogRunLoopObserver should not have been triggered for activity %i", (int)activity);
        }
    });

    if (_observer == NULL) {
        return nil;
    }

    return self;
}

- (void)dealloc {
    if (_observer != NULL) {
        CFRunLoopObserverInvalidate(_observer);

        CFRelease(_observer);
        _observer = NULL;
    }

    if (_runLoop != NULL) {
        CFRelease(_runLoop);
        _runLoop = NULL;
    }
}

- (void)start {
    CFRunLoopAddObserver(self.runLoop, self.observer, kCFRunLoopCommonModes);
}

- (void)stop {
    CFRunLoopRemoveObserver(self.runLoop, self.observer, kCFRunLoopCommonModes);
}

- (void)iterationStalledWithDuration:(NSTimeInterval)duration {
    [self.delegate runLoopDidStallWithDuration:duration];
}

@end
