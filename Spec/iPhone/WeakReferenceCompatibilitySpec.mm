#import "SpecHelper.h"
#import "ObjectWithWeakDelegate.h"
#import "ARCViewController.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(WeakReferenceCompatibilitySpec)

// This spec exists as a regression test to ensure that Cedar Doubles continue
// to work with the iOS 5 runtime.
//
// For more info please see http://openradar.appspot.com/11117786
// or http://stackoverflow.com/questions/8675054/why-is-my-objects-weak-delegate-property-nil-in-my-unit-tests

describe(@"An object with a weak reference to a Cedar Double", ^{
    __block ObjectWithWeakDelegate *object;

    beforeEach(^{
        id<ExampleDelegate> fakeDelegate = nice_fake_for(@protocol(ExampleDelegate));
        object = [[[ObjectWithWeakDelegate alloc] init] autorelease];
        object.delegate = fakeDelegate;
    });

    it(@"should have the Double as a delegate", ^{
        object.delegate should_not be_nil;
    });

    describe(@"when sending a message", ^{
        beforeEach(^{
            [object tellTheDelegate];
        });

        it(@"should result in the double having received the message", ^{
            object.delegate should have_received(@selector(someMessage));
        });
    });
});

fdescribe(@"A UIViewController subclass compiled under ARC", ^{
    __block ARCViewController *controller;

    beforeEach(^{
        controller = [[[ARCViewController alloc] init] autorelease];
        controller.view should_not be_nil;
    });

    afterEach(^{
        [NSThread sleepForTimeInterval:0.5];
    });

    describe(@"spying on a weakly referred-to subview property", ^{
        beforeEach(^{
            spy_on(controller.someSubview);

            [controller.someSubview layoutIfNeeded];
        });

        it(@"should allow recording of sent messages, and not blow up on dealloc", ^{
            NSLog(@"================> %@", [(id)controller.someSubview sent_messages]);

            controller.someSubview should have_received("layoutIfNeeded");
        });
    });
});

SPEC_END
