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
#import "ChainQueue.h"
#import <objc/runtime.h>

@interface PuzzleViewController () {
    Chain *chain;
    NSMutableArray *guesses;
    UIImage *defineImage;
    UITextField *activeTextField;
    UIPopoverController *popover;
    UIReferenceLibraryViewController * dictionaryController;
    BOOL requiresReset;
}
@end

@implementation PuzzleViewController

@synthesize jumble;

- (void)viewDidLoad
{
    [super viewDidLoad];
    defineImage = [UIImage imageNamed:@"define.png"];
    [self.gestureRecognizer addTarget:self action:@selector(touchOut:)];
    self.gestureRecognizer.delegate = self;
    [self.view addGestureRecognizer: self.gestureRecognizer];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundView = nil;
    
    self.activityIndicator.color = [UIColor whiteColor];
    
    requiresReset = NO;
    [self.tableView setEditing:YES animated:NO];
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
        CGRect indicatorFrame = self.activityIndicator.frame;
        // put it in the upper right
        indicatorFrame.origin.x = self.view.frame.size.width - indicatorFrame.size.width;
        self.activityIndicator.frame = indicatorFrame;
        [self.activityIndicator startAnimating];
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        [self loadChain];
        if(chain) {
            [self.activityIndicator removeFromSuperview];
            [self.activityIndicator stopAnimating];
            
            self.puzzleLabel.text = [NSString stringWithFormat:@"Puzzle: %@ ... %@",
                                     chain.firstWord, chain.lastWord];
            
            self.debugTextView.text = [NSString stringWithFormat:@"Debug: %@",
                                       [chain.words componentsJoinedByString:@","]];
        }
        else {
            [self loadPuzzle];
        }
    });
}

- (void) loadChain {
    chain = [[ChainQueue mainQueue] nextChain];
    
    if(chain) {
        NSInteger count = chain.count;
        NSMutableArray *_guesses = [NSMutableArray arrayWithCapacity: count-2];
        for(NSInteger i = 0, c = count-2; i < c; i++) {
            Guess *guess = [[Guess alloc] init];
            guess.word = @"?";
            [_guesses addObject: guess];
        }
        guesses = [NSMutableArray arrayWithArray:_guesses];
    }
    // @todo, it's possible for this to be blank
    // @todo, add an activity indicator
    [self.tableView reloadData];
}

#pragma mark - UITable delegate/datasource functions

-(UITableViewCellEditingStyle) tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleNone;
}

- (BOOL) tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self isGuessRow: indexPath] && ![[guesses objectAtIndex: indexPath.row - 1] hint];
}

- (void) tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    NSInteger sourceRow = sourceIndexPath.row - 1;
    NSInteger destRow = destinationIndexPath.row - 1;
    id object = [guesses objectAtIndex:sourceRow];
    
    [guesses removeObjectAtIndex:sourceRow];
    [guesses insertObject:object atIndex:destRow];
    
    [self.tableView reloadData];
}

- (NSIndexPath*) guessIndextoIndexPath: (NSUInteger) row {
    return [NSIndexPath indexPathForItem: row+1 inSection:0];
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

- (NSString*) wordAfterIndexPath: (NSIndexPath*) ip {
    return [self wordAtIndexPath:
            [NSIndexPath indexPathForRow: ip.row + 1 inSection: ip.section]];
}

#pragma mark - Table Delegate functions

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [activeTextField resignFirstResponder];
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
            NSString *nextWord = [self wordAfterIndexPath: indexPath];
            
            if([guess.word isEqualToString: @"?"]) {
                cell.validWord = YES;
                cell.validNeighbor = YES;
            }
            else {
                cell.validWord = [self wordIsDefined: guess.word];
                cell.validNeighbor = (
                    [previousWord isEqualToString: @"?"] ||
                        [jumble word: guess.word isNeighborOf: previousWord]) &&
                    ([nextWord isEqualToString: @"?"] ||
                        [jumble word: guess.word isNeighborOf: nextWord]);
            }
            cell.word = guess.word;
            cell.infoButton.hidden = YES;
            if([self wordIsDefined: guess.word]) {
                cell.infoButton.tag = indexPath.row;
                [cell.infoButton addTarget:self action:@selector(onDefine:) forControlEvents:UIControlEventTouchUpInside];
                cell.infoButton.hidden = NO;
            }
            cell.locked = guess.hint;
            [self bindTextField: cell.textField toGuess: guess];
        }
    }
    else {
        cell.word = @"Generating...";
        cell.locked = YES;
        cell.infoButton.hidden = YES;
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
    [self showDefinition: word withRect: CGRectMake(10, 10, 10, 10)];
}

- (void) showDefinition: (NSString*) word withRect: (CGRect) wordRect {
    if([self wordIsDefined: word]) {
        dictionaryController =
        [[UIReferenceLibraryViewController alloc] initWithTerm: word];
        
        if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
            popover = [[UIPopoverController alloc] initWithContentViewController: dictionaryController];
            [popover presentPopoverFromRect: wordRect inView: self.view
                   permittedArrowDirections: UIPopoverArrowDirectionAny
                                   animated: YES];
        }
        else {
            [self presentViewController: dictionaryController
                               animated: YES completion: nil];
        }
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
        guess.hint = YES;
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
    CGRect wordRect = CGRectMake(0, 0, 30, 30);
    UIView *aInfoButton = [sender superview];
    UIView *aTableCell = [aInfoButton superview];

    wordRect.origin = [self.view convertPoint: aInfoButton.frame.origin fromView:aTableCell];
    
    [self showDefinition: word withRect: wordRect];
}

#pragma mark - Text Field Delegate functions

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if([textField.text isEqualToString: @"?"]) {
        textField.text = @"";
    }
    activeTextField = textField;
    return YES;
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [self evaluateTextFieldGuess: textField];
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    [textField resignFirstResponder];
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
    NSUInteger guessIndex = [guesses indexOfObject: guess];
    [self.tableView reloadRowsAtIndexPaths: @[[self guessIndextoIndexPath: guessIndex]]
                          withRowAnimation: UITableViewRowAnimationNone];
    [self evaluateWin];
}

- (void) evaluateWin {
    if([self hasWon]) {
        if(!requiresReset) {
            [[[UIAlertView alloc] initWithTitle: @"Won" message: @"You won" delegate: self cancelButtonTitle: @"OK" otherButtonTitles:nil ] show];
            requiresReset = YES;
        }
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

- (void)touchOut:(id)sender {
    if(activeTextField) {
        [activeTextField resignFirstResponder];
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return YES;
}

#pragma mark - Alert View Delegate functions

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    requiresReset = NO;
    [self loadPuzzle];
}

@end
