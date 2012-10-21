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
    UIImage *defineImage;
}
@end

@implementation PuzzleViewController

@synthesize jumble;

- (void)viewDidLoad
{
    [super viewDidLoad];
    defineImage = [UIImage imageNamed:@"define.png"];
    [self.gestureRecognizer addTarget:self action:@selector(onDefine:)];
    self.gestureRecognizer.delegate = self;
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
    EntryTableCell *cell = cell = [tableView dequeueReusableCellWithIdentifier:@"EntryTableCell"];
    
    if(chain) {
        NSInteger row = indexPath.row;
        if(![self isGuessRow: indexPath]) {
            cell.word = [chain wordAtIndex: indexPath.row];
            cell.infoButton.tag = indexPath.row;
            [cell.infoButton addTarget:self action:@selector(onDefine:) forControlEvents:UIControlEventTouchUpInside];
            cell.infoButton.hidden = NO;
            cell.locked = YES;
        }
        else {
            NSInteger guessRow = row - 1;
            Guess *guess = [guesses objectAtIndex: guessRow];
            
            cell.textField.delegate = self;
            
            NSString *previousWord = [self wordBeforeIndexPath: indexPath];
            
            cell.validWord = [self wordIsDefined: guess.word] &&
                [jumble word: guess.word isNeighborOf: previousWord];
            
            cell.word = guess.word;
            cell.infoButton.hidden = YES;
            if([self wordIsDefined: guess.word]) {
                cell.infoButton.tag = indexPath.row;
                [cell.infoButton addTarget:self action:@selector(onDefine:) forControlEvents:UIControlEventTouchUpInside];
                cell.infoButton.hidden = NO;
            }
            cell.locked = NO;
            [self bindTextField: cell.textField toGuess: guess];
        }
    }
    else {
        cell.word = @"Generating...";
        cell.locked = YES;
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

- (void) showDefinition: (NSString*) word {
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

- (void)onDefine:(id)sender {
    NSInteger row = [sender tag];
    NSString *word = [self wordAtIndexPath: [NSIndexPath indexPathForItem:row
                                                                inSection:0]];
    [self showDefinition: word];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if([textField.text isEqualToString: @"?"]) {
        textField.text = @"";
    }
    return YES;
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [self evaluateTextFieldGuess: textField];
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self evaluateTextFieldGuess: textField];
}

- (void) evaluateTextFieldGuess:(UITextField *)textField {
    Guess *guess = [self guessBoundToTextField: textField];
    if([textField.text isEqualToString: @""]) {
        guess.word = @"?";
    }
    else {
        guess.word = textField.text;
    }
    [self.tableView reloadData];
    [self evaluateWin];
}

- (void) evaluateWin {
    if([self hasWon]) {
        [[[UIAlertView alloc] initWithTitle: @"Won" message: @"You won" delegate: nil cancelButtonTitle: @"OK" otherButtonTitles:nil ] show];
    }
}

- (NSArray*) enteredWords {
    if(!chain) return @[];
    
    NSMutableArray *words = [NSMutableArray array];
    [words addObject: [chain firstWord]];
    [guesses enumerateObjectsUsingBlock:^(Guess *guess, NSUInteger idx, BOOL *stop) {
        [words addObject: guess.word];
    }];
    [words addObject: [chain lastWord]];
    return words;
}

- (BOOL) hasWon {
    NSArray * words = [self enteredWords];
    BOOL won = YES;
    NSString * lastWord = [words objectAtIndex: 0];
    for(NSInteger i = 1, c = words.count; i < c; i ++) {
        NSString * word = [words objectAtIndex: i];
        won = won
            && ! [word isEqualToString: lastWord]
            && [jumble word: lastWord isNeighborOf: word]
            && [self wordIsDefined: word];
        lastWord = word;
    }
    return won;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return YES;
}

@end
