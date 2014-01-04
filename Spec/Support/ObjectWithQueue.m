#import "ObjectWithQueue.h"


@interface ObjectWithQueue ()
@property (nonatomic, assign) dispatch_queue_t queue;
@end

@implementation ObjectWithQueue

- (id)init {
    self = [super init];
    if (self) {
        self.queue = dispatch_queue_create("Example Spec Queue", NULL);
    }
    return self;
}

- (void)enqueueBlockAsync:(void (^)(void))block {
    dispatch_async(self.queue, block);
}

- (void)dealloc {
    dispatch_release(self.queue);
    [super dealloc];
}

@end
