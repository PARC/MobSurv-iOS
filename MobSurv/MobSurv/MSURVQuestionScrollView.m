//
//  MSURVQuestionScrollView.m
//  MobSurv
//
//  Created by Michael Youngblood on 9/12/15.
//  Copyright (c) 2015 PARC. All rights reserved.
//

#import "MSURVQuestionScrollView.h"
#import "Logging.h"
#import "globals.h"

#import <AudioToolbox/AudioToolbox.h>
#import "UIImage+ResizeMagick.h"
#import "DLAVAlertView.h"

#import "MSURVParseHelper.h"

@interface MSURVQuestionScrollView ()

@property int question;

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

@end

//******************* IMPLEMENTATION ********************

@implementation MSURVQuestionScrollView

MSURVSurveyViewController *caller;

-(MSURVQuestionScrollView *) init{
    MSURVQuestionScrollView *result = nil;
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
    
    LogDebug(@">>>>>>>>>>>>>>> Creating a Scroll View");
    
    
    return result;
}

- (void)displayScrollFor:(PFObject *)question from:(MSURVSurveyViewController*)sender forQuestion:(int)q{
    
    caller = sender;
    self.question = q;
    
    // Make all buttons invisible first
    self.scrollButton1.hidden = YES;
    self.scrollButton2.hidden = YES;
    self.scrollButton3.hidden = YES;
    self.scrollButton4.hidden = YES;
    self.scrollButton5.hidden = YES;
    self.scrollButton6.hidden = YES;
    
    // ImageButton 1
    LogDebug(@"Loading button image 1 for scroll.");
    PFFile *imageObject1 = question[@"button1image"];
    [imageObject1
     getDataInBackgroundWithBlock: ^(NSData *imageData, NSError *error) {
         if (!error) {
             UIImage *image = [UIImage imageWithData:imageData];
             LogDebug(@"...File description %@", image.description);
             
             [[self.scrollButton1 imageView] setContentMode:UIViewContentModeScaleAspectFit];
             [self.scrollButton1 setBackgroundImage:image forState:UIControlStateNormal];
             self.image1 = image;
             
             self.scrollButton1.frame = CGRectMake(0.0, 0.0, 290.0, 290.0);
             [self.scrollButton1 addTarget:self action:@selector(scrollButton1Pressed:) forControlEvents:UIControlEventTouchUpInside];
             
             self.scrollButton1.hidden = NO;
         }
         else {
             // Log details of the failure
             LogDebug(@"Error: %@ %@", error, [error userInfo]);
         }
     }];
    
    // ImageButton 2
    LogDebug(@"Loading button image 2 for scroll.");
    PFFile *imageObject2 = question[@"button2image"];
    [imageObject2
     getDataInBackgroundWithBlock: ^(NSData *imageData, NSError *error) {
         if (!error) {
             UIImage *image = [UIImage imageWithData:imageData];
             LogDebug(@"...File description %@", image.description);
             
             [[self.scrollButton2 imageView] setContentMode:UIViewContentModeScaleAspectFit];
             [self.scrollButton2 setBackgroundImage:image forState:UIControlStateNormal];
             self.image2 = image;
             
             self.scrollButton2.frame = CGRectMake(0.0, 300.0, 290.0, 290.0);
             [self.scrollButton2 addTarget:self action:@selector(scrollButton2Pressed:) forControlEvents:UIControlEventTouchUpInside];
             
             self.scrollButton2.hidden = NO;
         }
         else {
             // Log details of the failure
             LogDebug(@"Error: %@ %@", error, [error userInfo]);
         }
     }];
    
    // ImageButton 3
    LogDebug(@"Loading button image 3 for scroll.");
    PFFile *imageObject3 = question[@"button3image"];
    [imageObject3
     getDataInBackgroundWithBlock: ^(NSData *imageData, NSError *error) {
         if (!error) {
             UIImage *image = [UIImage imageWithData:imageData];
             LogDebug(@"...File description %@", image.description);
             
             [[self.scrollButton3 imageView] setContentMode:UIViewContentModeScaleAspectFit];
             [self.scrollButton3 setBackgroundImage:image forState:UIControlStateNormal];
             self.image3 = image;
             
             self.scrollButton3.frame = CGRectMake(0.0, 600.0, 290.0, 290.0);
             [self.scrollButton3 addTarget:self action:@selector(scrollButton3Pressed:) forControlEvents:UIControlEventTouchUpInside];
             
             self.scrollButton3.hidden = NO;
         }
         else {
             // Log details of the failure
             LogDebug(@"Error: %@ %@", error, [error userInfo]);
         }
     }];
    
    // ImageButton 4
    LogDebug(@"Loading button image 4 for scroll.");
    PFFile *imageObject4 = question[@"button4image"];
    [imageObject4
     getDataInBackgroundWithBlock: ^(NSData *imageData, NSError *error) {
         if (!error) {
             UIImage *image = [UIImage imageWithData:imageData];
             LogDebug(@"...File description %@", image.description);
             
             [[self.scrollButton4 imageView] setContentMode:UIViewContentModeScaleAspectFit];
             [self.scrollButton4 setBackgroundImage:image forState:UIControlStateNormal];
             self.image4 = image;
             
             self.scrollButton4.frame = CGRectMake(0.0, 900.0, 290.0, 290.0);
             [self.scrollButton4 addTarget:self action:@selector(scrollButton4Pressed:) forControlEvents:UIControlEventTouchUpInside];
             
             self.scrollButton4.hidden = NO;
         }
         else {
             // Log details of the failure
             LogDebug(@"Error: %@ %@", error, [error userInfo]);
         }
     }];
    
    // ImageButton 5
    LogDebug(@"Loading button image 5 for scroll.");
    PFFile *imageObject5 = question[@"button5image"];
    [imageObject5
     getDataInBackgroundWithBlock: ^(NSData *imageData, NSError *error) {
         if (!error) {
             UIImage *image = [UIImage imageWithData:imageData];
             LogDebug(@"...File description %@", image.description);
             
             [[self.scrollButton5 imageView] setContentMode:UIViewContentModeScaleAspectFit];
             [self.scrollButton5 setBackgroundImage:image forState:UIControlStateNormal];
             self.image5 = image;
             
             self.scrollButton5.frame = CGRectMake(0.0, 1200.0, 290.0, 290.0);
             [self.scrollButton5 addTarget:self action:@selector(scrollButton5Pressed:) forControlEvents:UIControlEventTouchUpInside];
             
             self.scrollButton5.hidden = NO;
         }
         else {
             // Log details of the failure
             LogDebug(@"Error: %@ %@", error, [error userInfo]);
         }
     }];
    
    // ImageButton 6
    LogDebug(@"Loading button image 6 for scroll.");
    PFFile *imageObject6 = question[@"button6image"];
    [imageObject6
     getDataInBackgroundWithBlock: ^(NSData *imageData, NSError *error) {
         if (!error) {
             UIImage *image = [UIImage imageWithData:imageData];
             LogDebug(@"...File description %@", image.description);
             
             [[self.scrollButton6 imageView] setContentMode:UIViewContentModeScaleAspectFit];
             [self.scrollButton6 setBackgroundImage:image forState:UIControlStateNormal];
             self.image6 = image;
             
             self.scrollButton6.frame = CGRectMake(0.0, 1500.0, 290.0, 290.0);
             [self.scrollButton6 addTarget:self action:@selector(scrollButton6Pressed:) forControlEvents:UIControlEventTouchUpInside];
             
             self.scrollButton6.hidden = NO;
         }
         else {
             // Log details of the failure
             LogDebug(@"Error: %@ %@", error, [error userInfo]);
         }
     }];
    
    [self.scrollQuestions setContentOffset:CGPointMake(0, -self.scrollQuestions.contentInset.top) animated:YES];

    self.firstText2.text = question[@"firstText"];
}

- (void)updateSelectedScrollStatusImage {
    UIImage *anImage = [[UIImage imageNamed:@"cornerCheck"] resizedImageByMagick:@"290x290#"];
    
    if (self.statusBtn1 == NO) {
        [self.scrollButton1 setImage:nil forState:UIControlStateNormal];
    }
    else {
        [self.scrollButton1 setImage:anImage forState:UIControlStateNormal];
    }
    
    if (self.statusBtn2 == NO) {
        [self.scrollButton2 setImage:nil forState:UIControlStateNormal];
    }
    else {
        [self.scrollButton2 setImage:anImage forState:UIControlStateNormal];
    }
    
    if (self.statusBtn3 == NO) {
        [self.scrollButton3 setImage:nil forState:UIControlStateNormal];
    }
    else {
        [self.scrollButton3 setImage:anImage forState:UIControlStateNormal];
    }
    
    if (self.statusBtn4 == NO) {
        [self.scrollButton4 setImage:nil forState:UIControlStateNormal];
    }
    else {
        [self.scrollButton4 setImage:anImage forState:UIControlStateNormal];
    }
    
    if (self.statusBtn5 == NO) {
        [self.scrollButton5 setImage:nil forState:UIControlStateNormal];
    }
    else {
        [self.scrollButton5 setImage:anImage forState:UIControlStateNormal];
    }
    
    if (self.statusBtn6 == NO) {
        [self.scrollButton6 setImage:nil forState:UIControlStateNormal];
    }
    else {
        [self.scrollButton6 setImage:anImage forState:UIControlStateNormal];
    }
    
    if (!(self.statusBtn1 == YES || self.statusBtn2 == YES || self.statusBtn3 == YES ||
          self.statusBtn4 == YES || self.statusBtn5 == YES || self.statusBtn6 == YES)) {
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
    //NSArray *anArray = myArray;
    [caller updateButtonValues:myArray];
}

- (void)scrollButton1Pressed:(UIButton *)sender {
    LogDebug(@"Scroll button 1 pressed.");
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
    [self updateSelectedScrollStatusImage];
}

- (void)scrollButton2Pressed:(UIButton *)sender {
    LogDebug(@"Scroll button 2 pressed.");
    if (self.statusBtn2 == NO) {
        self.statusBtn1 = NO;
        self.statusBtn2 = YES;
        self.statusBtn3 = NO;
        self.statusBtn4 = NO;
        self.statusBtn5 = NO;
        self.statusBtn6 = NO;
        [MSURVParseHelper LogParse:self.question withNumberResponse:1 andType:1];
    }
    else {
        self.statusBtn2 = NO;
        [MSURVParseHelper LogParse:self.question withNumberResponse:0 andType:1];
    }
    
    [self updateValues];
    [self updateSelectedScrollStatusImage];
}

- (void)scrollButton3Pressed:(UIButton *)sender {
    LogDebug(@"Scroll button 3 pressed.");
    if (self.statusBtn3 == NO) {
        self.statusBtn1 = NO;
        self.statusBtn2 = NO;
        self.statusBtn3 = YES;
        self.statusBtn4 = NO;
        self.statusBtn5 = NO;
        self.statusBtn6 = NO;
        [MSURVParseHelper LogParse:self.question withNumberResponse:1 andType:1];
    }
    else {
        self.statusBtn3 = NO;
        [MSURVParseHelper LogParse:self.question withNumberResponse:0 andType:1];
    }
    
    [self updateValues];
    [self updateSelectedScrollStatusImage];
}

- (void)scrollButton4Pressed:(UIButton *)sender {
    LogDebug(@"Scroll button 4 pressed.");
    if (self.statusBtn4 == NO) {
        self.statusBtn1 = NO;
        self.statusBtn2 = NO;
        self.statusBtn3 = NO;
        self.statusBtn4 = YES;
        self.statusBtn5 = NO;
        self.statusBtn6 = NO;
        [MSURVParseHelper LogParse:self.question withNumberResponse:1 andType:1];
    }
    else {
        self.statusBtn4 = NO;
        [MSURVParseHelper LogParse:self.question withNumberResponse:0 andType:1];
    }
    
    [self updateValues];
    [self updateSelectedScrollStatusImage];
}

- (void)scrollButton5Pressed:(UIButton *)sender {
    LogDebug(@"Scroll button 5 pressed.");
    if (self.statusBtn5 == NO) {
        self.statusBtn1 = NO;
        self.statusBtn2 = NO;
        self.statusBtn3 = NO;
        self.statusBtn4 = NO;
        self.statusBtn5 = YES;
        self.statusBtn6 = NO;
        [MSURVParseHelper LogParse:self.question withNumberResponse:1 andType:1];
    }
    else {
        self.statusBtn5 = NO;
        [MSURVParseHelper LogParse:self.question withNumberResponse:0 andType:1];
    }
    
    [self updateValues];
    [self updateSelectedScrollStatusImage];
}

- (void)scrollButton6Pressed:(UIButton *)sender {
    LogDebug(@"Scroll button 6 pressed.");
    if (self.statusBtn6 == NO) {
        self.statusBtn1 = NO;
        self.statusBtn2 = NO;
        self.statusBtn3 = NO;
        self.statusBtn4 = NO;
        self.statusBtn5 = NO;
        self.statusBtn6 = YES;
        [MSURVParseHelper LogParse:self.question withNumberResponse:1 andType:1];
    }
    else {
        self.statusBtn6 = NO;
        [MSURVParseHelper LogParse:self.question withNumberResponse:0 andType:1];
    }
    
    [self updateValues];
    [self updateSelectedScrollStatusImage];
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
