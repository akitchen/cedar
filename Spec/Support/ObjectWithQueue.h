#import <Foundation/Foundation.h>


@interface ObjectWithQueue : NSObject

- (void)enqueueBlockAsync:(void (^)(void))block;

@end
