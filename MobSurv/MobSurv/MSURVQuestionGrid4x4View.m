//
//  MSURVQuestionGrid4x4View.m
//  MobSurv
//
//  Created by Michael Youngblood on 9/12/15.
//  Copyright (c) 2015 PARC. All rights reserved.
//

#import "MSURVQuestionGrid4x4View.h"
#import "Logging.h"
#import "globals.h"

#import <AudioToolbox/AudioToolbox.h>
#import "UIImage+ResizeMagick.h"
#import "DLAVAlertView.h"

#import "MSURVParseHelper.h"

@interface MSURVQuestionGrid4x4View ()

@property int question;

@property BOOL statusBtn1;
@property BOOL statusBtn2;
@property BOOL statusBtn3;
@property BOOL statusBtn4;
@property BOOL statusBtn5;
@property BOOL statusBtn6;
@property BOOL statusBtn7;
@property BOOL statusBtn8;
@property BOOL statusBtn9;
@property BOOL statusBtn10;
@property BOOL statusBtn11;
@property BOOL statusBtn12;
@property BOOL statusBtn13;
@property BOOL statusBtn14;
@property BOOL statusBtn15;
@property BOOL statusBtn16;
@property BOOL statusBtn17;

@property UIImage *image1;
@property UIImage *image2;
@property UIImage *image3;
@property UIImage *image4;
@property UIImage *image5;
@property UIImage *image6;
@property UIImage *image7;
@property UIImage *image8;
@property UIImage *image9;
@property UIImage *image10;
@property UIImage *image11;
@property UIImage *image12;
@property UIImage *image13;
@property UIImage *image14;
@property UIImage *image15;
@property UIImage *image16;

@end

//******************* IMPLEMENTATION ********************

@implementation MSURVQuestionGrid4x4View

MSURVSurveyViewController *caller;

-(MSURVQuestionGrid4x4View *) init{
    MSURVQuestionGrid4x4View *result = nil;
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
    
    LogDebug(@">>>>>>>>>>>>>>> Creating a Grid 4x4 View");
    
    return result;
}

- (void)display4x4For:(PFObject *)info from:(MSURVSurveyViewController*)sender forQuestion:(int)q {
    
    caller = sender;
    self.question = q;
    
    // Make all buttons invisible first
    self.fourByFourButton1.hidden = YES;
    self.fourByFourButton2.hidden = YES;
    self.fourByFourButton3.hidden = YES;
    self.fourByFourButton4.hidden = YES;
    self.fourByFourButton5.hidden = YES;
    self.fourByFourButton6.hidden = YES;
    self.fourByFourButton7.hidden = YES;
    self.fourByFourButton8.hidden = YES;
    self.fourByFourButton9.hidden = YES;
    self.fourByFourButton10.hidden = YES;
    self.fourByFourButton11.hidden = YES;
    self.fourByFourButton12.hidden = YES;
    self.fourByFourButton13.hidden = YES;
    self.fourByFourButton14.hidden = YES;
    self.fourByFourButton15.hidden = YES;
    self.fourByFourButton16.hidden = YES;
    //self.fourByFourButton17.hidden = YES;
    
    // Need to attach the 16 grid images to the buttons
    NSString *objId = info.objectId;
    LogDebug(@"4x4 loading images for question %@", objId);
    
    PFQuery *query = [PFQuery queryWithClassName:@"GridImages"];
    [query whereKey:@"uniqueName" equalTo:objId];
    
    [query findObjectsInBackgroundWithBlock: ^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            LogDebug(@"Successfully retrieved %lu image references.", (unsigned long)objects.count);
            // Do something with the found objects
            for (PFObject * object in objects) {
                LogDebug(@"%@", object.objectId);
            }
            [self loadImagesIntoButtonsFor4x4:objects];
        }
        else {
            // Log details of the failure
            LogDebug(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
    self.firstText5.text = info[@"firstText"];
}

- (void)loadIntoButton:(UIButton *)aButton anImage:(PFFile *)imageObject {
    [imageObject
     getDataInBackgroundWithBlock: ^(NSData *imageData, NSError *error) {
         if (!error) {
             UIImage *image = [UIImage imageWithData:imageData];
             LogDebug(@"...File description %@", image.description);
             
             [[aButton imageView] setContentMode:UIViewContentModeScaleAspectFit];
             [aButton setBackgroundImage:image
                                forState:UIControlStateNormal];
             
             aButton.hidden = NO;
         }
         else {
             // Log details of the failure
             LogDebug(@"Error: %@ %@", error, [error userInfo]);
         }
     }];
}

- (void)loadImagesIntoButtonsFor4x4:(NSArray *)objects {
    for (PFObject *object in objects) {
        NSInteger order = [object[@"order"] integerValue] + 1;
        
        switch (order) {
            case 1:[self loadIntoButton:self.fourByFourButton1 anImage:object[@"image"]];
                LogDebug(@"-- 1 Loading image into button");
                break;
                
            case 2:[self loadIntoButton:self.fourByFourButton2 anImage:object[@"image"]];
                LogDebug(@"-- 2 Loading image into button");
                break;
                
            case 3:[self loadIntoButton:self.fourByFourButton3 anImage:object[@"image"]];
                LogDebug(@"-- 3 Loading image into button");
                break;
                
            case 4:[self loadIntoButton:self.fourByFourButton4 anImage:object[@"image"]];
                LogDebug(@"-- 4 Loading image into button");
                break;
                
            case 5:[self loadIntoButton:self.fourByFourButton5 anImage:object[@"image"]];
                LogDebug(@"-- 5 Loading image into button");
                break;
                
            case 6:[self loadIntoButton:self.fourByFourButton6 anImage:object[@"image"]];
                LogDebug(@"-- 6 Loading image into button");
                break;
                
            case 7:[self loadIntoButton:self.fourByFourButton7 anImage:object[@"image"]];
                LogDebug(@"-- 7 Loading image into button");
                break;
                
            case 8:[self loadIntoButton:self.fourByFourButton8 anImage:object[@"image"]];
                LogDebug(@"-- 8 Loading image into button");
                break;
                
            case 9:[self loadIntoButton:self.fourByFourButton9 anImage:object[@"image"]];
                LogDebug(@"-- 9 Loading image into button");
                break;
                
            case 10:[self loadIntoButton:self.fourByFourButton10 anImage:object[@"image"]];
                LogDebug(@"-- 10 Loading image into button");
                break;
                
            case 11:[self loadIntoButton:self.fourByFourButton11 anImage:object[@"image"]];
                LogDebug(@"-- 11 Loading image into button");
                break;
                
            case 12:[self loadIntoButton:self.fourByFourButton12 anImage:object[@"image"]];
                LogDebug(@"-- 12 Loading image into button");
                break;
                
            case 13:[self loadIntoButton:self.fourByFourButton13 anImage:object[@"image"]];
                LogDebug(@"-- 13 Loading image into button");
                break;
                
            case 14:[self loadIntoButton:self.fourByFourButton14 anImage:object[@"image"]];
                LogDebug(@"-- 14 Loading image into button");
                break;
                
            case 15:[self loadIntoButton:self.fourByFourButton15 anImage:object[@"image"]];
                LogDebug(@"-- 15 Loading image into button");
                break;
                
            case 16:[self loadIntoButton:self.fourByFourButton16 anImage:object[@"image"]];
                LogDebug(@"-- 16 Loading image into button");
                break;
        }
    }
}

- (void)updateSelectedFourByFourStatusImage {
    UIImage *anImage = [[UIImage imageNamed:@"cornerCheck"] resizedImageByMagick:@"65x65#"];
    
    LogDebug(@"updateSelectedFourByFourStatusImage");
    
    if (self.statusBtn1 == NO) {
        [self.fourByFourButton1 setImage:nil forState:UIControlStateNormal];
    }
    else {
        [self.fourByFourButton1 setImage:anImage forState:UIControlStateNormal];
    }
    
    if (self.statusBtn2 == NO) {
        [self.fourByFourButton2 setImage:nil forState:UIControlStateNormal];
    }
    else {
        [self.fourByFourButton2 setImage:anImage forState:UIControlStateNormal];
    }
    
    if (self.statusBtn3 == NO) {
        [self.fourByFourButton3 setImage:nil forState:UIControlStateNormal];
    }
    else {
        [self.fourByFourButton3 setImage:anImage forState:UIControlStateNormal];
    }
    
    if (self.statusBtn4 == NO) {
        [self.fourByFourButton4 setImage:nil forState:UIControlStateNormal];
    }
    else {
        [self.fourByFourButton4 setImage:anImage forState:UIControlStateNormal];
    }
    
    if (self.statusBtn5 == NO) {
        [self.fourByFourButton5 setImage:nil forState:UIControlStateNormal];
    }
    else {
        [self.fourByFourButton5 setImage:anImage forState:UIControlStateNormal];
    }
    
    if (self.statusBtn6 == NO) {
        [self.fourByFourButton6 setImage:nil forState:UIControlStateNormal];
    }
    else {
        [self.fourByFourButton6 setImage:anImage forState:UIControlStateNormal];
    }
    
    if (self.statusBtn7 == NO) {
        [self.fourByFourButton7 setImage:nil forState:UIControlStateNormal];
    }
    else {
        [self.fourByFourButton7 setImage:anImage forState:UIControlStateNormal];
    }
    
    if (self.statusBtn8 == NO) {
        [self.fourByFourButton8 setImage:nil forState:UIControlStateNormal];
    }
    else {
        [self.fourByFourButton8 setImage:anImage forState:UIControlStateNormal];
    }
    
    if (self.statusBtn9 == NO) {
        [self.fourByFourButton9 setImage:nil forState:UIControlStateNormal];
    }
    else {
        [self.fourByFourButton9 setImage:anImage forState:UIControlStateNormal];
    }
    
    if (self.statusBtn10 == NO) {
        [self.fourByFourButton10 setImage:nil forState:UIControlStateNormal];
    }
    else {
        [self.fourByFourButton10 setImage:anImage forState:UIControlStateNormal];
    }
    
    if (self.statusBtn11 == NO) {
        [self.fourByFourButton11 setImage:nil forState:UIControlStateNormal];
    }
    else {
        [self.fourByFourButton11 setImage:anImage forState:UIControlStateNormal];
    }
    
    if (self.statusBtn12 == NO) {
        [self.fourByFourButton12 setImage:nil forState:UIControlStateNormal];
    }
    else {
        [self.fourByFourButton12 setImage:anImage forState:UIControlStateNormal];
    }
    
    if (self.statusBtn13 == NO) {
        [self.fourByFourButton13 setImage:nil forState:UIControlStateNormal];
    }
    else {
        [self.fourByFourButton13 setImage:anImage forState:UIControlStateNormal];
    }
    
    if (self.statusBtn14 == NO) {
        [self.fourByFourButton14 setImage:nil forState:UIControlStateNormal];
    }
    else {
        [self.fourByFourButton14 setImage:anImage forState:UIControlStateNormal];
    }
    
    if (self.statusBtn15 == NO) {
        [self.fourByFourButton15 setImage:nil forState:UIControlStateNormal];
    }
    else {
        [self.fourByFourButton15 setImage:anImage forState:UIControlStateNormal];
    }
    
    if (self.statusBtn16 == NO) {
        [self.fourByFourButton16 setImage:nil forState:UIControlStateNormal];
    }
    else {
        [self.fourByFourButton16 setImage:anImage forState:UIControlStateNormal];
    }
    
    if (self.statusBtn17 == NO) {
        [self.fourByFourButton17 setTitleColor:[UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:1.0] forState:UIControlStateNormal];
    }
    else {
        [self.fourByFourButton17 setTitleColor:[UIColor colorWithRed:0 / 255.0 green:153 / 255.0 blue:0 / 255.0 alpha:1.0] forState:UIControlStateNormal];
    }
    
    if (!(self.statusBtn1 == YES || self.statusBtn2 == YES || self.statusBtn3 == YES ||
          self.statusBtn4 == YES || self.statusBtn5 == YES || self.statusBtn6 == YES ||
          self.statusBtn7 == YES || self.statusBtn8 == YES || self.statusBtn9 == YES ||
          self.statusBtn10 == YES || self.statusBtn11 == YES || self.statusBtn12 == YES ||
          self.statusBtn13 == YES || self.statusBtn14 == YES || self.statusBtn15 == YES ||
          self.statusBtn16 == YES || self.statusBtn17 == YES)) {
        [caller setNextButtonRed];
    }
    else {
        [caller setNextButtonGreen];
    }
}

-(void)updateValues {
    NSMutableArray *myArray = [NSMutableArray new];
    [myArray addObject:[NSNumber numberWithBool:self.statusBtn1]];
    [myArray addObject:[NSNumber numberWithBool:self.statusBtn2]];
    [myArray addObject:[NSNumber numberWithBool:self.statusBtn3]];
    [myArray addObject:[NSNumber numberWithBool:self.statusBtn4]];
    [myArray addObject:[NSNumber numberWithBool:self.statusBtn5]];
    [myArray addObject:[NSNumber numberWithBool:self.statusBtn6]];
    [myArray addObject:[NSNumber numberWithBool:self.statusBtn7]];
    [myArray addObject:[NSNumber numberWithBool:self.statusBtn8]];
    [myArray addObject:[NSNumber numberWithBool:self.statusBtn9]];
    [myArray addObject:[NSNumber numberWithBool:self.statusBtn10]];
    [myArray addObject:[NSNumber numberWithBool:self.statusBtn11]];
    [myArray addObject:[NSNumber numberWithBool:self.statusBtn12]];
    [myArray addObject:[NSNumber numberWithBool:self.statusBtn13]];
    [myArray addObject:[NSNumber numberWithBool:self.statusBtn14]];
    [myArray addObject:[NSNumber numberWithBool:self.statusBtn15]];
    [myArray addObject:[NSNumber numberWithBool:self.statusBtn16]];
    [myArray addObject:[NSNumber numberWithBool:self.statusBtn17]];
    //NSArray *anArray = myArray;
    [caller update17ButtonValues:myArray];
}

- (IBAction)fourByFourButton1Pressed:(id)sender {
    LogDebug(@"4x4 button 1 pressed.");
    if (self.statusBtn1) {
        self.statusBtn1 = NO;
        [MSURVParseHelper LogParse:self.question withStringResponse:@"Button 1 deselected" andType:1];
    }
    else {
        self.statusBtn1 = YES;
        [MSURVParseHelper LogParse:self.question withStringResponse:@"Button 1 selected" andType:1];
    }
    self.statusBtn17 = NO;
    
    [self updateValues];
    [self updateSelectedFourByFourStatusImage];
}

- (IBAction)fourByFourButton2Pressed:(id)sender {
    LogDebug(@"4x4 button 2 pressed.");
    if (self.statusBtn2) {
        self.statusBtn2 = NO;
        [MSURVParseHelper LogParse:self.question withStringResponse:@"Button 2 deselected" andType:1];
    }
    else {
        self.statusBtn2 = YES;
        [MSURVParseHelper LogParse:self.question withStringResponse:@"Button 2 selected" andType:1];
    }
    self.statusBtn17 = NO;
    
    [self updateValues];
    [self updateSelectedFourByFourStatusImage];
}

- (IBAction)fourByFourButton3Pressed:(id)sender {
    LogDebug(@"4x4 button 3 pressed.");
    if (self.statusBtn3) {
        self.statusBtn3 = NO;
        [MSURVParseHelper LogParse:self.question withStringResponse:@"Button 3 deselected" andType:1];
    }
    else {
        self.statusBtn3 = YES;
        [MSURVParseHelper LogParse:self.question withStringResponse:@"Button 3 selected" andType:1];
    }
    self.statusBtn17 = NO;
    
    [self updateValues];
    [self updateSelectedFourByFourStatusImage];
}

- (IBAction)fourByFourButton4Pressed:(id)sender {
    LogDebug(@"4x4 button 4 pressed.");
    if (self.statusBtn4) {
        self.statusBtn4 = NO;
        [MSURVParseHelper LogParse:self.question withStringResponse:@"Button 4 deselected" andType:1];
    }
    else {
        self.statusBtn4 = YES;
        [MSURVParseHelper LogParse:self.question withStringResponse:@"Button 4 selected" andType:1];
    }
    self.statusBtn17 = NO;
    
    [self updateValues];
    [self updateSelectedFourByFourStatusImage];
}

- (IBAction)fourByFourButton5Pressed:(id)sender {
    LogDebug(@"4x4 button 5 pressed.");
    if (self.statusBtn5) {
        self.statusBtn5 = NO;
        [MSURVParseHelper LogParse:self.question withStringResponse:@"Button 5 deselected" andType:1];
    }
    else {
        self.statusBtn5 = YES;
        [MSURVParseHelper LogParse:self.question withStringResponse:@"Button 5 selected" andType:1];
    }
    self.statusBtn17 = NO;
    
    [self updateValues];
    [self updateSelectedFourByFourStatusImage];
}

- (IBAction)fourByFourButton6Pressed:(id)sender {
    LogDebug(@"4x4 button 6 pressed.");
    if (self.statusBtn6) {
        self.statusBtn6 = NO;
        [MSURVParseHelper LogParse:self.question withStringResponse:@"Button 6 deselected" andType:1];
    }
    else {
        self.statusBtn6 = YES;
        [MSURVParseHelper LogParse:self.question withStringResponse:@"Button 6 selected" andType:1];
    }
    self.statusBtn17 = NO;
    
    [self updateValues];
    [self updateSelectedFourByFourStatusImage];
}

- (IBAction)fourByFourButton7Pressed:(id)sender {
    LogDebug(@"4x4 button 7 pressed.");
    if (self.statusBtn7) {
        self.statusBtn7 = NO;
        [MSURVParseHelper LogParse:self.question withStringResponse:@"Button 7 deselected" andType:1];
    }
    else {
        self.statusBtn7 = YES;
        [MSURVParseHelper LogParse:self.question withStringResponse:@"Button 7 selected" andType:1];
    }
    self.statusBtn17 = NO;
    
    [self updateValues];
    [self updateSelectedFourByFourStatusImage];
}

- (IBAction)fourByFourButton8Pressed:(id)sender {
    LogDebug(@"4x4 button 8 pressed.");
    if (self.statusBtn8) {
        self.statusBtn8 = NO;
        [MSURVParseHelper LogParse:self.question withStringResponse:@"Button 8 deselected" andType:1];
    }
    else {
        self.statusBtn8 = YES;
        [MSURVParseHelper LogParse:self.question withStringResponse:@"Button 8 selected" andType:1];
    }
    self.statusBtn17 = NO;
    
    [self updateValues];
    [self updateSelectedFourByFourStatusImage];
}

- (IBAction)fourByFourButton9Pressed:(id)sender {
    LogDebug(@"4x4 button 9 pressed.");
    if (self.statusBtn9) {
        self.statusBtn9 = NO;
        [MSURVParseHelper LogParse:self.question withStringResponse:@"Button 9 deselected" andType:1];
    }
    else {
        self.statusBtn9 = YES;
        [MSURVParseHelper LogParse:self.question withStringResponse:@"Button 9 selected" andType:1];
    }
    self.statusBtn17 = NO;
    
    [self updateValues];
    [self updateSelectedFourByFourStatusImage];
}

- (IBAction)fourByFourButton10Pressed:(id)sender {
    LogDebug(@"4x4 button 10 pressed.");
    if (self.statusBtn10) {
        self.statusBtn10 = NO;
        [MSURVParseHelper LogParse:self.question withStringResponse:@"Button 10 deselected" andType:1];
    }
    else {
        self.statusBtn10 = YES;
        [MSURVParseHelper LogParse:self.question withStringResponse:@"Button 10 selected" andType:1];
    }
    self.statusBtn17 = NO;
    
    [self updateValues];
    [self updateSelectedFourByFourStatusImage];
}

- (IBAction)fourByFourButton11Pressed:(id)sender {
    LogDebug(@"4x4 button 11 pressed.");
    if (self.statusBtn11) {
        self.statusBtn11 = NO;
        [MSURVParseHelper LogParse:self.question withStringResponse:@"Button 11 deselected" andType:1];
    }
    else {
        self.statusBtn11 = YES;
        [MSURVParseHelper LogParse:self.question withStringResponse:@"Button 11 selected" andType:1];
    }
    self.statusBtn17 = NO;
    
    [self updateValues];
    [self updateSelectedFourByFourStatusImage];
}

- (IBAction)fourByFourButton12Pressed:(id)sender {
    LogDebug(@"4x4 button 12 pressed.");
    if (self.statusBtn12) {
        self.statusBtn12 = NO;
        [MSURVParseHelper LogParse:self.question withStringResponse:@"Button 12 deselected" andType:1];
    }
    else {
        self.statusBtn12 = YES;
        [MSURVParseHelper LogParse:self.question withStringResponse:@"Button 12 selected" andType:1];
    }
    self.statusBtn17 = NO;
    
    [self updateValues];
    [self updateSelectedFourByFourStatusImage];
}

- (IBAction)fourByFourButton13Pressed:(id)sender {
    LogDebug(@"4x4 button 13 pressed.");
    if (self.statusBtn13) {
        self.statusBtn13 = NO;
        [MSURVParseHelper LogParse:self.question withStringResponse:@"Button 13 deselected" andType:1];
    }
    else {
        self.statusBtn13 = YES;
        [MSURVParseHelper LogParse:self.question withStringResponse:@"Button 13 selected" andType:1];
    }
    self.statusBtn17 = NO;
    
    [self updateValues];
    [self updateSelectedFourByFourStatusImage];
}

- (IBAction)fourByFourButton14Pressed:(id)sender {
    LogDebug(@"4x4 button 14 pressed.");
    if (self.statusBtn14) {
        self.statusBtn14 = NO;
        [MSURVParseHelper LogParse:self.question withStringResponse:@"Button 14 deselected" andType:1];
    }
    else {
        self.statusBtn14 = YES;
        [MSURVParseHelper LogParse:self.question withStringResponse:@"Button 14 selected" andType:1];
    }
    self.statusBtn17 = NO;
    
    [self updateValues];
    [self updateSelectedFourByFourStatusImage];
}

- (IBAction)fourByFourButton15Pressed:(id)sender {
    LogDebug(@"4x4 button 15 pressed.");
    if (self.statusBtn15) {
        self.statusBtn15 = NO;
        [MSURVParseHelper LogParse:self.question withStringResponse:@"Button 15 deselected" andType:1];
    }
    else {
        self.statusBtn15 = YES;
        [MSURVParseHelper LogParse:self.question withStringResponse:@"Button 15 selected" andType:1];
    }
    self.statusBtn17 = NO;
    
    [self updateValues];
    [self updateSelectedFourByFourStatusImage];
}

- (IBAction)fourByFourButton16Pressed:(id)sender {
    LogDebug(@"4x4 button 16 pressed.");
    if (self.statusBtn16) {
        self.statusBtn16 = NO;
        [MSURVParseHelper LogParse:self.question withStringResponse:@"Button 16 deselected" andType:1];
    }
    else {
        self.statusBtn16 = YES;
        [MSURVParseHelper LogParse:self.question withStringResponse:@"Button 16 selected" andType:1];
    }
    self.statusBtn17 = NO;
    
    [self updateValues];
    [self updateSelectedFourByFourStatusImage];
}

- (IBAction)noneButtonPressed:(id)sender {
    LogDebug(@"4x4 None Button Pressed");
    
    if (self.statusBtn17) {
        self.statusBtn1 = NO;
        self.statusBtn2 = NO;
        self.statusBtn3 = NO;
        self.statusBtn4 = NO;
        self.statusBtn5 = NO;
        self.statusBtn6 = NO;
        self.statusBtn7 = NO;
        self.statusBtn8 = NO;
        self.statusBtn9 = NO;
        self.statusBtn10 = NO;
        self.statusBtn11 = NO;
        self.statusBtn12 = NO;
        self.statusBtn13 = NO;
        self.statusBtn14 = NO;
        self.statusBtn15 = NO;
        self.statusBtn16 = NO;
        self.statusBtn17 = NO;
        [MSURVParseHelper LogParse:self.question withStringResponse:@"Button NONE deselected" andType:1];
    }
    else {
        self.statusBtn1 = NO;
        self.statusBtn2 = NO;
        self.statusBtn3 = NO;
        self.statusBtn4 = NO;
        self.statusBtn5 = NO;
        self.statusBtn6 = NO;
        self.statusBtn7 = NO;
        self.statusBtn8 = NO;
        self.statusBtn9 = NO;
        self.statusBtn10 = NO;
        self.statusBtn11 = NO;
        self.statusBtn12 = NO;
        self.statusBtn13 = NO;
        self.statusBtn14 = NO;
        self.statusBtn15 = NO;
        self.statusBtn16 = NO;
        self.statusBtn17 = YES;
        [MSURVParseHelper LogParse:self.question withStringResponse:@"Button NONE selected" andType:1];
    }
    
    [self updateValues];
    [self updateSelectedFourByFourStatusImage];
}

- (void) resetResponses {
    self.statusBtn1 = NO;
    self.statusBtn2 = NO;
    self.statusBtn3 = NO;
    self.statusBtn4 = NO;
    self.statusBtn5 = NO;
    self.statusBtn6 = NO;
    self.statusBtn7 = NO;
    self.statusBtn8 = NO;
    self.statusBtn9 = NO;
    self.statusBtn10 = NO;
    self.statusBtn11 = NO;
    self.statusBtn12 = NO;
    self.statusBtn13 = NO;
    self.statusBtn14 = NO;
    self.statusBtn15 = NO;
    self.statusBtn16 = NO;
    self.statusBtn17 = NO;
}

- (void)loadResponse4x4for:(NSMutableArray *)anArray {
    NSMutableArray *selected = anArray;
    
    [self resetResponses];
    
    if (selected == nil) {
        return;
    }
    
    LogDebug(@"%d: %@", self.question, selected);
    
    for (id item in selected) {
        LogDebug(@"Focused on %@", item);
        switch ([item intValue]) {
            case 1: self.statusBtn1 = YES;
                LogDebug(@"YES!!");
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
                
            case 8: self.statusBtn8 = YES;
                break;
                
            case 9: self.statusBtn9 = YES;
                break;
                
            case 10: self.statusBtn10 = YES;
                break;
                
            case 11: self.statusBtn11 = YES;
                break;
                
            case 12: self.statusBtn12 = YES;
                break;
                
            case 13: self.statusBtn13 = YES;
                break;
                
            case 14: self.statusBtn14 = YES;
                break;
                
            case 15: self.statusBtn15 = YES;
                break;
                
            case 16: self.statusBtn16 = YES;
                break;
                
            case 17: self.statusBtn17 = YES;
                break;
        }
    }
}


@end
