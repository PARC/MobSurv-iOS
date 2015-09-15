//
//  MSURVSurveyViewController.m
//  MobSurv
//
//  Created by Michael Youngblood on 8/19/14.
//  Copyright (c) 2014 PARC. All rights reserved.
//

#import "MSURVSurveyViewController.h"
#import "Logging.h"
#import "globals.h"

#import <AudioToolbox/AudioToolbox.h>
#import <Parse/Parse.h>

#import "DLAVAlertView.h"
#import "UIImage+ResizeMagick.h"

#import "MSURVQuestionGrid6View.h"
#import "MSURVQuestionScrollView.h"
#import "MSURVQuestionInfoView.h"
#import "MSURVQuestionInfoCenterView.h"
#import "MSURVQuestionGrid4x4View.h"
#import "MSURVQuestionInfoHTMLView.h"
#import "MSURVQuestionGrid3View.h"
#import "MSURVQuestionText7OptionView.h"

#import "MSURVParseHelper.h"


@interface MSURVSurveyViewController ()

// View Types--
//
// 1 - Grid 6 Questions
@property MSURVQuestionGrid6View *localGridView;
- (void)displayGridFor:(PFObject *)question;
// 2 - Scroll Questions
@property MSURVQuestionScrollView *localScrollView;
- (void)displayScrollFor:(PFObject *)question;
// 3 - Info
@property MSURVQuestionInfoView *localInfoView;
- (void)displayInfoFor:(PFObject *)info;
// 4 - Info Center
@property MSURVQuestionInfoCenterView *localInfoCenterView;
- (void)displayInfoCenterFor:(PFObject *)info;
// 5 - 4x4 Questions
@property MSURVQuestionGrid4x4View *localGrid4x4View;
- (void)display4x4For:(PFObject *)question;
// 6 - HTML-based Informed Consent
@property MSURVQuestionInfoHTMLView *localInfoHTMLView;
- (void)displayInfoHTMLFor:(PFObject *)info;
// 7 - Grid 3 Questions
@property MSURVQuestionGrid3View *localGrid3View;
- (void)displayGrid3For:(PFObject *)question;
// 8 - Text 7 Option
@property MSURVQuestionText7OptionView *localText7OptionView;
- (void)displayText7OptionFor:(PFObject *)question;

// Master Switch
- (void)loadViewForType:(NSNumber *)type withObject:(PFObject *)question;

@property UIAlertView *alertView;
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

// Parse Data Helpers
@property PFObject *Study;
@property NSArray *StudyDetail;
@property int currentStudy;
@property int maxSurvey;
@property BOOL random;
@property int randomStart;
@property int randomEnd;
@property NSMutableArray *randomized;
@property NSMutableArray *randCompleted;

- (void)retrieveStudyWithName:(NSString *)name;
- (void)retrieveSurveyDetailsForStudy:(PFObject *)study;
- (void)advanceToNextSurvey;

@property PFObject *Survey;
@property NSArray *SurveyDetail;
@property int question;
@property int maxQuestion;
@property int currentQuestionType;

- (void)retrieveSurveyWithName:(NSString *)name;
- (void)retrieveSurveyDetailsForSurvey:(PFObject *)survey;

// Navigation control
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UIButton *backButton;

// Local status mirror
@property BOOL localStatusBtn1;
@property BOOL localStatusBtn2;
@property BOOL localStatusBtn3;
@property BOOL localStatusBtn4;
@property BOOL localStatusBtn5;
@property BOOL localStatusBtn6;
@property BOOL localStatusBtn7;
@property BOOL localStatusBtn8;
@property BOOL localStatusBtn9;
@property BOOL localStatusBtn10;
@property BOOL localStatusBtn11;
@property BOOL localStatusBtn12;
@property BOOL localStatusBtn13;
@property BOOL localStatusBtn14;
@property BOOL localStatusBtn15;
@property BOOL localStatusBtn16;
@property BOOL localStatusBtn17;

// Responses
@property NSMutableDictionary *responseDict;
- (void)saveResponse;
- (void)saveResponse4x4;
- (void)loadResponse;
- (void)loadResponse4x4;

// Audio play
- (void)playFile:(NSString *)nameOfFile;

@end

//******************* IMPLEMENTATION ********************

@implementation MSURVSurveyViewController

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    NSLog(@"Passing all touches to the next view (if any), in the view stack.");
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad {
	[super viewDidLoad];
    
	// Custom initialization
	self.question = 0;
	self.currentQuestionType = 0;
    self.currentStudy = 0;
    self.responseDict = [NSMutableDictionary dictionary];

	// For grid and scroll questions
	self.localStatusBtn1 = NO;
	self.localStatusBtn2 = NO;
	self.localStatusBtn3 = NO;
	self.localStatusBtn4 = NO;
	self.localStatusBtn5 = NO;
	self.localStatusBtn6 = NO;
	self.localStatusBtn7 = NO;
	self.localStatusBtn8 = NO;
	self.localStatusBtn9 = NO;
	self.localStatusBtn10 = NO;
	self.localStatusBtn11 = NO;
	self.localStatusBtn12 = NO;
	self.localStatusBtn13 = NO;
	self.localStatusBtn14 = NO;
	self.localStatusBtn15 = NO;
	self.localStatusBtn16 = NO;
	self.localStatusBtn17 = NO;
    
    LogDebug(@"Starting study \"%@\"", g_surveyName);
    [self retrieveStudyWithName:g_surveyName];
}

- (void)advanceToNextSurvey {
    
    LogDebug(@"***** On Question %d of %d as part of Survey %d of %d.", self.question, self.maxQuestion, self.currentStudy, self.maxSurvey);
    
   	self.question = 0;
    self.currentQuestionType = 0;
    self.responseDict = [NSMutableDictionary dictionary];
    
    // For grid and scroll questions
    self.localStatusBtn1 = NO;
    self.localStatusBtn2 = NO;
    self.localStatusBtn3 = NO;
    self.localStatusBtn4 = NO;
    self.localStatusBtn5 = NO;
    self.localStatusBtn6 = NO;
    self.localStatusBtn7 = NO;
    self.localStatusBtn8 = NO;
    self.localStatusBtn9 = NO;
    self.localStatusBtn10 = NO;
    self.localStatusBtn11 = NO;
    self.localStatusBtn12 = NO;
    self.localStatusBtn13 = NO;
    self.localStatusBtn14 = NO;
    self.localStatusBtn15 = NO;
    self.localStatusBtn16 = NO;
    self.localStatusBtn17 = NO;
    
    // TO DO: catch a NSRangeException here
    PFObject *nextSurvey = [self.StudyDetail objectAtIndex:self.currentStudy];
    
    // Randomization --
    //   Note: You cannot randomize the very first survey
    if ([self.randomized containsObject:[NSNumber numberWithInt:self.currentStudy]]) {
        NSMutableArray *testArray = [NSMutableArray arrayWithArray:self.randomized];
        [testArray removeObjectsInArray:self.randCompleted];
        
        // TO DO: Wrap this for exceptions
        NSUInteger randomIndex = arc4random() % [testArray count];
        
        [self.randCompleted addObject:testArray[randomIndex]];
        LogDebug(@"Survey Slot %d - Running survey %@", self.currentStudy, testArray[randomIndex]);
    }
    else {
        LogDebug(@"Survey Slot %d ", self.currentStudy);
    }
    
    NSString *surveyName = nextSurvey[@"survey"];
    LogDebug(@"Starting survey \"%@\"", surveyName);
    [self retrieveSurveyWithName:surveyName];
    self.currentStudy += 1;
}

// Survey Navigation Buttons *****************************************************************************
//
//
- (IBAction)nextButtonPressed:(id)sender {
    
	if (self.currentQuestionType == 1 || self.currentQuestionType == 2 || self.currentQuestionType == 7) {
		if (!(self.localStatusBtn1 == YES || self.localStatusBtn2 == YES || self.localStatusBtn3 == YES ||
		      self.localStatusBtn4 == YES || self.localStatusBtn5 == YES || self.localStatusBtn6 == YES)) {
			// No selection has been made, need to answer
			LogDebug(@"Need to select an answer before moving on!");

			NSString *alertTitle = @"No answer?";
			NSString *alertMessage = @"Please select one of the choices that best answers the question.";
			UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:alertTitle
			                                                   message:alertMessage
			                                                  delegate:self
			                                         cancelButtonTitle:@"OK"
			                                         otherButtonTitles:nil];
			[theAlert show];
			[MSURVParseHelper LogParse:self.question withStringResponse:@"Next failed" andType:400];
			return;
		}
	}

	if (self.currentQuestionType == 5 || self.currentQuestionType == 8) {
		if (!(self.localStatusBtn1 == YES || self.localStatusBtn2 == YES || self.localStatusBtn3 == YES ||
		      self.localStatusBtn4 == YES || self.localStatusBtn5 == YES || self.localStatusBtn6 == YES ||
		      self.localStatusBtn7 == YES || self.localStatusBtn8 == YES || self.localStatusBtn9 == YES ||
		      self.localStatusBtn10 == YES || self.localStatusBtn11 == YES || self.localStatusBtn12 == YES ||
		      self.localStatusBtn13 == YES || self.localStatusBtn14 == YES || self.localStatusBtn15 == YES ||
		      self.localStatusBtn16 == YES || self.localStatusBtn17 == YES)) {
			// No selection has been made, need to answer
			LogDebug(@"Need to select an answer before moving on!");

			NSString *alertTitle = @"No answer?";
			NSString *alertMessage = @"Please select one or more of the choices that best answers the question.";
			UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:alertTitle
			                                                   message:alertMessage
			                                                  delegate:self
			                                         cancelButtonTitle:@"OK"
			                                         otherButtonTitles:nil];
			[theAlert show];
			[MSURVParseHelper LogParse:self.question withStringResponse:@"Next failed" andType:400];
			return;
		}
	}
    
    [self clearSubviews];

	if (self.question == self.maxQuestion && self.currentStudy == self.maxSurvey) {
		LogDebug(@"Study and Survey complete.");
		[MSURVParseHelper LogParse:self.question withStringResponse:@"Survey complete" andType:2];

		// Log entire responses
		LogDebug(@"Dictionary:%@", self.responseDict);
		NSString *recordedResponses = [NSString stringWithFormat:@"%@=%@", self.Survey[@"name"], self.responseDict];
		[MSURVParseHelper LogParse:self.question withStringResponse:recordedResponses andType:5];

        // Segue back to the start
        [self performSegueWithIdentifier:@"backToStart" sender:self];
        
		return;
    } else if (self.question == self.maxQuestion) {
        LogDebug(@"Survey complete.");
        [MSURVParseHelper LogParse:self.question withStringResponse:@"Survey complete" andType:2];
        
        // Log entire responses
        LogDebug(@"Dictionary:%@", self.responseDict);
        NSString *recordedResponses = [NSString stringWithFormat:@"%@=%@", self.Survey[@"name"], self.responseDict];
        [MSURVParseHelper LogParse:self.question withStringResponse:recordedResponses andType:5];
        
        // Reset and load next survey
        [self advanceToNextSurvey];
    }

	// Record response
	if (self.currentQuestionType == 1 || self.currentQuestionType == 2 ||
        self.currentQuestionType == 7 || self.currentQuestionType == 8) {
		[self saveResponse];
	}
	else if (self.currentQuestionType == 5) {
		[self saveResponse4x4];
	}

	[MSURVParseHelper LogParse:self.question withStringResponse:@"Next question" andType:1];

	self.question += 1;

	if (self.question >= self.maxQuestion)
		self.question = self.maxQuestion;


	// Clear status before switch
	self.localStatusBtn1 = NO;
	self.localStatusBtn2 = NO;
	self.localStatusBtn3 = NO;
	self.localStatusBtn4 = NO;
	self.localStatusBtn5 = NO;
	self.localStatusBtn6 = NO;
	self.localStatusBtn7 = NO;
	self.localStatusBtn8 = NO;
	self.localStatusBtn9 = NO;
	self.localStatusBtn10 = NO;
	self.localStatusBtn11 = NO;
	self.localStatusBtn12 = NO;
	self.localStatusBtn13 = NO;
	self.localStatusBtn14 = NO;
	self.localStatusBtn15 = NO;
	self.localStatusBtn16 = NO;
	self.localStatusBtn17 = NO;
    
	if (self.currentQuestionType == 1) {
        [self.localGridView resetResponses];
		[self.localGridView updateSelectedStatusImage];
	}
	else if (self.currentQuestionType == 2) {
        [self.localScrollView resetResponses];
		[self.localScrollView updateSelectedScrollStatusImage];
	}
	else if (self.currentQuestionType == 5) {
        [self.localGrid4x4View resetResponses];
		[self.localGrid4x4View updateSelectedFourByFourStatusImage];
	}
    else if (self.currentQuestionType == 7) {
        [self.localGrid3View resetResponses];
        [self.localGrid3View updateSelectedStatusImage];
    }
    else if (self.currentQuestionType == 8) {
        [self.localText7OptionView resetResponses];
        [self.localText7OptionView updateSelectedStatusImage];
    }

	LogDebug(@"Load question %d", self.question);

    if (((self.question + 1) > self.maxQuestion) && (self.currentStudy == self.maxSurvey)) {
        [self.nextButton setTitle:@"Leave Survey" forState:UIControlStateNormal];
        [[self.nextButton imageView] setContentMode:UIViewContentModeScaleAspectFit];
        [self.nextButton setBackgroundImage:[UIImage imageNamed:@"green.png"]
                                   forState:UIControlStateNormal];
    } else if ((self.question) < self.maxQuestion) {
        NSString *buttonInfo =
            [NSString stringWithFormat:@"Next (%d of %d)", (self.question + 1),
             self.maxQuestion];
        [self.nextButton setTitle:buttonInfo forState:UIControlStateNormal];
    } else {
        NSString *buttonInfo = [NSString stringWithFormat:@"Next"];
        [self.nextButton setTitle:buttonInfo forState:UIControlStateNormal];
    }

	PFObject *thisQuestion = [self.SurveyDetail objectAtIndex:(self.question - 1)];
	LogDebug(@"Object [%d]: %@", (self.question - 1), thisQuestion);
	[self loadViewForType:thisQuestion[@"type"] withObject:thisQuestion];
	[self playFile:@"55845__sergenious__pushbutn"];

	// Restore response
	if (self.currentQuestionType == 1) {
        [self.localGridView loadResponseFor:[[self.responseDict objectForKey:@(self.question)] integerValue]];
		[self.localGridView updateSelectedStatusImage];
        [self loadResponse];
	}
	else if (self.currentQuestionType == 2) {
		[self.localScrollView loadResponseFor:[[self.responseDict objectForKey:@(self.question)] integerValue]];
		[self.localScrollView updateSelectedScrollStatusImage];
        [self loadResponse];
	}
	else if (self.currentQuestionType == 5) {
        [self.localGrid4x4View loadResponse4x4for:[self.responseDict objectForKey:@(self.question)]];
		[self.localGrid4x4View updateSelectedFourByFourStatusImage];
        [self loadResponse4x4];
	}
    else if (self.currentQuestionType == 7) {
        [self.localGrid3View loadResponseFor:[[self.responseDict objectForKey:@(self.question)] integerValue]];
        [self.localGrid3View updateSelectedStatusImage];
        [self loadResponse];
    }
    else if (self.currentQuestionType == 8) {
        [self.localText7OptionView loadResponseFor:[[self.responseDict objectForKey:@(self.question)] integerValue]];
        [self.localText7OptionView updateSelectedStatusImage];
        [self loadResponse];
    }
}

- (IBAction)backButtonPressed:(id)sender {
	[MSURVParseHelper LogParse:self.question withStringResponse:@"Back question" andType:1];

    if (self.currentQuestionType == 1 || self.currentQuestionType == 2 ||
        self.currentQuestionType == 7 || self.currentQuestionType == 8) {
		[self saveResponse];
	}
	else if (self.currentQuestionType == 5) {
		[self saveResponse4x4];
	}

	self.question -= 1;

	if (self.question <= 0) {
		self.question = 1;

		// Warning to make sure that the user gives consent to trash all recorded responses
		NSString *alertTitle = @"Leave Study?";
		NSString *alertMessage = @"All answers in this section will be lost if you leave the study.";
		UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:alertTitle
		                                                   message:alertMessage
		                                                  delegate:self
		                                         cancelButtonTitle:@"Stay"
		                                         otherButtonTitles:@"Leave", nil];

		[theAlert show];
	}

    [self clearSubviews];
    
	// Clear status before switch
	self.localStatusBtn1 = NO;
	self.localStatusBtn2 = NO;
	self.localStatusBtn3 = NO;
	self.localStatusBtn4 = NO;
	self.localStatusBtn5 = NO;
	self.localStatusBtn6 = NO;
	self.localStatusBtn7 = NO;
	self.localStatusBtn8 = NO;
	self.localStatusBtn9 = NO;
	self.localStatusBtn10 = NO;
	self.localStatusBtn11 = NO;
	self.localStatusBtn12 = NO;
	self.localStatusBtn13 = NO;
	self.localStatusBtn14 = NO;
	self.localStatusBtn15 = NO;
	self.localStatusBtn16 = NO;
	self.localStatusBtn17 = NO;
    
    if (self.currentQuestionType == 1) {
        [self.localGridView resetResponses];
        [self.localGridView updateSelectedStatusImage];
    }
    else if (self.currentQuestionType == 2) {
        [self.localScrollView resetResponses];
        [self.localScrollView updateSelectedScrollStatusImage];
    }
    else if (self.currentQuestionType == 5) {
        [self.localGrid4x4View resetResponses];
        [self.localGrid4x4View updateSelectedFourByFourStatusImage];
    }
    else if (self.currentQuestionType == 7) {
        [self.localGrid3View resetResponses];
        [self.localGrid3View updateSelectedStatusImage];
    }
    else if (self.currentQuestionType == 8) {
        [self.localText7OptionView resetResponses];
        [self.localText7OptionView updateSelectedStatusImage];
    }
    
	LogDebug(@"Load question %d", self.question);

    NSString *buttonInfo =
    [NSString stringWithFormat:@"Next (%d of %d)", (self.question + 1),
     self.maxQuestion];
    [self.nextButton setTitle:buttonInfo forState:UIControlStateNormal];

	[[self.nextButton imageView] setContentMode:UIViewContentModeScaleAspectFit];
	[self.nextButton setBackgroundImage:[UIImage imageNamed:@"red.png"]
	                           forState:UIControlStateNormal];

	PFObject *question = [self.SurveyDetail objectAtIndex:(self.question - 1)];
	LogDebug(@"Object [%d]: %@", (self.question - 1), question);
	[self loadViewForType:question[@"type"] withObject:question];
	[self playFile:@"55844__sergenious__pushbut2"];

	if (self.currentQuestionType == 1) {
        [self.localGridView loadResponseFor:[[self.responseDict objectForKey:@(self.question)] integerValue]];
		[self.localGridView updateSelectedStatusImage];
        [self loadResponse];
	}
	else if (self.currentQuestionType == 2) {
		[self.localScrollView loadResponseFor:[[self.responseDict objectForKey:@(self.question)] integerValue]];
		[self.localScrollView updateSelectedScrollStatusImage];
        [self loadResponse];
	}
	else if (self.currentQuestionType == 5) {
		[self.localGrid4x4View loadResponse4x4for:[self.responseDict objectForKey:@(self.question)]];
		[self.localGrid4x4View updateSelectedFourByFourStatusImage];
        [self loadResponse4x4];
	}
    else if (self.currentQuestionType == 7) {
        [self.localGrid3View loadResponseFor:[[self.responseDict objectForKey:@(self.question)] integerValue]];
        [self.localGrid3View updateSelectedStatusImage];
        [self loadResponse];
    }
    else if (self.currentQuestionType == 8) {
        [self.localText7OptionView loadResponseFor:[[self.responseDict objectForKey:@(self.question)] integerValue]];
        [self.localText7OptionView updateSelectedStatusImage];
        [self loadResponse];
    }
}

// Update Next Button to Green --
//
-(void)setNextButtonGreen {
    LogDebug(@"=== Green");
    [[self.nextButton imageView] setContentMode:UIViewContentModeScaleAspectFit];
    [self.nextButton setBackgroundImage:[UIImage imageNamed:@"green.png"]
                               forState:UIControlStateNormal];
}

// Update Next Button to Red --
//
-(void)setNextButtonRed {
    LogDebug(@"=== Red");
    [[self.nextButton imageView] setContentMode:UIViewContentModeScaleAspectFit];
    [self.nextButton setBackgroundImage:[UIImage imageNamed:@"red.png"]
                               forState:UIControlStateNormal];
}

- (void)clearSubviews {
    [self.localGridView removeFromSuperview];
    [self.localScrollView removeFromSuperview];
    [self.localInfoView removeFromSuperview];
    [self.localInfoCenterView removeFromSuperview];
    [self.localGrid4x4View removeFromSuperview];
    [self.localInfoHTMLView removeFromSuperview];
    [self.localGrid3View removeFromSuperview];
    [self.localText7OptionView removeFromSuperview];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 0) {
		LogDebug(@"Yep, staying here.");
		[MSURVParseHelper LogParse:self.question withStringResponse:@"Decided to stay" andType:6];
	}
	else if (buttonIndex == 1) {
		LogDebug(@"User opted to leave");
		[MSURVParseHelper LogParse:self.question withStringResponse:@"Left survey" andType:400];
		[self performSegueWithIdentifier:@"surveyList" sender:self];
	}
}

// Study & Survey Loading and Handling ********************************************************************
//
//
- (void)retrieveStudyWithName:(NSString *)name {
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc]
                                        initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [spinner setCenter:CGPointMake(140, 100)];
    
    NSString *messageTitleToUser = @"Study";
    self.alertView = [[UIAlertView alloc] initWithTitle:messageTitleToUser
                                                message:@"loading..."
                                               delegate:self
                                      cancelButtonTitle:nil
                                      otherButtonTitles:nil];
    
    [self.alertView addSubview:spinner];
    [spinner startAnimating];
    [self.alertView show];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Study"];
    [query whereKey:@"name" equalTo:name];
    [query findObjectsInBackgroundWithBlock: ^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            LogDebug(@"Successfully retrieved %lu study.", (unsigned long)objects.count);
            // Do something with the found objects
            for (PFObject * object in objects) {
                self.Study = object;
                NSLog(@"%@", object.objectId);
                NSLog(@"%@", object);
            }
            
            LogDebug(@">>>>> Randomized value is %s", [self.Study[@"randomSection"] boolValue] ? "YES" : "NO");
            
            // Pull out the random segment
            if ([self.Study[@"randomSection"] boolValue]) {
                self.random = YES;
                self.randomStart = [self.Study[@"randomStart"] intValue];
                self.randomEnd = [self.Study[@"randomEnd"] intValue];
                
                self.randomized = [NSMutableArray new];
                self.randCompleted = [NSMutableArray new];
                
                for (int i = ((int)self.randomStart - 1); i < ((int)self.randomEnd); i++ ) {
                    [self.randomized addObject:[NSNumber numberWithInt:i]];
                }
                
                // Test
//                LogDebug(@"::: Test");
//                for (int i = 0; i < 10 ; i++) {
//                    if ([self.randomized containsObject:[NSNumber numberWithInt:i]]) {
//                        NSMutableArray *testArray = [NSMutableArray arrayWithArray:self.randomized];
//                        [testArray removeObjectsInArray:self.randCompleted];
//                        NSUInteger randomIndex = arc4random() % [testArray count];
//                        [self.randCompleted addObject:testArray[randomIndex]];
//                        LogDebug(@":: %d - %@", i, testArray[randomIndex]);
//                    }
//                    else {
//                        LogDebug(@":: %d ", i);
//                    }
//                    
//                }
                
                LogDebug(@">>>>> Randomized group (%d, %d) is %@", self.randomStart, self.randomEnd, self.randomized);
            } else {
                self.random = NO;
                LogDebug(@">>>>> Doesn't contain a randomized group.");
            }
            
            // Parse Logging
            NSString *startInfo = [NSString stringWithFormat:@"Started study - %@", self.Study[@"name"]];
            [MSURVParseHelper LogParse:0 withStringResponse:startInfo andType:0];
            
            [self retrieveSurveyDetailsForStudy:self.Study];
        }
        else {
            // Log details of the failure
            LogDebug(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (void)retrieveSurveyDetailsForStudy:(PFObject *)study {
    PFQuery *query = [PFQuery queryWithClassName:@"StudyDetail"];
    [query whereKey:@"study" equalTo:study[@"name"]];
    [query orderByAscending:@"score"];
    [query findObjectsInBackgroundWithBlock: ^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            LogDebug(@"Successfully retrieved %lu study details.",
                     (unsigned long)objects.count);
            self.maxSurvey = (int)objects.count;
            
            // Do something with the found objects
            for (PFObject * object in objects) {
                NSLog(@"%@", object.objectId);
            }
            
            NSSortDescriptor *sort =
            [NSSortDescriptor sortDescriptorWithKey:@"step" ascending:YES];
            self.StudyDetail = [objects
                                 sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
            
            PFObject *survey = [self.StudyDetail objectAtIndex:0];
            LogDebug(@"Object: %@", survey);
            [self retrieveSurveyWithName:survey[@"survey"]];
            self.currentStudy += 1;
        }
        else {
            // Log details of the failure
            LogDebug(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (void)retrieveSurveyWithName:(NSString *)name {
	PFQuery *query = [PFQuery queryWithClassName:@"Survey"];
	[query whereKey:@"name" equalTo:name];
	[query findObjectsInBackgroundWithBlock: ^(NSArray *objects, NSError *error) {
	    if (!error) {
	        // The find succeeded.
	        LogDebug(@"Successfully retrieved %lu surveys.", (unsigned long)objects.count);
	        // Do something with the found objects
	        for (PFObject * object in objects) {
	            self.Survey = object;
	            NSLog(@"%@", object.objectId);
			}
	        [self retrieveSurveyDetailsForSurvey:self.Survey];
            
            // Parse Logging
            NSString *startInfo = [NSString stringWithFormat:@"Started survey - %@", self.Survey[@"name"]];
            [MSURVParseHelper LogParse:0 withStringResponse:startInfo andType:0];
            self.question = 1;
            LogDebug(@"%@, Load question %d", startInfo, self.question);
		}
	    else {
	        // Log details of the failure
	        LogDebug(@"Error: %@ %@", error, [error userInfo]);
		}
	}];
}

- (void)retrieveSurveyDetailsForSurvey:(PFObject *)survey {
	PFQuery *query = [PFQuery queryWithClassName:@"SurveyDetail"];
	[query whereKey:@"surveyName" equalTo:survey[@"name"]];
	[query orderByAscending:@"score"];
	[query findObjectsInBackgroundWithBlock: ^(NSArray *objects, NSError *error) {
	    if (!error) {
	        // The find succeeded.
	        LogDebug(@"Successfully retrieved %lu survey details.",
	                 (unsigned long)objects.count);
	        self.maxQuestion = (int)objects.count;

            if ((self.question + 1) >= self.maxQuestion) {
                NSString *buttonInfo = [NSString stringWithFormat:@"Next"];
                [self.nextButton setTitle:buttonInfo forState:UIControlStateNormal];
            } else {
                NSString *buttonInfo = [NSString stringWithFormat:@"Next (%d of %d)", (self.question + 1),
                                        self.maxQuestion];
                [self.nextButton setTitle:buttonInfo forState:UIControlStateNormal];
            }

	        // Do something with the found objects
	        for (PFObject * object in objects) {
	            NSLog(@"%@", object.objectId);
			}

	        NSSortDescriptor *sort =
	            [NSSortDescriptor sortDescriptorWithKey:@"step" ascending:YES];
	        self.SurveyDetail = [objects
	                             sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];

	        // REMOVE IF LOADING IMAGES FIRST
	        PFObject *question = [self.SurveyDetail objectAtIndex:0];
	        LogDebug(@"Object: %@", question);
	        [self loadViewForType:question[@"type"] withObject:question];
	        [self.alertView dismissWithClickedButtonIndex:0 animated:YES];
		}
	    else {
	        // Log details of the failure
	        LogDebug(@"Error: %@ %@", error, [error userInfo]);
		}
	}];
}

// Master Switch --
//   Loads appropriate type of question.
//
- (void)loadViewForType:(NSNumber *)type withObject:(PFObject *)question {
	switch ([type intValue]) {
		case 1:
            [self displayGridFor:question];
			[MSURVParseHelper LogParse:self.question withStringResponse:@"Loaded grid question" andType:1];
			break;

		case 2:
			[self displayScrollFor:question];
			[MSURVParseHelper LogParse:self.question withStringResponse:@"Loaded scroll question" andType:1];
			break;

		case 3:
			[self displayInfoFor:question];
			[MSURVParseHelper LogParse:self.question withStringResponse:@"Loaded display info" andType:1];
			break;

		case 4:
			[self displayInfoCenterFor:question];
			[MSURVParseHelper LogParse:self.question withStringResponse:@"Loaded display info center" andType:1];
			break;

		case 5:
			[self display4x4For:question];
			[MSURVParseHelper LogParse:self.question withStringResponse:@"Loaded 4x4 question" andType:1];
			break;
            
        case 6:
            [self displayInfoHTMLFor:question];
            [MSURVParseHelper LogParse:self.question withStringResponse:@"Loaded display HTML info" andType:1];
            break;
	
        case 7:
            [self displayGrid3For:question];
            [MSURVParseHelper LogParse:self.question withStringResponse:@"Loaded Grid 3 question" andType:1];
            break;
    
        case 8:
            [self displayText7OptionFor:question];
            [MSURVParseHelper LogParse:self.question withStringResponse:@"Loaded text 7-option question" andType:1];
            break;
    }
}

// External XIB Versions ***********************************************************************************

// Type 1 - Grid 6 Question
//
- (void)displayGridFor:(PFObject *)question {
	[[self.nextButton imageView] setContentMode:UIViewContentModeScaleAspectFit];
	[self.nextButton setBackgroundImage:[UIImage imageNamed:@"red.png"]
	                           forState:UIControlStateNormal];

	self.currentQuestionType = 1;

	// Question
    
    // Create on first usage
    if (self.localGridView == nil) {
        self.localGridView = [[MSURVQuestionGrid6View alloc] init];
    }
    
    self.localGridView.frame = CGRectMake(0.0, 0.0, 320.0, 500.0);
	[self.view addSubview:self.localGridView];
    [self.localGridView displayGridFor:question from:self forQuestion:self.question];
}

// Type 2 - Scroll Question
//
- (void)displayScrollFor:(PFObject *)question {
    [[self.nextButton imageView] setContentMode:UIViewContentModeScaleAspectFit];
    [self.nextButton setBackgroundImage:[UIImage imageNamed:@"red.png"]
                               forState:UIControlStateNormal];
    
    self.currentQuestionType = 2;
    
    // Question
    
    // Create on first usage
    if (self.localScrollView == nil) {
        self.localScrollView = [[MSURVQuestionScrollView alloc] init];
    }
    
    self.localScrollView.frame = CGRectMake(0.0, 0.0, 320.0, 500.0);
    [self.view addSubview:self.localScrollView];
    [self.localScrollView displayScrollFor:question from:self forQuestion:self.question];
}

// Type 1 & 2 Local Button Sync
//
- (void)updateButtonValues:(NSArray*)fromArray {
    self.localStatusBtn1 = [[fromArray objectAtIndex:0] boolValue];
    self.localStatusBtn2 = [[fromArray objectAtIndex:1] boolValue];
    self.localStatusBtn3 = [[fromArray objectAtIndex:2] boolValue];
    self.localStatusBtn4 = [[fromArray objectAtIndex:3] boolValue];
    self.localStatusBtn5 = [[fromArray objectAtIndex:4] boolValue];
    self.localStatusBtn6 = [[fromArray objectAtIndex:5] boolValue];
    
    [self setNextButtonGreen];
}

// Type 3 - Info
//
- (void)displayInfoFor:(PFObject *)info {
	[[self.nextButton imageView] setContentMode:UIViewContentModeScaleAspectFit];
	[self.nextButton setBackgroundImage:[UIImage imageNamed:@"red.png"]
	                           forState:UIControlStateNormal];

	self.currentQuestionType = 3;

    // Info
    
    // Create on first usage
    if (self.localInfoView == nil) {
        self.localInfoView = [[MSURVQuestionInfoView alloc] init];
    }
    
    self.localInfoView.frame = CGRectMake(0.0, 0.0, 320.0, 500.0);
    [self.view addSubview:self.localInfoView];
    [self.localInfoView displayInfoFor:info from:self forQuestion:self.question];
    
	[self.nextButton setBackgroundImage:[UIImage imageNamed:@"green.png"]
	                           forState:UIControlStateNormal];
}

// Type 4 - Info Center
//
- (void)displayInfoCenterFor:(PFObject *)info {
    [[self.nextButton imageView] setContentMode:UIViewContentModeScaleAspectFit];
    [self.nextButton setBackgroundImage:[UIImage imageNamed:@"red.png"]
                               forState:UIControlStateNormal];
    
    self.currentQuestionType = 4;
    
    // Info
    
    // Create on first usage
    if (self.localInfoCenterView == nil) {
        self.localInfoCenterView = [[MSURVQuestionInfoCenterView alloc] init];
    }
    
    self.localInfoCenterView.frame = CGRectMake(0.0, 0.0, 320.0, 500.0);
    [self.view addSubview:self.localInfoCenterView];
    [self.localInfoCenterView displayInfoCenterFor:info from:self forQuestion:self.question];
    
    [self.nextButton setBackgroundImage:[UIImage imageNamed:@"green.png"]
                               forState:UIControlStateNormal];
}

// Type 5 - 4x4 Grid
//
- (void)display4x4For:(PFObject *)question {
    [[self.nextButton imageView] setContentMode:UIViewContentModeScaleAspectFit];
    [self.nextButton setBackgroundImage:[UIImage imageNamed:@"red.png"]
                               forState:UIControlStateNormal];
    
    self.currentQuestionType = 5;
    
    // Question
    
    // Create on first usage
    if (self.localGrid4x4View == nil) {
        self.localGrid4x4View = [[MSURVQuestionGrid4x4View alloc] init];
    }
    
    self.localGrid4x4View.frame = CGRectMake(0.0, 0.0, 320.0, 500.0);
    [self.view addSubview:self.localGrid4x4View];
    [self.localGrid4x4View display4x4For:question from:self forQuestion:self.question];
}

// Type 5 Local Button Sync
//
- (void)update17ButtonValues:(NSArray*)fromArray {
    self.localStatusBtn1 = [[fromArray objectAtIndex:0] boolValue];
    self.localStatusBtn2 = [[fromArray objectAtIndex:1] boolValue];
    self.localStatusBtn3 = [[fromArray objectAtIndex:2] boolValue];
    self.localStatusBtn4 = [[fromArray objectAtIndex:3] boolValue];
    self.localStatusBtn5 = [[fromArray objectAtIndex:4] boolValue];
    self.localStatusBtn6 = [[fromArray objectAtIndex:5] boolValue];
    self.localStatusBtn7 = [[fromArray objectAtIndex:6] boolValue];
    self.localStatusBtn8 = [[fromArray objectAtIndex:7] boolValue];
    self.localStatusBtn9 = [[fromArray objectAtIndex:8] boolValue];
    self.localStatusBtn10 = [[fromArray objectAtIndex:9] boolValue];
    self.localStatusBtn11 = [[fromArray objectAtIndex:10] boolValue];
    self.localStatusBtn12 = [[fromArray objectAtIndex:11] boolValue];
    self.localStatusBtn13 = [[fromArray objectAtIndex:12] boolValue];
    self.localStatusBtn14 = [[fromArray objectAtIndex:13] boolValue];
    self.localStatusBtn15 = [[fromArray objectAtIndex:14] boolValue];
    self.localStatusBtn16 = [[fromArray objectAtIndex:15] boolValue];
    self.localStatusBtn17 = [[fromArray objectAtIndex:16] boolValue];
    
    LogDebug(@"=== Received Array: %@", fromArray);
    
    [self setNextButtonGreen];
}

// Type 6 - Info HTML
//
- (void)displayInfoHTMLFor:(PFObject *)info {
    [[self.nextButton imageView] setContentMode:UIViewContentModeScaleAspectFit];
    [self.nextButton setBackgroundImage:[UIImage imageNamed:@"red.png"]
                               forState:UIControlStateNormal];
    
    self.currentQuestionType = 6;
    
    // Info
    
    // Create on first usage
    if (self.localInfoHTMLView == nil) {
        self.localInfoHTMLView = [[MSURVQuestionInfoHTMLView alloc] init];
    }
    
    self.localInfoHTMLView.frame = CGRectMake(0.0, 0.0, 320.0, 500.0);
    [self.view addSubview:self.localInfoHTMLView];
    [self.localInfoHTMLView displayInfoHTMLFor:info from:self forQuestion:self.question];
    
    [self.nextButton setBackgroundImage:[UIImage imageNamed:@"green.png"]
                               forState:UIControlStateNormal];
    
    // TO DO: Make this a boolean option
    NSString *buttonInfo = [NSString stringWithFormat:@"I Agree"];
    [self.nextButton setTitle:buttonInfo forState:UIControlStateNormal];
}

// Type 7 - Grid 3
//
- (void)displayGrid3For:(PFObject *)question {
    [[self.nextButton imageView] setContentMode:UIViewContentModeScaleAspectFit];
    [self.nextButton setBackgroundImage:[UIImage imageNamed:@"red.png"]
                               forState:UIControlStateNormal];
    
    self.currentQuestionType = 7;
    
    // Question
    
    // Create on first usage
    if (self.localGrid3View == nil) {
        self.localGrid3View = [[MSURVQuestionGrid3View alloc] init];
    }
    
    self.localGrid3View.frame = CGRectMake(0.0, 0.0, 320.0, 500.0);
    [self.view addSubview:self.localGrid3View];
    [self.localGrid3View displayGrid3For:question from:self forQuestion:self.question];
}

// Type 8 - Text 7-Option
//
- (void)displayText7OptionFor:(PFObject *)question {
    [[self.nextButton imageView] setContentMode:UIViewContentModeScaleAspectFit];
    [self.nextButton setBackgroundImage:[UIImage imageNamed:@"red.png"]
                               forState:UIControlStateNormal];
    
    self.currentQuestionType = 8;
    
    // Question
    
    // Create on first usage
    if (self.localText7OptionView == nil) {
        self.localText7OptionView = [[MSURVQuestionText7OptionView alloc] init];
    }
    
    self.localText7OptionView.frame = CGRectMake(0.0, 0.0, 320.0, 500.0);
    [self.view addSubview:self.localText7OptionView];
    [self.localText7OptionView displayText7OptionFor:question from:self forQuestion:self.question];
}

// Type 8 Local Button Sync
//
- (void)update7ButtonValues:(NSArray*)fromArray {
    LogDebug(@">>>>> Updating to %@", fromArray);
    
    self.localStatusBtn1 = [[fromArray objectAtIndex:0] boolValue];
    self.localStatusBtn2 = [[fromArray objectAtIndex:1] boolValue];
    self.localStatusBtn3 = [[fromArray objectAtIndex:2] boolValue];
    self.localStatusBtn4 = [[fromArray objectAtIndex:3] boolValue];
    self.localStatusBtn5 = [[fromArray objectAtIndex:4] boolValue];
    self.localStatusBtn6 = [[fromArray objectAtIndex:5] boolValue];
    self.localStatusBtn7 = [[fromArray objectAtIndex:6] boolValue];
    
    [self setNextButtonGreen];
}

// Response Handling *****************************************************************************
//
//
- (void)saveResponse {
    NSInteger selected = 0;
    if (self.localStatusBtn1)
        selected = 1;
    else if (self.localStatusBtn2)
        selected = 2;
    else if (self.localStatusBtn3)
        selected = 3;
    else if (self.localStatusBtn4)
        selected = 4;
    else if (self.localStatusBtn5)
        selected = 5;
    else if (self.localStatusBtn6)
        selected = 6;
    else if (self.localStatusBtn7)
        selected = 7;
    else if (self.localStatusBtn8)
        selected = 8;
    else if (self.localStatusBtn9)
        selected = 9;
    else if (self.localStatusBtn10)
        selected = 10;
    else if (self.localStatusBtn11)
        selected = 11;
    else if (self.localStatusBtn12)
        selected = 12;
    else if (self.localStatusBtn13)
        selected = 13;
    else if (self.localStatusBtn14)
        selected = 14;
    else if (self.localStatusBtn15)
        selected = 15;
    else if (self.localStatusBtn16)
        selected = 16;
    else if (self.localStatusBtn17)
        selected = 17;
    
    [self.responseDict setObject:@(selected) forKey:@(self.question)];
}

- (void)saveResponse4x4 {
    NSMutableArray *answer;
    NSObject *obj = [self.responseDict objectForKey:@(self.question)];
    
    if (obj == nil) {
        answer = [[NSMutableArray alloc] init];
    }
    else {
        answer = (NSMutableArray *)obj;
    }
    
    // Additions
    //
    if (self.localStatusBtn1 && ![answer containsObject:@(1)])
        [answer addObject:@(1)];
    
    if (self.localStatusBtn2 && ![answer containsObject:@(2)])
        [answer addObject:@(2)];
    
    if (self.localStatusBtn3 && ![answer containsObject:@(3)])
        [answer addObject:@(3)];
    
    if (self.localStatusBtn4 && ![answer containsObject:@(4)])
        [answer addObject:@(4)];
    
    if (self.localStatusBtn5 && ![answer containsObject:@(5)])
        [answer addObject:@(5)];
    
    if (self.localStatusBtn6 && ![answer containsObject:@(6)])
        [answer addObject:@(6)];
    
    if (self.localStatusBtn7 && ![answer containsObject:@(7)])
        [answer addObject:@(7)];
    
    if (self.localStatusBtn8 && ![answer containsObject:@(8)])
        [answer addObject:@(8)];
    
    if (self.localStatusBtn9 && ![answer containsObject:@(9)])
        [answer addObject:@(9)];
    
    if (self.localStatusBtn10 && ![answer containsObject:@(10)])
        [answer addObject:@(10)];
    
    if (self.localStatusBtn11 && ![answer containsObject:@(11)])
        [answer addObject:@(11)];
    
    if (self.localStatusBtn12 && ![answer containsObject:@(12)])
        [answer addObject:@(12)];
    
    if (self.localStatusBtn13 && ![answer containsObject:@(13)])
        [answer addObject:@(13)];
    
    if (self.localStatusBtn14 && ![answer containsObject:@(14)])
        [answer addObject:@(14)];
    
    if (self.localStatusBtn15 && ![answer containsObject:@(15)])
        [answer addObject:@(15)];
    
    if (self.localStatusBtn16 && ![answer containsObject:@(16)])
        [answer addObject:@(16)];
    
    if (self.localStatusBtn17) {
        answer = [[NSMutableArray alloc] init];
        [answer addObject:@(17)];
    }
    
    // Removals
    //
    if (!self.localStatusBtn1)
        [answer removeObject:@(1)];
    
    if (!self.localStatusBtn2)
        [answer removeObject:@(2)];
    
    if (!self.localStatusBtn3)
        [answer removeObject:@(3)];
    
    if (!self.localStatusBtn4)
        [answer removeObject:@(4)];
    
    if (!self.localStatusBtn5)
        [answer removeObject:@(5)];
    
    if (!self.localStatusBtn6)
        [answer removeObject:@(6)];
    
    if (!self.localStatusBtn7)
        [answer removeObject:@(7)];
    
    if (!self.localStatusBtn8)
        [answer removeObject:@(8)];
    
    if (!self.localStatusBtn9)
        [answer removeObject:@(9)];
    
    if (!self.localStatusBtn10)
        [answer removeObject:@(10)];
    
    if (!self.localStatusBtn11)
        [answer removeObject:@(11)];
    
    if (!self.localStatusBtn12)
        [answer removeObject:@(12)];
    
    if (!self.localStatusBtn13)
        [answer removeObject:@(13)];
    
    if (!self.localStatusBtn14)
        [answer removeObject:@(14)];
    
    if (!self.localStatusBtn15)
        [answer removeObject:@(15)];
    
    if (!self.localStatusBtn16)
        [answer removeObject:@(16)];
    
    if (!self.localStatusBtn17)
        [answer removeObject:@(17)];
    
    NSString *local = [NSString stringWithFormat:@"Saving %d: %@", self.question, answer];
    LogDebug(@"Saving %d: %@", self.question, answer);
    
    [MSURVParseHelper LogParse:self.question withStringResponse:local andType:1];
    
    [self.responseDict setObject:answer forKey:@(self.question)];
}

- (void)loadResponse {
    NSInteger selected = [[self.responseDict objectForKey:@(self.question)] integerValue];
    
    switch (selected) {
        case 1: self.localStatusBtn1 = YES;
            break;
            
        case 2: self.localStatusBtn2 = YES;
            break;
            
        case 3: self.localStatusBtn3 = YES;
            break;
            
        case 4: self.localStatusBtn4 = YES;
            break;
            
        case 5: self.localStatusBtn5 = YES;
            break;
            
        case 6: self.localStatusBtn6 = YES;
            break;
            
        case 7: self.localStatusBtn7 = YES;
            break;
            
        case 8: self.localStatusBtn8 = YES;
            break;
            
        case 9: self.localStatusBtn9 = YES;
            break;
            
        case 10: self.localStatusBtn10 = YES;
            break;
            
        case 11: self.localStatusBtn11 = YES;
            break;
            
        case 12: self.localStatusBtn12 = YES;
            break;
            
        case 13: self.localStatusBtn13 = YES;
            break;
            
        case 14: self.localStatusBtn14 = YES;
            break;
            
        case 15: self.localStatusBtn15 = YES;
            break;
            
        case 16: self.localStatusBtn16 = YES;
            break;
            
        case 17: self.localStatusBtn17 = YES;
            break;
    }
}

- (void)loadResponse4x4 {
    NSMutableArray *selected = [self.responseDict objectForKey:@(self.question)];
    
    if (selected == nil) {
        return;
    }
    
    LogDebug(@"%d: %@", self.question, selected);
    
    for (id item in selected) {
        LogDebug(@"Focused on %@", item);
        switch ([item intValue]) {
            case 1: self.localStatusBtn1 = YES;
                LogDebug(@"YES!!");
                break;
                
            case 2: self.localStatusBtn2 = YES;
                break;
                
            case 3: self.localStatusBtn3 = YES;
                break;
                
            case 4: self.localStatusBtn4 = YES;
                break;
                
            case 5: self.localStatusBtn5 = YES;
                break;
                
            case 6: self.localStatusBtn6 = YES;
                break;
                
            case 7: self.localStatusBtn7 = YES;
                break;
                
            case 8: self.localStatusBtn8 = YES;
                break;
                
            case 9: self.localStatusBtn9 = YES;
                break;
                
            case 10: self.localStatusBtn10 = YES;
                break;
                
            case 11: self.localStatusBtn11 = YES;
                break;
                
            case 12: self.localStatusBtn12 = YES;
                break;
                
            case 13: self.localStatusBtn13 = YES;
                break;
                
            case 14: self.localStatusBtn14 = YES;
                break;
                
            case 15: self.localStatusBtn15 = YES;
                break;
                
            case 16: self.localStatusBtn16 = YES;
                break;
                
            case 17: self.localStatusBtn17 = YES;
                break;
        }
    }
}

// Support Operations *****************************************************************************
//
//

// Play sound files
//
- (void)playFile:(NSString *)nameOfFile {
    NSString *tmpFileName = [[NSString alloc] initWithString:nameOfFile];
    NSString *fileName = [[NSBundle mainBundle] pathForResource:tmpFileName ofType:@"wav"];
    
    SystemSoundID soundID;
    CFURLRef soundFileURLRef = (__bridge_retained CFURLRef)[NSURL fileURLWithPath:fileName];
    AudioServicesCreateSystemSoundID(soundFileURLRef, &soundID);
    AudioServicesPlaySystemSound(soundID);
    LogInfo(@"Playing the %@ audio file", nameOfFile);
    //AudioServicesDisposeSystemSoundID(soundID);
    CFRelease(soundFileURLRef);
}

@end
