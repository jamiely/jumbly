//
//  PuzzleViewController.m
//  Jumbly
//
//  Created by Jamie Ly on 20/10/2012.
//  Copyright (c) 2012 Jamie Ly. All rights reserved.
//

#import "PuzzleViewController.h"

@interface PuzzleViewController () {
    Chain *chain;
}
@end

@implementation PuzzleViewController

@synthesize jumble;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadPuzzle];
}

- (void) loadPuzzle {
    if(![self.activityIndicator superview]) {
        [self.view addSubview: self.activityIndicator];
        [self.activityIndicator startAnimating];
        self.activityIndicator.color = [UIColor redColor];
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        [self loadChain];
        if(chain) {
            [self.activityIndicator removeFromSuperview];
            [self.activityIndicator stopAnimating];
        }
        else {
            [self loadPuzzle];
        }
    });
}

- (void) loadChain {
    // get a new puzzle
    NSString *initialWord = [jumble drawWord];
    chain = [jumble chainWithWord: initialWord andLength: 5];
    // @todo, it's possible for this to be blank
    // @todo, add an activity indicator
    [self.tableView reloadData];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(!chain) return 1;
    return chain.count;
}

- (UITableViewCell*) tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StandardTableCell"];
    if(chain) {
        cell.textLabel.text = [chain wordAtIndex: indexPath.row];
    }
    else {
        cell.textLabel.text = @"Puzzle could not be generated.";
    }
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(!chain) return;
    
    NSString *word = [chain wordAtIndex: indexPath.row];
    if([UIReferenceLibraryViewController dictionaryHasDefinitionForTerm: word]) {
        UIReferenceLibraryViewController * controller =
            [[UIReferenceLibraryViewController alloc] initWithTerm: word];
        [self presentViewController: controller animated: YES completion:^{
            // ?
        }];
    }
}

- (IBAction)onNewPuzzle:(id)sender {
    [self loadPuzzle];
}
@end
