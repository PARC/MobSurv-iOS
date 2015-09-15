//
//  MSURVQuestionScrollView.h
//  MobSurv
//
//  Created by Michael Youngblood on 9/12/15.
//  Copyright (c) 2015 PARC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

#import "MSURVSurveyViewController.h"

@interface MSURVQuestionScrollView : UIView

@property (weak, nonatomic) IBOutlet UIScrollView *scrollQuestions;
@property (weak, nonatomic) IBOutlet UILabel *firstText2;

@property (weak, nonatomic) IBOutlet UIButton *scrollButton1;
@property (weak, nonatomic) IBOutlet UIButton *scrollButton2;
@property (weak, nonatomic) IBOutlet UIButton *scrollButton3;
@property (weak, nonatomic) IBOutlet UIButton *scrollButton4;
@property (weak, nonatomic) IBOutlet UIButton *scrollButton5;
@property (weak, nonatomic) IBOutlet UIButton *scrollButton6;

- (void)scrollButton1Pressed:(UIButton *)sender;
- (void)scrollButton2Pressed:(UIButton *)sender;
- (void)scrollButton3Pressed:(UIButton *)sender;
- (void)scrollButton4Pressed:(UIButton *)sender;
- (void)scrollButton5Pressed:(UIButton *)sender;
- (void)scrollButton6Pressed:(UIButton *)sender;


- (void)displayScrollFor:(PFObject *)question from:(MSURVSurveyViewController*)sender forQuestion:(int)q;
- (void)updateSelectedScrollStatusImage;

- (void)resetResponses;
- (void)loadResponseFor:(NSInteger)selected;

@end
