//
//  EntryTableCell.m
//  Jumbly
//
//  Created by Jamie Ly on 20/10/2012.
//  Copyright (c) 2012 Jamie Ly. All rights reserved.
//

#import "EntryTableCell.h"

@implementation EntryTableCell

@synthesize textField;
@synthesize validWord;
@synthesize infoButton;
@synthesize textLabel;
@synthesize locked;
@synthesize word;

- (id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder: aDecoder];
    if(self) {
        [self initialize: self.bounds];
    }
    return self;
}

- (id) initWithFrame:(CGRect)frame {
    self = [super initWithFrame: frame];
    if(self) {
        [self initialize: frame];
    }
    return self;
}

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        [self initialize: self.bounds];
    }
    return self;
}

- (void) initialize: (CGRect) frame {
    NSInteger padding = 10;
    NSInteger horizontalPadding = 100;
    frame.origin = CGPointMake(horizontalPadding, padding);
    frame.size.height -= padding*2;
    frame.size.width -= horizontalPadding*2;
    textField = [[UITextField alloc] initWithFrame: frame];
    
    textField.textAlignment = NSTextAlignmentCenter;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.font = [UIFont boldSystemFontOfSize: [UIFont labelFontSize]];
    [self addSubview: textField];
    
    textLabel = [[UILabel alloc] initWithFrame: frame];
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.font = [UIFont boldSystemFontOfSize: [UIFont labelFontSize]];
    textLabel.hidden = YES;
    textLabel.backgroundColor = [UIColor clearColor];
    [self addSubview: textLabel];
    
    self.selectedBackgroundView = nil;
    self.backgroundView = nil;
    self.selectionStyle = UITableViewCellSeparatorStyleNone;
    
    infoButton = [UIButton buttonWithType: UIButtonTypeInfoDark];
    CGRect buttonFrame = infoButton.frame;
    buttonFrame.origin = CGPointMake(padding, frame.size.height / 2.0f);
    infoButton.frame = buttonFrame;
    [self.contentView addSubview: infoButton];
}

- (void) setValidWord:(BOOL)aValidWord {
    validWord = aValidWord;
    self.accessoryType = validWord ? UITableViewCellAccessoryCheckmark :
        UITableViewCellAccessoryNone;
}

- (void) setLocked: (BOOL) value {
    locked = value;
    textField.hidden = locked;
    textLabel.hidden = !locked;
    self.backgroundColor = locked ? [UIColor yellowColor] : [UIColor whiteColor];
}

- (void) setWord:(NSString *)aWord {
    word = aWord;
    textField.text = word;
    textLabel.text = word;
}

@end
