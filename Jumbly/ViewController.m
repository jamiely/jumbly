//
//  ViewController.m
//  Jumbly
//
//  Created by Jamie Ly on 20/10/2012.
//  Copyright (c) 2012 Jamie Ly. All rights reserved.
//

#import "ViewController.h"
#import "Jumble.h"
#import "PuzzleViewController.h"

@interface ViewController () {
    Jumble *jumble;
    NSArray *rows;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	jumble = [[Jumble alloc] init];
    rows = @[@"Puzzle", @"Options", @"Contact"];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    id controller = segue.destinationViewController;
    if([controller respondsToSelector: @selector(setJumble:)]) {
        [controller setJumble: jumble];
    }
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return rows.count;
}

- (UITableViewCell*) tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StandardTableCell"];
    cell.textLabel.text = [rows objectAtIndex: indexPath.row];
    return cell;
}

- (void) tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch(indexPath.row) {
        case 0: {
            [self performSegueWithIdentifier:@"PuzzleSegue" sender:self];
            break;
        }
    }
}

@end
