//
//  ViewController.h
//  Jumbly
//
//  Created by Jamie Ly on 20/10/2012.
//  Copyright (c) 2012 Jamie Ly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface ViewController : UIViewController <UITableViewDataSource,
    UITableViewDelegate, MFMailComposeViewControllerDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
