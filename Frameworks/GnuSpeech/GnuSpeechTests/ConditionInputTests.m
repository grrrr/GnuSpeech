#import <Cocoa/Cocoa.h>
#import <XCTest/XCTest.h>

#import "GSTextParser.h"
#import "GSTextParser-Private.h"

@interface ConditionInputTests : XCTestCase
@end

@implementation ConditionInputTests
{
    GSTextParser *_parser;
}

- (void)setUp;
{
    [super setUp];

    _parser = [[GSTextParser alloc] init];
}

- (void)tearDown;
{
    _parser = nil;

    [super tearDown];
}

- (void)testNoChanges;
{
    NSString *input = @"creativity";
    NSString *output = [_parser _conditionInputString:input];
    XCTAssertEqualObjects(output, @"creativity");
}

- (void)testConnectHyphenationAcrossNewline;
{
    NSString *input = @"creativ-   \n     ity";
    NSString *output = [_parser _conditionInputString:input];
    XCTAssertEqualObjects(output, @"creativity");
}

// \u2193 is a Unicode down arrow, which doesn't match the regex for now.  I wanted to use an unprintable character, like \u0007, but Clang generates an error for that.
- (void)testUnprintableBreaksHyphenationNewlinePattern;
{
    NSString *input = @"creativ- \u2193 \n ity";
    NSString *output = [_parser _conditionInputString:input];
    XCTAssertEqualObjects(output, @"creativ- \u2193   ity");
}

- (void)testMidHyphenationUntouched;
{
    NSString *input = @"creativ-ity";
    NSString *output = [_parser _conditionInputString:input];
    XCTAssertEqualObjects(output, @"creativ-ity");
}

- (void)testReplaceUnprintableCharacters;
{
    NSString *input = @"creativ\nity";
    NSString *output = [_parser _conditionInputString:input];
    XCTAssertEqualObjects(output, @"creativ ity");
}

// Not sure what the latter stages will need.  I'll let Unicode characters pass for now.
- (void)testReplaceOddUnicodeCharacters;
{
    NSString *input = @"creativ\u2193ity";
    NSString *output = [_parser _conditionInputString:input];
    XCTAssertEqualObjects(output, @"creativ\u2193ity");
}

@end