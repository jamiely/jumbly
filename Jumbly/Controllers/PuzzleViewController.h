//
//  PuzzleViewController.h
//  Jumbly
//
//  Created by Jamie Ly on 20/10/2012.
//  Copyright (c) 2012 Jamie Ly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Jumble.h"

@interface PuzzleViewController : UIViewController <UITableViewDataSource,
    UITableViewDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate>
@property (nonatomic, strong) Jumble *jumble;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)onNewPuzzle:(id)sender;
- (IBAction)onShowSolution:(id)sender;
- (IBAction)onQuit:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *puzzleLabel;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *gestureRecognizer;
@end
