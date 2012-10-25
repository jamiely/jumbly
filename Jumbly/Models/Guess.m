//
//  Guess.m
//  Jumbly
//
//  Created by Jamie Ly on 20/10/2012.
//  Copyright (c) 2012 Jamie Ly. All rights reserved.
//

#import "Guess.h"

@implementation Guess

@synthesize word;

- (id) init {
    self = [super init];
    if(self) {
        self.hint = NO;
    }
    return self;
}

@end
