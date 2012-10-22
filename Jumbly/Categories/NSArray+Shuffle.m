//
//  NSArray+Shuffle.m
//  Jumbly
//
//  Created by Jamie Ly on 21/10/2012.
//  Copyright (c) 2012 Jamie Ly. All rights reserved.
//

#import "NSArray+Shuffle.h"

@implementation NSArray (Shuffle)
- (NSArray*)shuffle
{
    NSMutableArray *shuffled = [self mutableCopy];
    for (NSUInteger i = 0, c = shuffled.count; i < c; ++i)
    {
        // Select a random element between i and end of array to swap with.
        int nElements = c - i;
        int n = arc4random_uniform(nElements) + i;
        [shuffled exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
    return [NSArray arrayWithArray: shuffled];
}
@end
