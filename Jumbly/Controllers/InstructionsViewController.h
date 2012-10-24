//
//  InstructionsViewController.h
//  Jumbly
//
//  Created by Jamie Ly on 23/10/2012.
//  Copyright (c) 2012 Jamie Ly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InstructionsViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *instructionsLabel;
- (IBAction)onDone:(id)sender;

@end
