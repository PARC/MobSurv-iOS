//
//  MSURVQuestionText7OptionView.h
//  MobSurv
//
//  Created by Michael Youngblood on 9/12/15.
//  Copyright (c) 2015 PARC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

#import "MSURVSurveyViewController.h"

@interface MSURVQuestionText7OptionView : UIView

@property (weak, nonatomic) IBOutlet UILabel *firstText1;
@property (weak, nonatomic) IBOutlet UIButton *gridButton1;
@property (weak, nonatomic) IBOutlet UIButton *gridButton2;
@property (weak, nonatomic) IBOutlet UIButton *gridButton3;
@property (weak, nonatomic) IBOutlet UIButton *gridButton4;
@property (weak, nonatomic) IBOutlet UIButton *gridButton5;
@property (weak, nonatomic) IBOutlet UIButton *gridButton6;
@property (weak, nonatomic) IBOutlet UIButton *gridButton7;

- (void)displayText7OptionFor:(PFObject *)question from:(MSURVSurveyViewController*)sender forQuestion:(int)q;
- (void)updateSelectedStatusImage;

- (void)resetResponses;
- (void)loadResponseFor:(NSInteger)selected;

@end
