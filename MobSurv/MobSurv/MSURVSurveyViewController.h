//
//  MSURVSurveyViewController.h
//  MobSurv
//
//  Created by Michael Youngblood on 8/19/14.
//  Copyright (c) 2014 PARC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>

@interface MSURVSurveyViewController : UIViewController

- (void)updateButtonValues:(NSArray*)fromArray;
- (void)update17ButtonValues:(NSArray*)fromArray;
- (void)update7ButtonValues:(NSArray*)fromArray;

-(void)setNextButtonGreen;
-(void)setNextButtonRed;

@end
