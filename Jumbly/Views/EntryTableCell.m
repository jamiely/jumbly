//
//  EntryTableCell.m
//  Jumbly
//
//  Created by Jamie Ly on 20/10/2012.
//  Copyright (c) 2012 Jamie Ly. All rights reserved.
//

#import "EntryTableCell.h"

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

- (void) initialize: (CGRect) frame {
    boldFont = [UIFont boldSystemFontOfSize: [UIFont labelFontSize]];
    italicFont = [UIFont italicSystemFontOfSize: [UIFont labelFontSize]];
    
    NSInteger padding = 10;
    NSInteger horizontalPadding = 100;
    frame.origin = CGPointMake(horizontalPadding, padding);
    frame.size.height -= padding*2;
    frame.size.width -= horizontalPadding*2;
    textField = [[UITextField alloc] initWithFrame: frame];
    
    textField.textAlignment = NSTextAlignmentCenter;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.font = boldFont;
    textField.textColor = [UIColor whiteColor];
    [self addSubview: textField];
    
    textLabel = [[UILabel alloc] initWithFrame: frame];
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
    buttonFrame.origin = CGPointMake(padding, frame.size.height / 2.0f);
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
    //self.backgroundColor = locked ? [UIColor yellowColor] : [UIColor whiteColor];
}

- (void) setWord:(NSString *)aWord {
    word = aWord;
    textField.text = word;
    textLabel.text = word;
}

@end
