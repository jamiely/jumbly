//
//  PuzzleViewController.m
//  Jumbly
//
//  Created by Jamie Ly on 20/10/2012.
//  Copyright (c) 2012 Jamie Ly. All rights reserved.
//

#import "PuzzleViewController.h"
#import "EntryTableCell.h"
#import "Guess.h"
#import <objc/runtime.h>

@interface PuzzleViewController () {
    Chain *chain;
    NSArray *guesses;
}
@end

@implementation PuzzleViewController

@synthesize jumble;

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear: animated];
    if(!chain) {
        [self loadPuzzle];
    }
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
    
    if(chain) {
        NSInteger count = chain.count;
        NSMutableArray *_guesses = [NSMutableArray arrayWithCapacity: count-2];
        for(NSInteger i = 0, c = count-2; i < c; i++) {
            Guess *guess = [[Guess alloc] init];
            guess.word = @"?";
            [_guesses addObject: guess];
        }
        guesses = [NSArray arrayWithArray:_guesses];
    }
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

- (NSString*) wordAtIndexPath: (NSIndexPath*) ip {
    if([self isGuessRow: ip]) {
        return [[guesses objectAtIndex: ip.row - 1] word];
    }
    else {
        return [chain wordAtIndex: ip.row];
    }
}

- (NSString*) wordBeforeIndexPath: (NSIndexPath*) ip {
    return [self wordAtIndexPath:
            [NSIndexPath indexPathForRow: ip.row - 1 inSection: ip.section]];
}

- (UITableViewCell*) tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    
    if(chain) {
        NSInteger row = indexPath.row;
        if(![self isGuessRow: indexPath]) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"StandardTableCell"];
            cell.textLabel.text = [chain wordAtIndex: indexPath.row];
        }
        else {
            NSInteger guessRow = row - 1;
            Guess *guess = [guesses objectAtIndex: guessRow];
            
            cell = [tableView dequeueReusableCellWithIdentifier:@"EntryTableCell"];
            //cell.textLabel.text = @"?";
            EntryTableCell *entryCell = (EntryTableCell *) cell;
            entryCell.textField.delegate = self;
            
            NSString *previousWord = [self wordBeforeIndexPath: indexPath];
            
            entryCell.validWord = [self wordIsDefined: guess.word] &&
                [jumble word: guess.word isNeighborOf: previousWord];
            
            entryCell.textField.text = guess.word;
            
            [self bindTextField: entryCell.textField toGuess: guess];
        }
    }
    else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"StandardTableCell"];
        cell.textLabel.text = @"Puzzle could not be generated.";
    }
    
    return cell;
}

- (char*) guessKey {
    static char _guessKey;
    return &_guessKey;
}

- (void) bindTextField: (UITextField*) field toGuess: (Guess*) guess {
    objc_setAssociatedObject(field, [self guessKey], guess, OBJC_ASSOCIATION_RETAIN);
}

- (Guess*) guessBoundToTextField: (UITextField*) field {
    return objc_getAssociatedObject(field, [self guessKey]);
}

- (BOOL) isGuessRow: (NSIndexPath*) ip {
    NSInteger row = ip.row;
    return !(row == 0 || row == chain.count - 1);
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(!chain) return;
    
    NSString *word = [self wordAtIndexPath: indexPath];
    
    if([self wordIsDefined: word]) {
        UIReferenceLibraryViewController * controller =
            [[UIReferenceLibraryViewController alloc] initWithTerm: word];
        [self presentViewController: controller animated: YES completion:^{
            // ?
        }];
    }
}

- (BOOL) wordIsDefined: (NSString*) word {
    return [UIReferenceLibraryViewController dictionaryHasDefinitionForTerm: word];
}

- (IBAction)onNewPuzzle:(id)sender {
    [self loadPuzzle];
}

- (IBAction)onShowSolution:(id)sender {
    for(NSInteger i = 0, c = guesses.count; i < c; i ++) {
        Guess *guess = [guesses objectAtIndex: i];
        guess.word = [chain wordAtIndex: i+1];
    }
    [self.tableView reloadData];
}

- (IBAction)onQuit:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
       // none
    }];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if([textField.text isEqualToString: @"?"]) {
        textField.text = @"";
    }
    return YES;
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    // @todo, check here if the word is valid and show a checkmark if the word is valid
    
    Guess *guess = [self guessBoundToTextField: textField];
    if([textField.text isEqualToString: @""]) {
        guess.word = @"?";
    }
    else {
        guess.word = textField.text;
    }
    [self.tableView reloadData];
    
    return YES;
}

@end
