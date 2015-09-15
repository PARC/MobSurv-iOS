//
//  MSURVQuestionInfoCenterView.h
//  MobSurv
//
//  Created by Michael Youngblood on 9/12/15.
//  Copyright (c) 2015 PARC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

#import "MSURVSurveyViewController.h"

@interface MSURVQuestionInfoCenterView : UIView

@property (weak, nonatomic) IBOutlet UILabel *titleText;
@property (weak, nonatomic) IBOutlet UILabel *bodyText;

- (void)displayInfoCenterFor:(PFObject *)question from:(MSURVSurveyViewController*)sender forQuestion:(int)q;

@end
