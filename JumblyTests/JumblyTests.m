//
//  JumblyTests.m
//  JumblyTests
//
//  Created by Jamie Ly on 20/10/2012.
//  Copyright (c) 2012 Jamie Ly. All rights reserved.
//

#import "JumblyTests.h"
#import "Jumble.h"

@interface JumblyTests() {
    Jumble *jumble;
}

@end

@implementation JumblyTests

- (void)setUp
{
    [super setUp];
    jumble = [[Jumble alloc] init];
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testCache
{
    NSError __autoreleasing *error;
    NSRegularExpression *regex = [NSRegularExpression
                                  regularExpressionWithPattern:@"zymi[^z]"
                                  options:NSRegularExpressionCaseInsensitive
                                  error: &error];
    STAssertNil(error, @"No error");
    NSArray *words = [jumble getWords: regex];
    STAssertEquals((NSUInteger)2, words.count, @"2 words found");
}

- (void)testRegexGen
{
    NSRegularExpression *regex = [jumble regexWithWord: @"t"];
    STAssertEqualObjects(@"[^t]", regex.pattern, @"Pattern generated correctly");
    
    regex = [jumble regexWithWord: @"ab"];
    STAssertTrue([regex.pattern isEqualToString: @"a[^b]"]
                 || [regex.pattern isEqualToString: @"[^a]b"],
                 [NSString stringWithFormat:@"Random pattern %@", regex.pattern]);
}

- (void)testChainGen
{
    Chain *chain = [jumble chainWithWord: @"zzzzz" andLength:1];
    STAssertEquals((NSUInteger)1, chain.count, @"Chain of 1");
    
    chain = [jumble chainWithWord: @"zzzzz" andLength:2];
    STAssertNil(chain, @"Chain is nil");

    chain = [jumble chainWithWord: @"apple" andLength:2];
    STAssertEquals((NSUInteger)2, chain.count, @"Chain of 2");
}

@end
