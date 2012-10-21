//
//  Jumble.m
//  Jumbly
//
//  Created by Jamie Ly on 20/10/2012.
//  Copyright (c) 2012 Jamie Ly. All rights reserved.
//

#import "Jumble.h"

@interface Jumble () {
    NSArray *cache;
}
@end

@implementation Jumble

- (id) init {
    self = [super init];
    if(self) {
        NSError __autoreleasing *error;
        NSURL *fileUrl = [[NSBundle mainBundle] URLForResource:@"dictionary-cache"
                                                     withExtension:@"txt"];
        NSString *fileData = [NSString stringWithContentsOfURL: fileUrl
                                                      encoding: NSStringEncodingConversionAllowLossy
                                                         error: &error];
        if(error) {
            NSLog(@"Error loading dictionary cache: %@", error);
            cache = @[];
        }
        else {
            cache = [fileData componentsSeparatedByString: @"\n"];
        }
    }
    return self;
}

- (NSRegularExpression*) regexWithWord: (NSString*) word {
    return [self regexWithWord: word andPosition: arc4random() % word.length];
}

- (NSRegularExpression*) regexWithWord: (NSString*) word andPosition: (NSUInteger) pos {
    NSString *pattern = [NSString stringWithFormat: @"%@[^%c]%@",
                         [word substringToIndex: pos],
                         [word characterAtIndex:pos],
                         [word substringFromIndex: pos+1]];
    NSError __autoreleasing *error;
    return [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error: &error];
}

- (NSArray*) regexsWithWord: (NSString*) word {
    NSMutableArray *regexes = [NSMutableArray array];
    for(NSInteger i = 0, c = word.length; i < c; i++) {
        [regexes addObject: [self regexWithWord: word andPosition: i]];
    }
    return [NSArray arrayWithArray: regexes];
}

- (Chain*) chainWithWord: (NSString*) word andLength: (NSInteger) length {
    if(length <= 1) {
        return [Chain chainWithWord: word];
    }
    
    Chain* __block chain = nil;
    NSArray *regexes = [self regexsWithWord: word];
    [regexes enumerateObjectsUsingBlock:^(NSRegularExpression *regex, NSUInteger idx, BOOL *stop) {
        chain = [self tryRegex: regex withWord: word withLength: length];
        if(chain) *stop = YES;
    }];
    
    return chain;
}

- (Chain*) tryRegex: (NSRegularExpression*) regex
           withWord: (NSString*) word withLength: (NSInteger) length {
    
    NSArray *words = [self getWords: regex];
    Chain* chain = nil;
    for(NSInteger i = 0, count = words.count; i < count; i++) {
        NSString *nextWord = [words objectAtIndex: i];
        Chain* nextChain = [self chainWithWord: nextWord
                                     andLength: length - 1];
        if(nextChain.count >= length-1) {
            chain = nextChain;
            [nextChain addWord: word];
        }
    }
    
    return chain;
}

- (NSArray*) getWords: (NSRegularExpression*) regex {
    NSMutableArray *words = [NSMutableArray array];
    for(NSInteger i = 0, c = cache.count; i < c; i++) {
        NSString *word = [cache objectAtIndex: i];
        if([regex firstMatchInString: word options: NSMatchingAnchored
                               range: NSMakeRange(0, word.length)]) {
            [words addObject: word];
        }
    }
    return [NSArray arrayWithArray: words];
}
- (NSString*) drawWord {
    return [cache objectAtIndex: arc4random() % cache.count];
}

- (BOOL) word: (NSString*) word isNeighborOf: (NSString*) neighbor {
    if(word.length != neighbor.length) return NO;

    NSInteger diffCount = 0;
    for(NSInteger i = 0, c = word.length; i < c; i ++ ) {
        if([word characterAtIndex: i] != [neighbor characterAtIndex: i]) {
            diffCount ++;
        }
    }
    return diffCount <= 1;
}
@end
