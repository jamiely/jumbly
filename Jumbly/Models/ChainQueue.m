//
//  ChainQueue.m
//  Jumbly
//
//  Created by Jamie Ly on 23/10/2012.
//  Copyright (c) 2012 Jamie Ly. All rights reserved.
//

#import "ChainQueue.h"

const NSUInteger CHAINQUEUE_CHAIN_LENGTH = 4;

@interface ChainQueue(){
    NSMutableArray *chains;
}

@end

@implementation ChainQueue
@synthesize jumble;

- (id) init {
    self = [super init];
    if(self) {
        chains = [NSMutableArray array];
    }
    return self;
}

- (void) queueChains: (NSUInteger) chainCount {
    if(chainCount <= 0) return;
    
    Jumble *jumb = jumble;
    dispatch_async(dispatch_get_main_queue(), ^{
        Chain *chain = [jumb chainWithWord: [jumb drawWord] andLength: CHAINQUEUE_CHAIN_LENGTH];
        if(chain) {
            [chains addObject: chain];
            [self queueChains: chainCount - 1];
        }
        else {
            [self queueChains: chainCount];
        }
    });
}
- (Chain*) nextChain {
    Chain *next = nil;
    if(chains.count > 0) {
        next = [chains objectAtIndex: 0];
        [chains removeObjectAtIndex: 0];
        // Queue another chain
        [self queueChains: 1];
    }
    return next;
}
+ (ChainQueue*) mainQueue {
    static ChainQueue *main;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        main = [[ChainQueue alloc]init];
    });
    return main;
}

@end
