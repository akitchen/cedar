#import "ObjectWithWeakDelegate.h"

@implementation ObjectWithWeakDelegate

- (void)tellTheDelegate {
    [self.delegate someMessage];
}

@end

@implementation DelegateImpl

- (void)someMessage {
    self.wasCalled = YES;
}

@end
