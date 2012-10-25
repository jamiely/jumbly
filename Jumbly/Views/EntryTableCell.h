//
//  EntryTableCell.h
//  Jumbly
//
//  Created by Jamie Ly on 20/10/2012.
//  Copyright (c) 2012 Jamie Ly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EntryTableCell : UITableViewCell
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, copy) NSString* word;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, assign) BOOL validWord;
@property (nonatomic, assign) BOOL validNeighbor;
@property (nonatomic, strong) UIButton *infoButton;
@property (nonatomic, assign) BOOL locked;
@end
