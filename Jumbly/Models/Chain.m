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
    if(![wordsSet containsObject: word]) {
        words = [self.words arrayByAddingObject: word];
        [wordsSet addObject: word];
    }
    return self.words;
}
+ (Chain*) chainWithWord: (NSString*) word {
    Chain *chain = [[Chain alloc] init];
    [chain addWord: word];
    return chain;
}
- (NSUInteger) count {
    return self.words.count;
}
@end
