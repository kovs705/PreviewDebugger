//
//  WatchdogRunLoopObserver.h
//  PreviewDebugger
//
//  Created by Eugene Kovs on 14.10.2025.
//  https://github.com/kovs705
//

@protocol WatchdogRunLoopObserverDelegate <NSObject>

- (void)runLoopDidStallWithDuration:(NSTimeInterval)duration;

@end

@interface WatchdogRunLoopObserver : NSObject

@property (nonatomic, weak, nullable) id<WatchdogRunLoopObserverDelegate> delegate;

- (instancetype)init;

- (instancetype)initWithRunLoop:(CFRunLoopRef)runLoop stallingThreshold:(NSTimeInterval)threshold;

- (void)start;

- (void)stop;
@end
