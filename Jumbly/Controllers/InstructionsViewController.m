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
    self.webView.backgroundColor = [UIColor clearColor];
    self.webView.opaque = NO;
	[self loadInstructions];
}

- (void) loadInstructions {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSError *error = nil;
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"instructions" ofType:@"txt"];
        NSString *html = [NSString stringWithContentsOfFile: filePath
                                                   encoding: NSUTF8StringEncoding
                                                      error: &error];
        if(error) {
            NSLog(@"Error loading instructions: %@", error);
            return;
        }
        
        [self.webView loadHTMLString: html baseURL: [[NSBundle mainBundle] resourceURL]];
    });
}


- (IBAction)onDone:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES
                                                      completion:nil];
}
@end
