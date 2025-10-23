//
//  WatchdogRunLoopObserver.h
//  PreviewDebugger
//
//  Created by Eugene Kovs on 14.10.2025.
//  https://github.com/kovs705
//

#import <Foundation/Foundation.h>
#import <CoreFoundation/CoreFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol WatchdogRunLoopObserverDelegate <NSObject>

- (void)runLoopDidStallWithDuration:(NSTimeInterval)duration;

@end

@interface WatchdogRunLoopObserver : NSObject

@property (nonatomic, weak, nullable) id<WatchdogRunLoopObserverDelegate> delegate;

- (instancetype)init;

- (instancetype)initWithRunLoop:(CFRunLoopRef _Nonnull)runLoop stallingThreshold:(NSTimeInterval)threshold NS_DESIGNATED_INITIALIZER;

- (void)start;

- (void)stop;
@end

NS_ASSUME_NONNULL_END
