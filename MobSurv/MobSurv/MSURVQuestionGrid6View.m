//
//  MSURVQuestionGrid6View.m
//  MobSurv
//
//  Created by Michael Youngblood on 9/9/15.
//  Copyright (c) 2015 PARC. All rights reserved.
//

#import "MSURVQuestionGrid6View.h"
#import "Logging.h"
#import "globals.h"

#import <AudioToolbox/AudioToolbox.h>
#import "UIImage+ResizeMagick.h"
#import "DLAVAlertView.h"

#import "MSURVParseHelper.h"

@interface MSURVQuestionGrid6View ()

@property BOOL statusBtn1;
@property BOOL statusBtn2;
@property BOOL statusBtn3;
@property BOOL statusBtn4;
@property BOOL statusBtn5;
@property BOOL statusBtn6;

@property UIImage *image1;
@property UIImage *image2;
@property UIImage *image3;
@property UIImage *image4;
@property UIImage *image5;
@property UIImage *image6;

@property int question;

- (void)enlargeButtonImageFor:(UIImage *)anImage;

@end

//******************* IMPLEMENTATION ********************

@implementation MSURVQuestionGrid6View

MSURVSurveyViewController *caller;

-(MSURVQuestionGrid6View *) init{
    MSURVQuestionGrid6View *result = nil;
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
    
    LogDebug(@">>>>>>>>>>>>>>> Creating a Grid 6 View");
    
    // For grid and scroll questions
    self.statusBtn1 = NO;
    self.statusBtn2 = NO;
    self.statusBtn3 = NO;
    self.statusBtn4 = NO;
    self.statusBtn5 = NO;
    self.statusBtn6 = NO;
    
    // Connect double taps to buttons
    [self.gridButton1 addTarget:self action:@selector(multipleTap1:withEvent:) forControlEvents:UIControlEventTouchDownRepeat];
    [self.gridButton2 addTarget:self action:@selector(multipleTap2:withEvent:) forControlEvents:UIControlEventTouchDownRepeat];
    [self.gridButton3 addTarget:self action:@selector(multipleTap3:withEvent:) forControlEvents:UIControlEventTouchDownRepeat];
    [self.gridButton4 addTarget:self action:@selector(multipleTap4:withEvent:) forControlEvents:UIControlEventTouchDownRepeat];
    [self.gridButton5 addTarget:self action:@selector(multipleTap5:withEvent:) forControlEvents:UIControlEventTouchDownRepeat];
    [self.gridButton6 addTarget:self action:@selector(multipleTap6:withEvent:) forControlEvents:UIControlEventTouchDownRepeat];
    
    // TODO: Hide the buttons
     
    return result;
}

// Initial loading of button images
//
- (void)displayGridFor:(PFObject *)question from:(MSURVSurveyViewController*)sender forQuestion:(int)q{

    caller = sender;
    self.question = q;
    
    self.firstText1.text = question[@"firstText"];
    
    // Make all buttons invisible first
    self.gridButton1.hidden = YES;
    self.gridButton2.hidden = YES;
    self.gridButton3.hidden = YES;
    self.gridButton4.hidden = YES;
    self.gridButton5.hidden = YES;
    self.gridButton6.hidden = YES;
    
    // ImageButton 1
    LogDebug(@"Loading button image 1.");
    PFFile *imageObject1 = question[@"button1image"];
    [imageObject1
     getDataInBackgroundWithBlock: ^(NSData *imageData, NSError *error) {
         if (!error) {
             UIImage *image = [UIImage imageWithData:imageData];
             LogDebug(@"...File description %@", image.description);
             
             [[self.gridButton1 imageView]
              setContentMode:UIViewContentModeScaleAspectFit];
             [self.gridButton1 setBackgroundImage:image
                                         forState:UIControlStateNormal];
             self.image1 = image;
             
             self.gridButton1.hidden = NO;
         }
         else {
             // Log details of the failure
             LogDebug(@"Error: %@ %@", error, [error userInfo]);
         }
     }];
    
    // ImageButton 2
    LogDebug(@"Loading button image 2.");
    PFFile *imageObject2 = question[@"button2image"];
    [imageObject2
     getDataInBackgroundWithBlock: ^(NSData *imageData, NSError *error) {
         if (!error) {
             UIImage *image = [UIImage imageWithData:imageData];
             LogDebug(@"...File description %@", image.description);
             
             [[self.gridButton2 imageView]
              setContentMode:UIViewContentModeScaleAspectFit];
             [self.gridButton2 setBackgroundImage:image
                                         forState:UIControlStateNormal];
             self.image2 = image;
             
             self.gridButton2.hidden = NO;
         }
         else {
             // Log details of the failure
             LogDebug(@"Error: %@ %@", error, [error userInfo]);
         }
     }];
    
    // ImageButton 3
    LogDebug(@"Loading button image 3.");
    PFFile *imageObject3 = question[@"button3image"];
    [imageObject3
     getDataInBackgroundWithBlock: ^(NSData *imageData, NSError *error) {
         if (!error) {
             UIImage *image = [UIImage imageWithData:imageData];
             LogDebug(@"...File description %@", image.description);
             
             [[self.gridButton3 imageView]
              setContentMode:UIViewContentModeScaleAspectFit];
             [self.gridButton3 setBackgroundImage:image
                                         forState:UIControlStateNormal];
             self.image3 = image;
             
             self.gridButton3.hidden = NO;
         }
         else {
             // Log details of the failure
             LogDebug(@"Error: %@ %@", error, [error userInfo]);
         }
     }];
    
    // ImageButton 4
    LogDebug(@"Loading button image 4.");
    PFFile *imageObject4 = question[@"button4image"];
    [imageObject4
     getDataInBackgroundWithBlock: ^(NSData *imageData, NSError *error) {
         if (!error) {
             UIImage *image = [UIImage imageWithData:imageData];
             LogDebug(@"...File description %@", image.description);
             
             [[self.gridButton4 imageView]
              setContentMode:UIViewContentModeScaleAspectFit];
             [self.gridButton4 setBackgroundImage:image
                                         forState:UIControlStateNormal];
             self.image4 = image;
             
             self.gridButton4.hidden = NO;
         }
         else {
             // Log details of the failure
             LogDebug(@"Error: %@ %@", error, [error userInfo]);
         }
     }];
    
    // ImageButton 5
    LogDebug(@"Loading button image 5.");
    PFFile *imageObject5 = question[@"button5image"];
    [imageObject5
     getDataInBackgroundWithBlock: ^(NSData *imageData, NSError *error) {
         if (!error) {
             UIImage *image = [UIImage imageWithData:imageData];
             LogDebug(@"...File description %@", image.description);
             
             [[self.gridButton5 imageView]
              setContentMode:UIViewContentModeScaleAspectFit];
             [self.gridButton5 setBackgroundImage:image
                                         forState:UIControlStateNormal];
             self.image5 = image;
             
             self.gridButton5.hidden = NO;
         }
         else {
             // Log details of the failure
             LogDebug(@"Error: %@ %@", error, [error userInfo]);
         }
     }];
    
    // ImageButton 6
    LogDebug(@"Loading button image 6.");
    PFFile *imageObject6 = question[@"button6image"];
    [imageObject6
     getDataInBackgroundWithBlock: ^(NSData *imageData, NSError *error) {
         if (!error) {
             UIImage *image = [UIImage imageWithData:imageData];
             LogDebug(@"...File description %@", image.description);
             
             [[self.gridButton6 imageView]
              setContentMode:UIViewContentModeScaleAspectFit];
             [self.gridButton6 setBackgroundImage:image
                                         forState:UIControlStateNormal];
             self.image6 = image;
             
             self.gridButton6.hidden = NO;
         }
         else {
             // Log details of the failure
             LogDebug(@"Error: %@ %@", error, [error userInfo]);
         }
     }];
    
    // TODO: Restore state of this question if had been answered
}


- (void)enlargeButtonImageFor:(UIImage *)anImage {
    // Show Image in an Alert View
    DLAVAlertView *alertView = [[DLAVAlertView alloc] initWithTitle:@"" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
    alertView.dismissesOnBackdropTap = YES;
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 240.0, 240.0)];
    
    [contentView setBackgroundColor:[UIColor colorWithPatternImage:[anImage resizedImageByMagick:@"240x240#"]]];
    alertView.contentView = contentView;
    [alertView showWithCompletion: ^(DLAVAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex == -1) {
            LogDebug(@"Tapped backdrop!");
        }
        else {
            LogDebug(@"Clicked button '%@' at index: %ld", [alertView buttonTitleAtIndex:buttonIndex], (long)buttonIndex);
        }
    }];
}

- (void)updateSelectedStatusImage {
    UIImage *anImage = [[UIImage imageNamed:@"cornerCheck"] resizedImageByMagick:@"240x240#"];
    
    if (self.statusBtn1 == NO) {
        [self.gridButton1 setImage:nil forState:UIControlStateNormal];
    }
    else {
        [self.gridButton1 setImage:anImage forState:UIControlStateNormal];
    }
    
    if (self.statusBtn2 == NO) {
        [self.gridButton2 setImage:nil forState:UIControlStateNormal];
    }
    else {
        [self.gridButton2 setImage:anImage forState:UIControlStateNormal];
    }
    
    if (self.statusBtn3 == NO) {
        [self.gridButton3 setImage:nil forState:UIControlStateNormal];
    }
    else {
        [self.gridButton3 setImage:anImage forState:UIControlStateNormal];
    }
    
    if (self.statusBtn4 == NO) {
        [self.gridButton4 setImage:nil forState:UIControlStateNormal];
    }
    else {
        [self.gridButton4 setImage:anImage forState:UIControlStateNormal];
    }
    
    if (self.statusBtn5 == NO) {
        [self.gridButton5 setImage:nil forState:UIControlStateNormal];
    }
    else {
        [self.gridButton5 setImage:anImage forState:UIControlStateNormal];
    }
    
    if (self.statusBtn6 == NO) {
        [self.gridButton6 setImage:nil forState:UIControlStateNormal];
    }
    else {
        [self.gridButton6 setImage:anImage forState:UIControlStateNormal];
    }
    
    if (!(self.statusBtn1 == YES || self.statusBtn2 == YES || self.statusBtn3 == YES ||
          self.statusBtn4 == YES || self.statusBtn5 == YES || self.statusBtn6 == YES)) {
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
    //NSArray *anArray = myArray;
    [caller updateButtonValues:myArray];
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
        [MSURVParseHelper LogParse:self.question withNumberResponse:1 andType:1];
    }
    else {
        self.statusBtn1 = NO;
        [MSURVParseHelper LogParse:self.question withNumberResponse:0 andType:1];
    }
    
    [self updateValues];
    [self updateSelectedStatusImage];
}

- (IBAction)multipleTap1:(id)sender withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    if (touch.tapCount == 2) {
        // do action.
        LogDebug(@"Button 1 DOUBLE tap!");
        [self enlargeButtonImageFor:self.image1];
    }
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
        [MSURVParseHelper LogParse:self.question withNumberResponse:2 andType:1];
    }
    else {
        self.statusBtn2 = NO;
        [MSURVParseHelper LogParse:self.question withNumberResponse:0 andType:1];
    }
    
    [self updateValues];
    [self updateSelectedStatusImage];
}

- (IBAction)multipleTap2:(id)sender withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    if (touch.tapCount == 2) {
        // do action.
        LogDebug(@"Button 2 DOUBLE tap!");
        [self enlargeButtonImageFor:self.image2];
    }
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
        [MSURVParseHelper LogParse:self.question withNumberResponse:3 andType:1];
    }
    else {
        self.statusBtn3 = NO;
        [MSURVParseHelper LogParse:self.question withNumberResponse:0 andType:1];
    }
    
    [self updateValues];
    [self updateSelectedStatusImage];
}

- (IBAction)multipleTap3:(id)sender withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    if (touch.tapCount == 2) {
        // do action.
        LogDebug(@"Button 3 DOUBLE tap!");
        [self enlargeButtonImageFor:self.image3];
    }
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
        [MSURVParseHelper LogParse:self.question withNumberResponse:4 andType:1];
    }
    else {
        self.statusBtn4 = NO;
        [MSURVParseHelper LogParse:self.question withNumberResponse:0 andType:1];
    }
    
    [self updateValues];
    [self updateSelectedStatusImage];
}

- (IBAction)multipleTap4:(id)sender withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    if (touch.tapCount == 2) {
        // do action.
        LogDebug(@"Button 4 DOUBLE tap!");
        [self enlargeButtonImageFor:self.image4];
    }
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
        [MSURVParseHelper LogParse:self.question withNumberResponse:5 andType:1];
    }
    else {
        self.statusBtn5 = NO;
        [MSURVParseHelper LogParse:self.question withNumberResponse:0 andType:1];
    }
    
    [self updateValues];
    [self updateSelectedStatusImage];
}

- (IBAction)multipleTap5:(id)sender withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    if (touch.tapCount == 2) {
        // do action.
        LogDebug(@"Button 5 DOUBLE tap!");
        [self enlargeButtonImageFor:self.image5];
    }
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
        [MSURVParseHelper LogParse:self.question withNumberResponse:6 andType:1];
    }
    else {
        self.statusBtn6 = NO;
        [MSURVParseHelper LogParse:self.question withNumberResponse:0 andType:1];
    }
    
    [self updateValues];
    [self updateSelectedStatusImage];
}

- (IBAction)multipleTap6:(id)sender withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    if (touch.tapCount == 2) {
        // do action.
        LogDebug(@"Button 6 DOUBLE tap!");
        [self enlargeButtonImageFor:self.image6];
    }
}

- (void)resetResponses {    
    self.statusBtn1 = NO;
    self.statusBtn2 = NO;
    self.statusBtn3 = NO;
    self.statusBtn4 = NO;
    self.statusBtn5 = NO;
    self.statusBtn6 = NO;
}

- (void)loadResponseFor:(NSInteger)selected {
    
    self.statusBtn1 = NO;
    self.statusBtn2 = NO;
    self.statusBtn3 = NO;
    self.statusBtn4 = NO;
    self.statusBtn5 = NO;
    self.statusBtn6 = NO;
    
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
    }
}

@end
