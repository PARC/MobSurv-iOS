//
//  MSURVQuestionGrid4x4View.h
//  MobSurv
//
//  Created by Michael Youngblood on 9/12/15.
//  Copyright (c) 2015 PARC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

#import "MSURVSurveyViewController.h"

@interface MSURVQuestionGrid4x4View : UIView

@property (weak, nonatomic) IBOutlet UILabel *firstText5;

@property (weak, nonatomic) IBOutlet UIButton *fourByFourButton1;
@property (weak, nonatomic) IBOutlet UIButton *fourByFourButton2;
@property (weak, nonatomic) IBOutlet UIButton *fourByFourButton3;
@property (weak, nonatomic) IBOutlet UIButton *fourByFourButton4;

@property (weak, nonatomic) IBOutlet UIButton *fourByFourButton5;
@property (weak, nonatomic) IBOutlet UIButton *fourByFourButton6;
@property (weak, nonatomic) IBOutlet UIButton *fourByFourButton7;
@property (weak, nonatomic) IBOutlet UIButton *fourByFourButton8;

@property (weak, nonatomic) IBOutlet UIButton *fourByFourButton9;
@property (weak, nonatomic) IBOutlet UIButton *fourByFourButton10;
@property (weak, nonatomic) IBOutlet UIButton *fourByFourButton11;
@property (weak, nonatomic) IBOutlet UIButton *fourByFourButton12;

@property (weak, nonatomic) IBOutlet UIButton *fourByFourButton13;
@property (weak, nonatomic) IBOutlet UIButton *fourByFourButton14;
@property (weak, nonatomic) IBOutlet UIButton *fourByFourButton15;
@property (weak, nonatomic) IBOutlet UIButton *fourByFourButton16;

@property (weak, nonatomic) IBOutlet UIButton *fourByFourButton17;

- (void)display4x4For:(PFObject *)info from:(MSURVSurveyViewController*)sender forQuestion:(int)q;
- (void)updateSelectedFourByFourStatusImage;

- (void) resetResponses;
- (void)loadResponse4x4for:(NSMutableArray *)anArray;

@end
