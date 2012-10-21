//
//  PuzzleViewController.h
//  Jumbly
//
//  Created by Jamie Ly on 20/10/2012.
//  Copyright (c) 2012 Jamie Ly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Jumble.h"

@interface PuzzleViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) Jumble *jumble;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@end
