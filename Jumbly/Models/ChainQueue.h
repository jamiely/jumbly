//
//  ChainQueue.h
//  Jumbly
//
//  Created by Jamie Ly on 23/10/2012.
//  Copyright (c) 2012 Jamie Ly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Jumble.h"
#import "Chain.h"

const NSUInteger CHAINQUEUE_CHAIN_LENGTH;

@interface ChainQueue : NSObject
- (void) queueChains: (NSUInteger) chainCount;
- (Chain*) nextChain;
+ (ChainQueue*) mainQueue;

@property (nonatomic, strong) Jumble *jumble;

@end
