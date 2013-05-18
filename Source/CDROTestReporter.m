#import "CDROTestReporter.h"
#import "CDRFunctions.h"
#import "CDRExample.h"
#import "CDRExampleGroup.h"

@implementation CDROTestReporter

- (id)init {
    if ((self = [super init])) {
        failedExamples_ = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc {
    [failedExamples_ release];
    failedExamples_ = nil;
    [super dealloc];
}

- (void)reportOnExample:(CDRExample *)example {
    [super reportOnExample:example];

    if (example.state == CDRExampleStateError || example.state == CDRExampleStateFailed) {
        [failedExamples_ addObject:example];
    }
}

- (void)printStats {
    const char *startTimeString = [[startTime_ description] cStringUsingEncoding:NSUTF8StringEncoding];
    fprintf(stderr, "Test Suite 'CDROTestReporter' started at %s\n", startTimeString);

    for (CDRExample *example in failedExamples_) {
        const char *exampleName =
                [[NSString stringWithFormat:@"%@ %@", [example fullTextInPieces][0], @"ExampleName"] UTF8String];

        fprintf(stderr, "Test Case '-[%s]' started.\n", exampleName);

        NSString *testResult =
            [NSString stringWithFormat:@"%@:%d: error: -[%s] : %@ # %@",
                example.failure.fileName, example.failure.lineNumber, exampleName, example.fullText, example.failure.reason];

        fprintf(stderr, "%s\n", [testResult UTF8String]);
        fprintf(stderr, "Test Case '-[%s]' failed (0.001 seconds).\n", exampleName);
    }

    const char *endTimeString = [[endTime_ description] cStringUsingEncoding:NSUTF8StringEncoding];
    fprintf(stderr, "Test Suite 'CDROTestReporter' finished at %s.\n", endTimeString);

    const char *testsString = exampleCount_ == 1 ? "test" : "tests";
    const char *failuresString = exampleCount_ == 1 ? "failure" : "failures";
    float totalTimeElapsed = [endTime_ timeIntervalSinceDate:startTime_];

    fprintf(stderr, "Executed %u %s, with %u %s (0 unexpected) in %.4f (%.4f) seconds\n",
        exampleCount_, testsString, (unsigned int)failedExamples_.count, failuresString, totalTimeElapsed, totalTimeElapsed);
}

@end

/*

Test Case '-[ExampleApplicationTestsWithSenTestingKit testApplicationTestsRun]' started.
/Users/pivotal/workspace/cedar/OCUnitAppTests/OCUnitApplicationTestsWithSenTestingKit.m:9: error: -[ExampleApplicationTestsWithSenTestingKit testApplicationTestsRun] : '1' should be equal to '2': ARRRgh
Test Case '-[ExampleApplicationTestsWithSenTestingKit testApplicationTestsRun]' failed (0.000 seconds).

*/
