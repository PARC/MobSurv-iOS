//
//  MSURVQuestionText7OptionView.m
//  MobSurv
//
//  Created by Michael Youngblood on 9/12/15.
//  Copyright (c) 2015 PARC. All rights reserved.
//

#import "MSURVQuestionText7OptionView.h"
#import "Logging.h"
#import "globals.h"

#import <AudioToolbox/AudioToolbox.h>
#import "UIImage+ResizeMagick.h"
#import "DLAVAlertView.h"

#import "MSURVParseHelper.h"

@interface MSURVQuestionText7OptionView ()

@property BOOL statusBtn1;
@property BOOL statusBtn2;
@property BOOL statusBtn3;
@property BOOL statusBtn4;
@property BOOL statusBtn5;
@property BOOL statusBtn6;
@property BOOL statusBtn7;

@property int question;

@end

//******************* IMPLEMENTATION ********************


@implementation MSURVQuestionText7OptionView

MSURVSurveyViewController *caller;

-(MSURVQuestionText7OptionView *) init{
    MSURVQuestionText7OptionView *result = nil;
    NSArray* elements = [[NSBundle mainBundle] loadNibNamed: NSStringFromClass([self class]) owner:self options: nil];
    for (id anObject in elements)
    {
        if ([anObject isKindOfClass:[self class]])
        {
            result = anObject;
            break;
        }
    }
    
    caller = nil;
    
    LogDebug(@">>>>>>>>>>>>>>> Creating a Text 7-Option View");
    
    // For grid and scroll questions
    self.statusBtn1 = NO;
    self.statusBtn2 = NO;
    self.statusBtn3 = NO;
    self.statusBtn4 = NO;
    self.statusBtn5 = NO;
    self.statusBtn6 = NO;
    self.statusBtn7 = NO;
    
    return result;
}

// Initial loading of button images
//
- (void)displayText7OptionFor:(PFObject *)question from:(MSURVSurveyViewController*)sender forQuestion:(int)q{
    
    caller = sender;
    self.question = q;
    
    // Make all buttons invisible first
    self.gridButton1.hidden = YES;
    self.gridButton2.hidden = YES;
    self.gridButton3.hidden = YES;
    self.gridButton4.hidden = YES;
    self.gridButton5.hidden = YES;
    self.gridButton6.hidden = YES;
    self.gridButton7.hidden = YES;
    
    self.firstText1.text = question[@"firstText"];
    [self.gridButton1 setTitle:question[@"button1text"] forState:UIControlStateNormal];
    [self.gridButton2 setTitle:question[@"button2text"] forState:UIControlStateNormal];
    [self.gridButton3 setTitle:question[@"button3text"] forState:UIControlStateNormal];
    [self.gridButton4 setTitle:question[@"button4text"] forState:UIControlStateNormal];
    [self.gridButton5 setTitle:question[@"button5text"] forState:UIControlStateNormal];
    [self.gridButton6 setTitle:question[@"button6text"] forState:UIControlStateNormal];
    [self.gridButton7 setTitle:question[@"button7text"] forState:UIControlStateNormal];
    
    // Make them visible again
    if (![self.gridButton1.titleLabel.text isEqual:@"blank"]) self.gridButton1.hidden = NO;
    if (![self.gridButton2.titleLabel.text isEqual:@"blank"]) self.gridButton2.hidden = NO;
    if (![self.gridButton3.titleLabel.text isEqual:@"blank"]) self.gridButton3.hidden = NO;
    if (![self.gridButton4.titleLabel.text isEqual:@"blank"]) self.gridButton4.hidden = NO;
    if (![self.gridButton5.titleLabel.text isEqual:@"blank"]) self.gridButton5.hidden = NO;
    if (![self.gridButton6.titleLabel.text isEqual:@"blank"]) self.gridButton6.hidden = NO;
    if (![self.gridButton7.titleLabel.text isEqual:@"blank"]) self.gridButton7.hidden = NO;
}

- (void)updateSelectedStatusImage {
    
    if (self.statusBtn1 == NO) {
        [self.gridButton1 setTitleColor:[UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:1.0] forState:UIControlStateNormal];
    }
    else {
        [self.gridButton1 setTitleColor:[UIColor colorWithRed:0 / 255.0 green:153 / 255.0 blue:0 / 255.0 alpha:1.0] forState:UIControlStateNormal];
    }
    
    if (self.statusBtn2 == NO) {
        [self.gridButton2 setTitleColor:[UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:1.0] forState:UIControlStateNormal];
    }
    else {
        [self.gridButton2 setTitleColor:[UIColor colorWithRed:0 / 255.0 green:153 / 255.0 blue:0 / 255.0 alpha:1.0] forState:UIControlStateNormal];
    }
    
    if (self.statusBtn3 == NO) {
        [self.gridButton3 setTitleColor:[UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:1.0] forState:UIControlStateNormal];
    }
    else {
        [self.gridButton3 setTitleColor:[UIColor colorWithRed:0 / 255.0 green:153 / 255.0 blue:0 / 255.0 alpha:1.0] forState:UIControlStateNormal];
    }
    
    if (self.statusBtn4 == NO) {
        [self.gridButton4 setTitleColor:[UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:1.0] forState:UIControlStateNormal];
    }
    else {
        [self.gridButton4 setTitleColor:[UIColor colorWithRed:0 / 255.0 green:153 / 255.0 blue:0 / 255.0 alpha:1.0] forState:UIControlStateNormal];
    }
    
    if (self.statusBtn5 == NO) {
        [self.gridButton5 setTitleColor:[UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:1.0] forState:UIControlStateNormal];
    }
    else {
        [self.gridButton5 setTitleColor:[UIColor colorWithRed:0 / 255.0 green:153 / 255.0 blue:0 / 255.0 alpha:1.0] forState:UIControlStateNormal];
    }
    
    if (self.statusBtn6 == NO) {
        [self.gridButton6 setTitleColor:[UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:1.0] forState:UIControlStateNormal];
    }
    else {
        [self.gridButton6 setTitleColor:[UIColor colorWithRed:0 / 255.0 green:153 / 255.0 blue:0 / 255.0 alpha:1.0] forState:UIControlStateNormal];
    }

    if (self.statusBtn7 == NO) {
        [self.gridButton7 setTitleColor:[UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:1.0] forState:UIControlStateNormal];
    }
    else {
        [self.gridButton7 setTitleColor:[UIColor colorWithRed:0 / 255.0 green:153 / 255.0 blue:0 / 255.0 alpha:1.0] forState:UIControlStateNormal];
    }
    
    if (!(self.statusBtn1 == YES || self.statusBtn2 == YES || self.statusBtn3 == YES ||
          self.statusBtn4 == YES || self.statusBtn5 == YES || self.statusBtn6 == YES || self.statusBtn7 == YES)) {
        [caller setNextButtonRed];
    }
    else {
        [caller setNextButtonGreen];
    }
}

// ****************************************** Grid Button Handling

-(void)updateValues {
    NSMutableArray *myArray = [NSMutableArray new];
    [myArray addObject:[NSNumber numberWithBool:self.statusBtn1]];
    [myArray addObject:[NSNumber numberWithBool:self.statusBtn2]];
    [myArray addObject:[NSNumber numberWithBool:self.statusBtn3]];
    [myArray addObject:[NSNumber numberWithBool:self.statusBtn4]];
    [myArray addObject:[NSNumber numberWithBool:self.statusBtn5]];
    [myArray addObject:[NSNumber numberWithBool:self.statusBtn6]];
    [myArray addObject:[NSNumber numberWithBool:self.statusBtn7]];
    //NSArray *anArray = myArray;
    [caller update7ButtonValues:myArray];
}

//
// Image 1 Handling...
//
- (IBAction)gridButton1Pressed:(id)sender {
    LogDebug(@"Button 1 single tap.");
    if (self.statusBtn1 == NO) {
        self.statusBtn1 = YES;
        self.statusBtn2 = NO;
        self.statusBtn3 = NO;
        self.statusBtn4 = NO;
        self.statusBtn5 = NO;
        self.statusBtn6 = NO;
        self.statusBtn7 = NO;
        [MSURVParseHelper LogParse:self.question withNumberResponse:1 andType:1];
    }
    else {
        self.statusBtn1 = NO;
        [MSURVParseHelper LogParse:self.question withNumberResponse:0 andType:1];
    }
    
    [self updateValues];
    [self updateSelectedStatusImage];
}

//
// Image 2 Handling...
//
- (IBAction)gridButton2Pressed:(id)sender {
    LogDebug(@"Button 2 single tap.");
    if (self.statusBtn2 == NO) {
        self.statusBtn1 = NO;
        self.statusBtn2 = YES;
        self.statusBtn3 = NO;
        self.statusBtn4 = NO;
        self.statusBtn5 = NO;
        self.statusBtn6 = NO;
        self.statusBtn7 = NO;
        [MSURVParseHelper LogParse:self.question withNumberResponse:2 andType:1];
    }
    else {
        self.statusBtn2 = NO;
        [MSURVParseHelper LogParse:self.question withNumberResponse:0 andType:1];
    }
    
    [self updateValues];
    [self updateSelectedStatusImage];
}

//
// Image 3 Handling...
//
- (IBAction)gridButton3Pressed:(id)sender {
    LogDebug(@"Button 3 single tap.");
    if (self.statusBtn3 == NO) {
        self.statusBtn1 = NO;
        self.statusBtn2 = NO;
        self.statusBtn3 = YES;
        self.statusBtn4 = NO;
        self.statusBtn5 = NO;
        self.statusBtn6 = NO;
        self.statusBtn7 = NO;
        [MSURVParseHelper LogParse:self.question withNumberResponse:3 andType:1];
    }
    else {
        self.statusBtn3 = NO;
        [MSURVParseHelper LogParse:self.question withNumberResponse:0 andType:1];
    }
    
    [self updateValues];
    [self updateSelectedStatusImage];
}

//
// Image 4 Handling...
//
- (IBAction)gridButton4Pressed:(id)sender {
    LogDebug(@"Button 4 single tap.");
    if (self.statusBtn4 == NO) {
        self.statusBtn1 = NO;
        self.statusBtn2 = NO;
        self.statusBtn3 = NO;
        self.statusBtn4 = YES;
        self.statusBtn5 = NO;
        self.statusBtn6 = NO;
        self.statusBtn7 = NO;
        [MSURVParseHelper LogParse:self.question withNumberResponse:4 andType:1];
    }
    else {
        self.statusBtn4 = NO;
        [MSURVParseHelper LogParse:self.question withNumberResponse:0 andType:1];
    }
    
    [self updateValues];
    [self updateSelectedStatusImage];
}

//
// Image 5 Handling...
//
- (IBAction)gridButton5Pressed:(id)sender {
    LogDebug(@"Button 5 single tap.");
    if (self.statusBtn5 == NO) {
        self.statusBtn1 = NO;
        self.statusBtn2 = NO;
        self.statusBtn3 = NO;
        self.statusBtn4 = NO;
        self.statusBtn5 = YES;
        self.statusBtn6 = NO;
        self.statusBtn7 = NO;
        [MSURVParseHelper LogParse:self.question withNumberResponse:5 andType:1];
    }
    else {
        self.statusBtn5 = NO;
        [MSURVParseHelper LogParse:self.question withNumberResponse:0 andType:1];
    }
    
    [self updateValues];
    [self updateSelectedStatusImage];
}

//
// Image 6 Handling...
//
- (IBAction)gridButton6Pressed:(id)sender {
    LogDebug(@"Button 6 single tap.");
    if (self.statusBtn6 == NO) {
        self.statusBtn1 = NO;
        self.statusBtn2 = NO;
        self.statusBtn3 = NO;
        self.statusBtn4 = NO;
        self.statusBtn5 = NO;
        self.statusBtn6 = YES;
        self.statusBtn7 = NO;
        [MSURVParseHelper LogParse:self.question withNumberResponse:6 andType:1];
    }
    else {
        self.statusBtn6 = NO;
        [MSURVParseHelper LogParse:self.question withNumberResponse:0 andType:1];
    }
    
    [self updateValues];
    [self updateSelectedStatusImage];
}

//
// Image 7 Handling...
//
- (IBAction)gridButton7Pressed:(id)sender {
    LogDebug(@"Button 6 single tap.");
    if (self.statusBtn7 == NO) {
        self.statusBtn1 = NO;
        self.statusBtn2 = NO;
        self.statusBtn3 = NO;
        self.statusBtn4 = NO;
        self.statusBtn5 = NO;
        self.statusBtn6 = NO;
        self.statusBtn7 = YES;
        [MSURVParseHelper LogParse:self.question withNumberResponse:7 andType:1];
    }
    else {
        self.statusBtn7 = NO;
        [MSURVParseHelper LogParse:self.question withNumberResponse:0 andType:1];
    }
    
    [self updateValues];
    [self updateSelectedStatusImage];
}

- (void)resetResponses {
    self.statusBtn1 = NO;
    self.statusBtn2 = NO;
    self.statusBtn3 = NO;
    self.statusBtn4 = NO;
    self.statusBtn5 = NO;
    self.statusBtn6 = NO;
    self.statusBtn7 = NO;
}

- (void)loadResponseFor:(NSInteger)selected {
    
    LogDebug(@">>>>> Setting number: %ld", (long)selected);
    
    self.statusBtn1 = NO;
    self.statusBtn2 = NO;
    self.statusBtn3 = NO;
    self.statusBtn4 = NO;
    self.statusBtn5 = NO;
    self.statusBtn6 = NO;
    self.statusBtn7 = NO;
    
    switch (selected) {
        case 1: self.statusBtn1 = YES;
            break;
            
        case 2: self.statusBtn2 = YES;
            break;
            
        case 3: self.statusBtn3 = YES;
            break;
            
        case 4: self.statusBtn4 = YES;
            break;
            
        case 5: self.statusBtn5 = YES;
            break;
            
        case 6: self.statusBtn6 = YES;
            break;
            
        case 7: self.statusBtn7 = YES;
            break;
    }
}

@end
