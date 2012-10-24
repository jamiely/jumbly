//
//  InstructionsViewController.m
//  Jumbly
//
//  Created by Jamie Ly on 23/10/2012.
//  Copyright (c) 2012 Jamie Ly. All rights reserved.
//

#import "InstructionsViewController.h"

@interface InstructionsViewController ()

@end

@implementation InstructionsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self loadInstructions];
}

- (void) loadInstructions {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSError *error = nil;
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"instructions" ofType:@"txt"];
        self.instructionsLabel.text = [NSString stringWithContentsOfFile: filePath
                                                                encoding: NSUTF8StringEncoding
                                                                   error: &error];
        [self.instructionsLabel sizeToFit];
        if(error) {
            NSLog(@"Error loading instructions: %@", error);
        }
    });
}


- (IBAction)onDone:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:^{}];
}
@end
