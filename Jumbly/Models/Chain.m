//
//  Chain.m
//  Jumbly
//
//  Created by Jamie Ly on 20/10/2012.
//  Copyright (c) 2012 Jamie Ly. All rights reserved.
//

#import "Chain.h"

@interface Chain() {
    NSMutableSet *wordsSet;
}

@end

@implementation Chain
@synthesize words;
- (id) init {
    self = [super init];
    if(self) {
        words = [NSArray array];
        wordsSet = [NSMutableSet set];
    }
    return self;
}
- (NSArray*) addWord: (NSString*) word {
    word = [word lowercaseString];
    if(![wordsSet containsObject: word]) {
        words = [self.words arrayByAddingObject: word];
        [wordsSet addObject: word];
    }
    return self.words;
}
- (NSString*) wordAtIndex: (NSUInteger) index {
    return [self.words objectAtIndex: index];
}
- (NSArray*) reversedWords {
    NSMutableArray *rev = [NSMutableArray array];
    NSEnumerator *enumerator = [self.words reverseObjectEnumerator];
    for(NSString* word in enumerator) {
        [rev addObject: word];
    }
    return [NSArray arrayWithArray: rev];
}
- (BOOL) containsWord: (NSString*) word {
    return [wordsSet containsObject: [word lowercaseString]];
}
+ (Chain*) chainWithWord: (NSString*) word {
    Chain *chain = [[Chain alloc] init];
    [chain addWord: word];
    return chain;
}
- (NSUInteger) count {
    return self.words.count;
}
- (NSString*) firstWord {
    return [self.words objectAtIndex: 0];
}
- (NSString*) lastWord {
    return [self.words objectAtIndex: self.words.count - 1];
}
@end
