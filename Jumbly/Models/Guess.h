//
//  Guess.h
//  Jumbly
//
//  Created by Jamie Ly on 20/10/2012.
//  Copyright (c) 2012 Jamie Ly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Guess : NSObject
@property (nonatomic, copy) NSString *word;
@property (nonatomic, assign) BOOL hint;
@end
