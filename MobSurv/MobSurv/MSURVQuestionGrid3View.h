//
//  MSURVQuestionGrid3View.h
//  MobSurv
//
//  Created by Michael Youngblood on 9/12/15.
//  Copyright (c) 2015 PARC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

#import "MSURVSurveyViewController.h"

@interface MSURVQuestionGrid3View : UIView

@property (weak, nonatomic) IBOutlet UILabel *firstText1;
@property (weak, nonatomic) IBOutlet UIButton *gridButton1;
@property (weak, nonatomic) IBOutlet UIButton *gridButton2;
@property (weak, nonatomic) IBOutlet UIButton *gridButton3;
// Not used below
@property (weak, nonatomic) IBOutlet UIButton *gridButton4;
@property (weak, nonatomic) IBOutlet UIButton *gridButton5;
@property (weak, nonatomic) IBOutlet UIButton *gridButton6;

- (void)displayGrid3For:(PFObject *)question from:(MSURVSurveyViewController*)sender forQuestion:(int)q;
- (void)updateSelectedStatusImage;

- (void)resetResponses;
- (void)loadResponseFor:(NSInteger)selected;

@end
