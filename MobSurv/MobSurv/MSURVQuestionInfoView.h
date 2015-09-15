//
//  MSURVQuestionInfo.h
//  MobSurv
//
//  Created by Michael Youngblood on 9/11/15.
//  Copyright (c) 2015 PARC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

#import "MSURVSurveyViewController.h"

@interface MSURVQuestionInfoView : UIView

@property (weak, nonatomic) IBOutlet UILabel *firstText3;
@property (weak, nonatomic) IBOutlet UIButton *infoImageButton;
@property (weak, nonatomic) IBOutlet UILabel *secondText3;

- (void)displayInfoFor:(PFObject *)question from:(MSURVSurveyViewController*)sender forQuestion:(int)q;

@end
