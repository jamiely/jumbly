//
//  EntryTableCell.m
//  Jumbly
//
//  Created by Jamie Ly on 20/10/2012.
//  Copyright (c) 2012 Jamie Ly. All rights reserved.
//

#import "EntryTableCell.h"

const NSInteger ENTRYTABLECELL_PADDING = 10;
const NSInteger ENTRYTABLECELL_PADDING_HORIZONTAL = 100;

@interface EntryTableCell(){
    UIFont *boldFont;
    UIFont *italicFont;
}

@end

@implementation EntryTableCell

@synthesize textField;
@synthesize validWord;
@synthesize infoButton;
@synthesize textLabel;
@synthesize locked;
@synthesize word;
@synthesize validNeighbor;

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

- (CGRect) controlFrame: (CGRect) baseFrame {
    CGRect frame = baseFrame;
    frame.origin = CGPointMake(ENTRYTABLECELL_PADDING_HORIZONTAL, ENTRYTABLECELL_PADDING);
    frame.size.height -= ENTRYTABLECELL_PADDING*2;
    frame.size.width -= ENTRYTABLECELL_PADDING_HORIZONTAL*2;
    
    return frame;
}

- (void) initialize: (CGRect) frame {
    boldFont = [UIFont boldSystemFontOfSize: [UIFont labelFontSize]];
    italicFont = [UIFont italicSystemFontOfSize: [UIFont labelFontSize]];
    
    CGRect textFrame = [self controlFrame: frame];
    textField = [[UITextField alloc] initWithFrame: textFrame];
    
    textField.textAlignment = NSTextAlignmentCenter;
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.font = boldFont;
    textField.textColor = [UIColor whiteColor];
    [self addSubview: textField];
    
    textLabel = [[UILabel alloc] initWithFrame: textFrame];
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.font = [UIFont boldSystemFontOfSize: [UIFont labelFontSize]];
    textLabel.hidden = YES;
    textLabel.textColor = [UIColor whiteColor];
    textLabel.backgroundColor = [UIColor clearColor];
    [self addSubview: textLabel];
    
    self.selectedBackgroundView = nil;
    self.backgroundView = nil;
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSeparatorStyleNone;
    
    infoButton = [UIButton buttonWithType: UIButtonTypeInfoLight];
    CGRect buttonFrame = infoButton.frame;
    buttonFrame.origin = CGPointMake(ENTRYTABLECELL_PADDING,
                                     textFrame.size.height / 2.0f);
    infoButton.frame = buttonFrame;
    [self.contentView addSubview: infoButton];
}

- (void) setValidWord:(BOOL)aValidWord {
    validWord = aValidWord;
    self.accessoryType = validWord ? UITableViewCellAccessoryCheckmark :
        UITableViewCellAccessoryNone;
    textField.textColor = validWord ?
        [UIColor whiteColor] : [UIColor redColor];
}

- (void) setValidNeighbor:(BOOL)aValidNeighbor {
    validNeighbor = aValidNeighbor;
    textField.font = validNeighbor ? boldFont : italicFont;
}

- (void) setLocked: (BOOL) value {
    locked = value;
    textField.hidden = locked;
    textLabel.hidden = !locked;
}

- (void) setWord:(NSString *)aWord {
    word = aWord;
    textField.text = word;
    textLabel.text = word;
}

- (void)setNeedsLayout {
    CGRect frame = [self controlFrame: self.frame];
    textField.frame = frame;
    textLabel.frame = frame;
}

@end
