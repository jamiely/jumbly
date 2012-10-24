//
//  Jumble.h
//  Jumbly
//
//  Created by Jamie Ly on 20/10/2012.
//  Copyright (c) 2012 Jamie Ly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Chain.h"

@interface Jumble : NSObject

- (NSRegularExpression*) regexWithWord: (NSString*) word andPosition: (NSUInteger) pos;
- (NSRegularExpression*) regexWithWord: (NSString*) word;
- (NSArray*) regexsWithWord: (NSString*) word;
- (Chain*) chainWithWord: (NSString*) word andLength: (NSInteger) length;
- (NSArray*) getWords: (NSRegularExpression*) regex;
- (NSString*) drawWord;
- (BOOL) word: (NSString*) word isNeighborOf: (NSString*) neighbor;

@end
