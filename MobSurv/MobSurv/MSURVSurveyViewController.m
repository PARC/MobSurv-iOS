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


@interface MSURVSurveyViewController ()

// View Types
//      1 - Grid Questions
//      2 - Scroll Questions
//      3 - Info
//      4 - ResponseSummary
//      5 - 4x4 Questions
- (void)displayGridFor:(PFObject *)question;
- (void)displayScrollFor:(PFObject *)question;
- (void)displayInfoFor:(PFObject *)info;
- (void)displayResultsSummaryFor:(PFObject *)summary;
- (void)loadViewForType:(NSNumber *)type withObject:(PFObject *)question;
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

// Audio play
- (void)playFile:(NSString *)nameOfFile;

// Parse Data Helpers
@property PFObject *Survey;
@property NSArray *SurveyDetail;
@property NSMutableDictionary *ImageDictionary;
- (void)retrieveSurveyWithName:(NSString *)name;
- (void)retrieveSurveyDetailsForSurvey:(PFObject *)survey;
- (void)retrieveAllSurveyImages:(NSArray *)questionList;
- (void)replaceInImageDictionary;

// Flow control
@property (weak, atomic) NSNumber *currentStep;

// Response Types
// enum {Nada, Boolean Answer, Number Answer, String Answer, View Open, View
// Next, View Back, SUmmary Response}

@property (weak, nonatomic) IBOutlet UIView *gridView;
@property (weak, nonatomic) IBOutlet UIView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *infoView;
@property (weak, nonatomic) IBOutlet UIView *summaryView;
@property UIAlertView *alertView;

@property int question;
@property int maxQuestion;
@property int keyCount;
@property int imageCount;
@property int currentQuestionType;

// Grid View
@property (weak, nonatomic) IBOutlet UILabel *firstText1;
@property (weak, nonatomic) IBOutlet UIButton *gridButton1;
@property (weak, nonatomic) IBOutlet UIButton *gridButton2;
@property (weak, nonatomic) IBOutlet UIButton *gridButton3;
@property (weak, nonatomic) IBOutlet UIButton *gridButton4;
@property (weak, nonatomic) IBOutlet UIButton *gridButton5;
@property (weak, nonatomic) IBOutlet UIButton *gridButton6;

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

- (void)enlargeButtonImageFor:(UIImage *)anImage;
- (void)updateSelectedStatusImage;

@property NSMutableDictionary *responseDict;

// Scroll View
@property (weak, nonatomic) IBOutlet UIScrollView *scrollQuestions;
@property (weak, nonatomic) IBOutlet UILabel *firstText2;

@property UIButton *scrollButton1;
@property UIButton *scrollButton2;
@property UIButton *scrollButton3;
@property UIButton *scrollButton4;
@property UIButton *scrollButton5;
@property UIButton *scrollButton6;

- (void)scrollButton1Pressed:(UIButton *)sender;
- (void)scrollButton2Pressed:(UIButton *)sender;
- (void)scrollButton3Pressed:(UIButton *)sender;
- (void)scrollButton4Pressed:(UIButton *)sender;
- (void)scrollButton5Pressed:(UIButton *)sender;
- (void)scrollButton6Pressed:(UIButton *)sender;

- (void)updateSelectedScrollStatusImage;

// Info View
@property (weak, nonatomic) IBOutlet UILabel *firstText3;
@property (weak, nonatomic) IBOutlet UIButton *infoImageButton;
@property (weak, nonatomic) IBOutlet UILabel *secondText3;

// Summary Response View
@property (weak, nonatomic) IBOutlet UILabel *firstText4;

@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UIButton *backButton;

// 4x4 View
@property (weak, nonatomic) IBOutlet UIView *fourByFourSubView;
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

@property BOOL statusBtn7;
@property BOOL statusBtn8;
@property BOOL statusBtn9;
@property BOOL statusBtn10;
@property BOOL statusBtn11;
@property BOOL statusBtn12;
@property BOOL statusBtn13;
@property BOOL statusBtn14;
@property BOOL statusBtn15;
@property BOOL statusBtn16;
@property BOOL statusBtn17;

@property UIImage *image7;
@property UIImage *image8;
@property UIImage *image9;
@property UIImage *image10;
@property UIImage *image11;
@property UIImage *image12;
@property UIImage *image13;
@property UIImage *image14;
@property UIImage *image15;
@property UIImage *image16;

- (void)load4x4Images;
- (void)display4x4For:(PFObject *)info;
- (void)updateSelectedFourByFourStatusImage;

- (void)saveResponse4x4;
- (void)loadResponse4x4;

// Parse Logging
- (void)LogParse:(NSInteger)step withNumberResponse:(NSInteger)aNumber andType:(NSInteger)aType;
- (void)LogParse:(NSInteger)step withStringResponse:(NSString *)aString andType:(NSInteger)aType;
- (void)LogParse:(NSInteger)step withBooleanResponse:(BOOL)aBool andType:(NSInteger)aType;

- (void)saveResponse;
- (void)loadResponse;

@end

@implementation MSURVSurveyViewController



- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
	}
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];

	// Custom initialization
	self.question = 0;
	self.ImageDictionary = [[NSMutableDictionary alloc] init];
	self.keyCount = 0;
	self.imageCount = 0;
	self.currentQuestionType = 0;

	// For grid and scroll questions
	self.statusBtn1 = NO;
	self.statusBtn2 = NO;
	self.statusBtn3 = NO;
	self.statusBtn4 = NO;
	self.statusBtn5 = NO;
	self.statusBtn6 = NO;

	// For 4x4 questions
	self.statusBtn7 = NO;
	self.statusBtn8 = NO;
	self.statusBtn9 = NO;
	self.statusBtn10 = NO;
	self.statusBtn11 = NO;
	self.statusBtn12 = NO;
	self.statusBtn13 = NO;
	self.statusBtn14 = NO;
	self.statusBtn15 = NO;
	self.statusBtn16 = NO;
	self.statusBtn17 = NO;

	// Need to select which version of the survey we are delivering

	LogDebug(@"Starting survey \"%@\"", g_surveyName);
	[self retrieveSurveyWithName:g_surveyName];

	self.question += 1;
	LogDebug(@"Load question %d", self.question);

	// Connect double taps to buttons
	[self.gridButton1 addTarget:self action:@selector(multipleTap1:withEvent:) forControlEvents:UIControlEventTouchDownRepeat];
	[self.gridButton2 addTarget:self action:@selector(multipleTap2:withEvent:) forControlEvents:UIControlEventTouchDownRepeat];
	[self.gridButton3 addTarget:self action:@selector(multipleTap3:withEvent:) forControlEvents:UIControlEventTouchDownRepeat];
	[self.gridButton4 addTarget:self action:@selector(multipleTap4:withEvent:) forControlEvents:UIControlEventTouchDownRepeat];
	[self.gridButton5 addTarget:self action:@selector(multipleTap5:withEvent:) forControlEvents:UIControlEventTouchDownRepeat];
	[self.gridButton6 addTarget:self action:@selector(multipleTap6:withEvent:) forControlEvents:UIControlEventTouchDownRepeat];

	// Setup scroll view buttons
	self.scrollButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
	self.scrollButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
	self.scrollButton3 = [UIButton buttonWithType:UIButtonTypeCustom];
	self.scrollButton4 = [UIButton buttonWithType:UIButtonTypeCustom];
	self.scrollButton5 = [UIButton buttonWithType:UIButtonTypeCustom];
	self.scrollButton6 = [UIButton buttonWithType:UIButtonTypeCustom];

	[self.scrollQuestions addSubview:self.scrollButton1];
	[self.scrollQuestions addSubview:self.scrollButton2];
	[self.scrollQuestions addSubview:self.scrollButton3];
	[self.scrollQuestions addSubview:self.scrollButton4];
	[self.scrollQuestions addSubview:self.scrollButton5];
	[self.scrollQuestions addSubview:self.scrollButton6];

	[self.scrollQuestions setContentSize:CGSizeMake(290.0, 1800.0)];

	//[self.view addSubview:self.scrollView];

	self.responseDict = [NSMutableDictionary dictionary];

	NSString *startInfo = [NSString stringWithFormat:@"Started survey - %@", g_surveyName];

	// Parse Logging
	[self LogParse:0 withStringResponse:startInfo andType:0];
}

- (void)LogParse:(NSInteger)step withNumberResponse:(NSInteger)aNumber andType:(NSInteger)aType {
	PFObject *response = [PFObject objectWithClassName:@"Response"];
	response[@"user"] = g_username;
	//LogDebug(@"~~~~~ The user is: %@", g_username);
	response[@"surveyName"] = g_surveyName;
	response[@"participant"] = @(g_participantNumber);
	response[@"step"] = @(step);
	response[@"numberResponse"] = @(aNumber);
	response[@"stringResponse"] = [NSNull null];
	response[@"booleanResponse"] = [NSNull null];
	response[@"type"] = @(aType);
	response[@"mediaTime"] = @(CACurrentMediaTime());
	[response saveEventually];
}

- (void)LogParse:(NSInteger)step withStringResponse:(NSString *)aString andType:(NSInteger)aType {
	PFObject *response = [PFObject objectWithClassName:@"Response"];
	response[@"user"] = g_username;
	//LogDebug(@"~~~~~ The user is: %@", g_username);
	response[@"surveyName"] = g_surveyName;
	response[@"participant"] = @(g_participantNumber);
	response[@"step"] = @(step);
	response[@"numberResponse"] = [NSNull null];
	response[@"stringResponse"] = aString;
	response[@"booleanResponse"] = [NSNull null];
	response[@"type"] = @(aType);
	response[@"mediaTime"] = @(CACurrentMediaTime());
	[response saveEventually];
}

- (void)LogParse:(NSInteger)step withBooleanResponse:(BOOL)aBool andType:(NSInteger)aType {
	PFObject *response = [PFObject objectWithClassName:@"Response"];
	response[@"user"] = g_username;
	//LogDebug(@"~~~~~ The user is: %@", g_username);
	response[@"surveyName"] = g_surveyName;
	response[@"participant"] = @(g_participantNumber);
	response[@"step"] = @(step);
	response[@"numberResponse"] = [NSNull null];
	response[@"stringResponse"] = [NSNull null];
	response[@"booleanResponse"] = @(aBool);
	response[@"type"] = @(aType);
	response[@"mediaTime"] = @(CACurrentMediaTime());
	[response saveEventually];
}

- (void)saveResponse {
	NSInteger selected = 0;
	if (self.statusBtn1)
		selected = 1;
	else if (self.statusBtn2)
		selected = 2;
	else if (self.statusBtn3)
		selected = 3;
	else if (self.statusBtn4)
		selected = 4;
	else if (self.statusBtn5)
		selected = 5;
	else if (self.statusBtn6)
		selected = 6;
	else if (self.statusBtn7)
		selected = 7;
	else if (self.statusBtn8)
		selected = 8;
	else if (self.statusBtn9)
		selected = 9;
	else if (self.statusBtn10)
		selected = 10;
	else if (self.statusBtn11)
		selected = 11;
	else if (self.statusBtn12)
		selected = 12;
	else if (self.statusBtn13)
		selected = 13;
	else if (self.statusBtn14)
		selected = 14;
	else if (self.statusBtn15)
		selected = 15;
	else if (self.statusBtn16)
		selected = 16;
	else if (self.statusBtn17)
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
	if (self.statusBtn1 && ![answer containsObject:@(1)])
		[answer addObject:@(1)];

	if (self.statusBtn2 && ![answer containsObject:@(2)])
		[answer addObject:@(2)];

	if (self.statusBtn3 && ![answer containsObject:@(3)])
		[answer addObject:@(3)];

	if (self.statusBtn4 && ![answer containsObject:@(4)])
		[answer addObject:@(4)];

	if (self.statusBtn5 && ![answer containsObject:@(5)])
		[answer addObject:@(5)];

	if (self.statusBtn6 && ![answer containsObject:@(6)])
		[answer addObject:@(6)];

	if (self.statusBtn7 && ![answer containsObject:@(7)])
		[answer addObject:@(7)];

	if (self.statusBtn8 && ![answer containsObject:@(8)])
		[answer addObject:@(8)];

	if (self.statusBtn9 && ![answer containsObject:@(9)])
		[answer addObject:@(9)];

	if (self.statusBtn10 && ![answer containsObject:@(10)])
		[answer addObject:@(10)];

	if (self.statusBtn11 && ![answer containsObject:@(11)])
		[answer addObject:@(11)];

	if (self.statusBtn12 && ![answer containsObject:@(12)])
		[answer addObject:@(12)];

	if (self.statusBtn13 && ![answer containsObject:@(13)])
		[answer addObject:@(13)];

	if (self.statusBtn14 && ![answer containsObject:@(14)])
		[answer addObject:@(14)];

	if (self.statusBtn15 && ![answer containsObject:@(15)])
		[answer addObject:@(15)];

	if (self.statusBtn16 && ![answer containsObject:@(16)])
		[answer addObject:@(16)];

	if (self.statusBtn17) {
		answer = [[NSMutableArray alloc] init];
		[answer addObject:@(17)];
	}

	// Removals
	//
	if (!self.statusBtn1)
		[answer removeObject:@(1)];

	if (!self.statusBtn2)
		[answer removeObject:@(2)];

	if (!self.statusBtn3)
		[answer removeObject:@(3)];

	if (!self.statusBtn4)
		[answer removeObject:@(4)];

	if (!self.statusBtn5)
		[answer removeObject:@(5)];

	if (!self.statusBtn6)
		[answer removeObject:@(6)];

	if (!self.statusBtn7)
		[answer removeObject:@(7)];

	if (!self.statusBtn8)
		[answer removeObject:@(8)];

	if (!self.statusBtn9)
		[answer removeObject:@(9)];

	if (!self.statusBtn10)
		[answer removeObject:@(10)];

	if (!self.statusBtn11)
		[answer removeObject:@(11)];

	if (!self.statusBtn12)
		[answer removeObject:@(12)];

	if (!self.statusBtn13)
		[answer removeObject:@(13)];

	if (!self.statusBtn14)
		[answer removeObject:@(14)];

	if (!self.statusBtn15)
		[answer removeObject:@(15)];

	if (!self.statusBtn16)
		[answer removeObject:@(16)];

	if (!self.statusBtn17)
		[answer removeObject:@(17)];

	NSString *local = [NSString stringWithFormat:@"Saving %d: %@", self.question, answer];
	LogDebug(@"Saving %d: %@", self.question, answer);

	[self LogParse:self.question withStringResponse:local andType:1];

	[self.responseDict setObject:answer forKey:@(self.question)];
}

- (void)loadResponse {
	NSInteger selected = [[self.responseDict objectForKey:@(self.question)] integerValue];

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

		case 7: self.statusBtn7 = YES;
			break;

		case 8: self.statusBtn8 = YES;
			break;

		case 9: self.statusBtn9 = YES;
			break;

		case 10: self.statusBtn10 = YES;
			break;

		case 11: self.statusBtn11 = YES;
			break;

		case 12: self.statusBtn12 = YES;
			break;

		case 13: self.statusBtn13 = YES;
			break;

		case 14: self.statusBtn14 = YES;
			break;

		case 15: self.statusBtn15 = YES;
			break;

		case 16: self.statusBtn16 = YES;
			break;

		case 17: self.statusBtn17 = YES;
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
			case 1: self.statusBtn1 = YES;
				LogDebug(@"YES!!");
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

			case 7: self.statusBtn7 = YES;
				break;

			case 8: self.statusBtn8 = YES;
				break;

			case 9: self.statusBtn9 = YES;
				break;

			case 10: self.statusBtn10 = YES;
				break;

			case 11: self.statusBtn11 = YES;
				break;

			case 12: self.statusBtn12 = YES;
				break;

			case 13: self.statusBtn13 = YES;
				break;

			case 14: self.statusBtn14 = YES;
				break;

			case 15: self.statusBtn15 = YES;
				break;

			case 16: self.statusBtn16 = YES;
				break;

			case 17: self.statusBtn17 = YES;
				break;
		}
	}
}

- (IBAction)nextButtonPressed:(id)sender {
	if (self.currentQuestionType == 1 || self.currentQuestionType == 2) {
		if (!(self.statusBtn1 == YES || self.statusBtn2 == YES || self.statusBtn3 == YES ||
		      self.statusBtn4 == YES || self.statusBtn5 == YES || self.statusBtn6 == YES)) {
			// No selection has been made, need to answer
			LogDebug(@"Need to select an answer before moving on!");

			NSString *alertTitle = @"No answer?";
			NSString *alertMessage = @"Please select one of the images that best answers the question.";
			UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:alertTitle
			                                                   message:alertMessage
			                                                  delegate:self
			                                         cancelButtonTitle:@"OK"
			                                         otherButtonTitles:nil];
			[theAlert show];
			[self LogParse:self.question withStringResponse:@"Next failed" andType:400];
			return;
		}
	}

	if (self.currentQuestionType == 5) {
		if (!(self.statusBtn1 == YES || self.statusBtn2 == YES || self.statusBtn3 == YES ||
		      self.statusBtn4 == YES || self.statusBtn5 == YES || self.statusBtn6 == YES ||
		      self.statusBtn7 == YES || self.statusBtn8 == YES || self.statusBtn9 == YES ||
		      self.statusBtn10 == YES || self.statusBtn11 == YES || self.statusBtn12 == YES ||
		      self.statusBtn13 == YES || self.statusBtn14 == YES || self.statusBtn15 == YES ||
		      self.statusBtn16 == YES || self.statusBtn17 == YES)) {
			// No selection has been made, need to answer
			LogDebug(@"Need to select an answer before moving on!");

			NSString *alertTitle = @"No answer?";
			NSString *alertMessage = @"Please select one of the images that best answers the question.";
			UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:alertTitle
			                                                   message:alertMessage
			                                                  delegate:self
			                                         cancelButtonTitle:@"OK"
			                                         otherButtonTitles:nil];
			[theAlert show];
			[self LogParse:self.question withStringResponse:@"Next failed" andType:400];
			return;
		}
	}

	if (self.question == self.maxQuestion) {
		LogDebug(@"Survey complete.");
		[self LogParse:self.question withStringResponse:@"Survey complete" andType:2];
		[self performSegueWithIdentifier:@"backToStart" sender:self];

		// Log entire responses
		LogDebug(@"Dictionary:%@", self.responseDict);
		NSString *recordedResponses = [NSString stringWithFormat:@"%@", self.responseDict];
		[self LogParse:self.question withStringResponse:recordedResponses andType:5];

		return;
	}

	// Record response
	if (self.currentQuestionType == 1 || self.currentQuestionType == 2) {
		[self saveResponse];
	}
	else if (self.currentQuestionType == 5) {
		[self saveResponse4x4];
	}

	[self LogParse:self.question withStringResponse:@"Next question" andType:1];

	self.question += 1;

	if (self.question >= self.maxQuestion)
		self.question = self.maxQuestion;


	// Clear status before switch
	self.statusBtn1 = NO;
	self.statusBtn2 = NO;
	self.statusBtn3 = NO;
	self.statusBtn4 = NO;
	self.statusBtn5 = NO;
	self.statusBtn6 = NO;
	self.statusBtn7 = NO;
	self.statusBtn8 = NO;
	self.statusBtn9 = NO;
	self.statusBtn10 = NO;
	self.statusBtn11 = NO;
	self.statusBtn12 = NO;
	self.statusBtn13 = NO;
	self.statusBtn14 = NO;
	self.statusBtn15 = NO;
	self.statusBtn16 = NO;
	self.statusBtn17 = NO;
	if (self.currentQuestionType == 1) {
		[self updateSelectedStatusImage];
	}
	else if (self.currentQuestionType == 2) {
		[self updateSelectedScrollStatusImage];
	}
	else if (self.currentQuestionType == 5) {
		[self updateSelectedFourByFourStatusImage];
	}

	LogDebug(@"Load question %d", self.question);

	if ((self.question + 1) > self.maxQuestion) {
		[self.nextButton setTitle:@"Leave Survey" forState:UIControlStateNormal];
		[[self.nextButton imageView] setContentMode:UIViewContentModeScaleAspectFit];
		[self.nextButton setBackgroundImage:[UIImage imageNamed:@"green.png"]
		                           forState:UIControlStateNormal];
	}
	else {
		NSString *buttonInfo =
		    [NSString stringWithFormat:@"Next (%d of %d)", (self.question + 1),
		     self.maxQuestion];
		[self.nextButton setTitle:buttonInfo forState:UIControlStateNormal];
	}

	PFObject *question = [self.SurveyDetail objectAtIndex:(self.question - 1)];
	LogDebug(@"Object [%d]: %@", (self.question - 1), question);
	[self loadViewForType:question[@"type"] withObject:question];
	[self playFile:@"55845__sergenious__pushbutn"];

	// Restore response
	if (self.currentQuestionType == 1) {
		[self loadResponse];
		[self updateSelectedStatusImage];
	}
	else if (self.currentQuestionType == 2) {
		[self loadResponse];
		[self updateSelectedScrollStatusImage];
	}
	else if (self.currentQuestionType == 5) {
		[self loadResponse4x4];
		[self updateSelectedFourByFourStatusImage];
	}
}

- (IBAction)backButtonPressed:(id)sender {
	[self LogParse:self.question withStringResponse:@"Back question" andType:1];

	if (self.currentQuestionType == 1 || self.currentQuestionType == 2) {
		[self saveResponse];
	}
	else if (self.currentQuestionType == 5) {
		[self saveResponse4x4];
	}

	self.question -= 1;

	if (self.question <= 0) {
		self.question = 1;

		// Warning to make sure that the user gives consent to trash all recorded responses
		NSString *alertTitle = @"Leave Survey?";
		NSString *alertMessage = @"All answers will be lost if you leave the survey.";
		UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:alertTitle
		                                                   message:alertMessage
		                                                  delegate:self
		                                         cancelButtonTitle:@"Stay"
		                                         otherButtonTitles:@"Leave", nil];

		[theAlert show];
	}

	// Clear status before switch
	self.statusBtn1 = NO;
	self.statusBtn2 = NO;
	self.statusBtn3 = NO;
	self.statusBtn4 = NO;
	self.statusBtn5 = NO;
	self.statusBtn6 = NO;
	self.statusBtn7 = NO;
	self.statusBtn8 = NO;
	self.statusBtn9 = NO;
	self.statusBtn10 = NO;
	self.statusBtn11 = NO;
	self.statusBtn12 = NO;
	self.statusBtn13 = NO;
	self.statusBtn14 = NO;
	self.statusBtn15 = NO;
	self.statusBtn16 = NO;
	self.statusBtn17 = NO;
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
		[self loadResponse];
		[self updateSelectedStatusImage];
	}
	else if (self.currentQuestionType == 2) {
		[self loadResponse];
		[self updateSelectedScrollStatusImage];
	}
	else if (self.currentQuestionType == 5) {
		[self loadResponse4x4];
		[self updateSelectedFourByFourStatusImage];
	}
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 0) {
		LogDebug(@"Yep");
		//[self LogParse:self.question withStringResponse:@"Decided to stay" andType:6];
	}
	else if (buttonIndex == 1) {
		LogDebug(@"User opted to leave");
		[self LogParse:self.question withStringResponse:@"Left survey" andType:400];
		[self performSegueWithIdentifier:@"surveyList" sender:self];
	}
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (void)retrieveSurveyWithName:(NSString *)name {
	UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc]
	                                    initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	[spinner setCenter:CGPointMake(140, 100)];

	NSString *messageTitleToUser = @"Survey";
	self.alertView = [[UIAlertView alloc] initWithTitle:messageTitleToUser
	                                            message:@"loading..."
	                                           delegate:self
	                                  cancelButtonTitle:nil
	                                  otherButtonTitles:nil];

	[self.alertView addSubview:spinner];
	[spinner startAnimating];
	[self.alertView show];

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

	        NSString *buttonInfo =
	            [NSString stringWithFormat:@"Next (%d of %d)", (self.question + 1),
	             self.maxQuestion];
	        [self.nextButton setTitle:buttonInfo forState:UIControlStateNormal];

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
	    //[self retrieveAllSurveyImages:self.SurveyDetail];
	}];
}

- (void)retrieveAllSurveyImages:(NSArray *)questionList {
	LogDebug(@"Caching images --");
	self.imageCount = 0;
	for (PFObject *question in questionList) {
		LogDebug(@"Q: %@", question[@"firstText"]);

		NSNumber *type = question[@"type"];
		LogDebug(@"Type: %@", type);

		switch ([type intValue]) {
			case 1: {
				LogDebug(@"Processing images in type 1 question...");
				PFFile *userImageFile = question[@"button1image"];
				if (userImageFile != NULL) {
					[self.ImageDictionary setObject:userImageFile
					                         forKey:userImageFile.name];
					self.imageCount += 1;
				}
				userImageFile = question[@"button2image"];
				if (userImageFile != NULL) {
					[self.ImageDictionary setObject:userImageFile
					                         forKey:userImageFile.name];
					self.imageCount += 1;
				}
				userImageFile = question[@"button3image"];
				if (userImageFile != NULL) {
					[self.ImageDictionary setObject:userImageFile
					                         forKey:userImageFile.name];
					self.imageCount += 1;
				}
				userImageFile = question[@"button4image"];
				if (userImageFile != NULL) {
					[self.ImageDictionary setObject:userImageFile
					                         forKey:userImageFile.name];
					self.imageCount += 1;
				}
				userImageFile = question[@"button5image"];
				if (userImageFile != NULL) {
					[self.ImageDictionary setObject:userImageFile
					                         forKey:userImageFile.name];
					self.imageCount += 1;
				}
				userImageFile = question[@"button6image"];
				if (userImageFile != NULL) {
					[self.ImageDictionary setObject:userImageFile
					                         forKey:userImageFile.name];
					self.imageCount += 1;
				}
				break;
			}

			case 2: {
				LogDebug(@"Processing images in type 2 question...");
				PFFile *userImageFile = question[@"button1image"];
				if (userImageFile != NULL) {
					[self.ImageDictionary setObject:userImageFile
					                         forKey:userImageFile.name];
					self.imageCount += 1;
				}
				userImageFile = question[@"button2image"];
				if (userImageFile != NULL) {
					[self.ImageDictionary setObject:userImageFile
					                         forKey:userImageFile.name];
					self.imageCount += 1;
				}
				userImageFile = question[@"button3image"];
				if (userImageFile != NULL) {
					[self.ImageDictionary setObject:userImageFile
					                         forKey:userImageFile.name];
					self.imageCount += 1;
				}
				userImageFile = question[@"button4image"];
				if (userImageFile != NULL) {
					[self.ImageDictionary setObject:userImageFile
					                         forKey:userImageFile.name];
					self.imageCount += 1;
				}
				userImageFile = question[@"button5image"];
				if (userImageFile != NULL) {
					[self.ImageDictionary setObject:userImageFile
					                         forKey:userImageFile.name];
					self.imageCount += 1;
				}
				userImageFile = question[@"button6image"];
				if (userImageFile != NULL) {
					[self.ImageDictionary setObject:userImageFile
					                         forKey:userImageFile.name];
					self.imageCount += 1;
				}
				break;
			}

			case 3: {
				LogDebug(@"Processing images in type 3 question...");
				PFFile *userImageFile = question[@"pageImage"];
				if (userImageFile != NULL) {
					[self.ImageDictionary setObject:userImageFile
					                         forKey:userImageFile.name];
					self.imageCount += 1;
				}
				break;
			}

			case 4: {
				LogDebug(@"Processing images in type 4 question...");
				break;
			}

			case 5: {
				LogDebug(@"Loading the set of images for the 4x4!!");
				break;
			}

			default:
				LogError(@"Default switch-case error fall through!");
		}
	}

	LogDebug(@"-- replacing images.");
	self.keyCount = 0;
	[self replaceInImageDictionary];
}

- (void)load4x4Images {
	LogDebug(@"Loading 16 images from Parse!!");
}

- (void)replaceInImageDictionary {
	LogDebug(@"Replacing images in the dictionary (%lu) ...",
	         (unsigned long)self.ImageDictionary.count);
	for (NSString *key in[self.ImageDictionary allKeys]) {
		PFFile *imageObject = [self.ImageDictionary objectForKey:key];
		LogDebug(@"...Loading file %@", imageObject.name);
		[imageObject
		 getDataInBackgroundWithBlock: ^(NSData *imageData, NSError *error) {
		    self.keyCount += 1;
		    if (!error) {
		        UIImage *image = [UIImage imageWithData:imageData];
		        LogDebug(@"...File description %@", image.description);

		        if (self.keyCount == self.imageCount - 1) {
		            PFObject *question = [self.SurveyDetail objectAtIndex:0];
		            LogDebug(@"Object: %@", question);
		            [self loadViewForType:question[@"type"] withObject:question];
				}
			}
		    else {
		        // Log details of the failure
		        LogDebug(@"Error: %@ %@", error, [error userInfo]);
			}
		}];
	}
}

- (void)loadViewForType:(NSNumber *)type withObject:(PFObject *)question {
	switch ([type intValue]) {
		case 1:
			[self displayGridFor:question];
			[self LogParse:self.question withStringResponse:@"Loaded grid question" andType:1];
			break;

		case 2:
			[self displayScrollFor:question];
			[self LogParse:self.question withStringResponse:@"Loaded scroll question" andType:1];
			break;

		case 3:
			[self displayInfoFor:question];
			[self LogParse:self.question withStringResponse:@"Loaded display info" andType:1];
			break;

		case 4:
			[self displayResultsSummaryFor:question];
			[self LogParse:self.question withStringResponse:@"Loaded results summary" andType:1];
			break;

		case 5:
			[self display4x4For:question];
			[self LogParse:self.question withStringResponse:@"Loaded 4x4 question" andType:1];
			break;
	}
}

- (void)displayGridFor:(PFObject *)question {
	[[self.nextButton imageView] setContentMode:UIViewContentModeScaleAspectFit];
	[self.nextButton setBackgroundImage:[UIImage imageNamed:@"red.png"]
	                           forState:UIControlStateNormal];

	self.currentQuestionType = 1;

	// Question
	[self.view addSubview:self.gridView];
	self.firstText1.text = question[@"firstText"];

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
		}
	    else {
	        // Log details of the failure
	        LogDebug(@"Error: %@ %@", error, [error userInfo]);
		}
	}];

	// Restore state of this question if had been answered
}

- (void)displayScrollFor:(PFObject *)question {
	[[self.nextButton imageView] setContentMode:UIViewContentModeScaleAspectFit];
	[self.nextButton setBackgroundImage:[UIImage imageNamed:@"red.png"]
	                           forState:UIControlStateNormal];

	self.currentQuestionType = 2;

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
		}
	    else {
	        // Log details of the failure
	        LogDebug(@"Error: %@ %@", error, [error userInfo]);
		}
	}];

	[self.scrollQuestions setContentOffset:CGPointMake(0, -self.scrollQuestions.contentInset.top) animated:YES];
	[self.view addSubview:self.scrollView];
	self.firstText2.text = question[@"firstText"];
}

- (void)displayInfoFor:(PFObject *)info {
	[[self.nextButton imageView] setContentMode:UIViewContentModeScaleAspectFit];
	[self.nextButton setBackgroundImage:[UIImage imageNamed:@"red.png"]
	                           forState:UIControlStateNormal];

	self.currentQuestionType = 3;

	[self.view addSubview:self.infoView];
	self.firstText3.text = info[@"firstText"];

	PFFile *imageObject = info[@"pageImage"];
	// UIImage *btnImage = [self.ImageDictionary objectForKey:userImageFile.name];
	[imageObject
	 getDataInBackgroundWithBlock: ^(NSData *imageData, NSError *error) {
	    if (!error) {
	        UIImage *image = [UIImage imageWithData:imageData];
	        LogDebug(@"...File description %@", image.description);

	        [[self.infoImageButton imageView]
	         setContentMode:UIViewContentModeScaleAspectFit];
	        [self.infoImageButton setBackgroundImage:image
	                                        forState:UIControlStateNormal];
		}
	    else {
	        // Log details of the failure
	        LogDebug(@"Error: %@ %@", error, [error userInfo]);
		}
	}];

	self.secondText3.text = info[@"secondText"];
	[self.nextButton setBackgroundImage:[UIImage imageNamed:@"green.png"]
	                           forState:UIControlStateNormal];
}

- (void)displayResultsSummaryFor:(PFObject *)summary {
	[[self.nextButton imageView] setContentMode:UIViewContentModeScaleAspectFit];
	[self.nextButton setBackgroundImage:[UIImage imageNamed:@"red.png"]
	                           forState:UIControlStateNormal];

	self.currentQuestionType = 4;

	[self.view addSubview:self.summaryView];
	self.firstText4.text = summary[@"firstText"];

	//[self.nextButton setBackgroundImage:[UIImage imageNamed:@"green.png"]
	//forState:UIControlStateNormal];
}

- (void)loadIntoButton:(UIButton *)aButton anImage:(PFFile *)imageObject {
	[imageObject
	 getDataInBackgroundWithBlock: ^(NSData *imageData, NSError *error) {
	    if (!error) {
	        UIImage *image = [UIImage imageWithData:imageData];
	        LogDebug(@"...File description %@", image.description);

	        [[aButton imageView] setContentMode:UIViewContentModeScaleAspectFit];
	        [aButton setBackgroundImage:image
	                           forState:UIControlStateNormal];
		}
	    else {
	        // Log details of the failure
	        LogDebug(@"Error: %@ %@", error, [error userInfo]);
		}
	}];
}

- (void)loadImagesIntoButtonsFor4x4:(NSArray *)objects {
	for (PFObject *object in objects) {
		NSInteger order = [object[@"order"] integerValue] + 1;

		switch (order) {
			case 1:[self loadIntoButton:self.fourByFourButton1 anImage:object[@"image"]];
				LogDebug(@"-- 1 Loading image into button");
				break;

			case 2:[self loadIntoButton:self.fourByFourButton2 anImage:object[@"image"]];
				LogDebug(@"-- 2 Loading image into button");
				break;

			case 3:[self loadIntoButton:self.fourByFourButton3 anImage:object[@"image"]];
				LogDebug(@"-- 3 Loading image into button");
				break;

			case 4:[self loadIntoButton:self.fourByFourButton4 anImage:object[@"image"]];
				LogDebug(@"-- 4 Loading image into button");
				break;

			case 5:[self loadIntoButton:self.fourByFourButton5 anImage:object[@"image"]];
				LogDebug(@"-- 5 Loading image into button");
				break;

			case 6:[self loadIntoButton:self.fourByFourButton6 anImage:object[@"image"]];
				LogDebug(@"-- 6 Loading image into button");
				break;

			case 7:[self loadIntoButton:self.fourByFourButton7 anImage:object[@"image"]];
				LogDebug(@"-- 7 Loading image into button");
				break;

			case 8:[self loadIntoButton:self.fourByFourButton8 anImage:object[@"image"]];
				LogDebug(@"-- 8 Loading image into button");
				break;

			case 9:[self loadIntoButton:self.fourByFourButton9 anImage:object[@"image"]];
				LogDebug(@"-- 9 Loading image into button");
				break;

			case 10:[self loadIntoButton:self.fourByFourButton10 anImage:object[@"image"]];
				LogDebug(@"-- 10 Loading image into button");
				break;

			case 11:[self loadIntoButton:self.fourByFourButton11 anImage:object[@"image"]];
				LogDebug(@"-- 11 Loading image into button");
				break;

			case 12:[self loadIntoButton:self.fourByFourButton12 anImage:object[@"image"]];
				LogDebug(@"-- 12 Loading image into button");
				break;

			case 13:[self loadIntoButton:self.fourByFourButton13 anImage:object[@"image"]];
				LogDebug(@"-- 13 Loading image into button");
				break;

			case 14:[self loadIntoButton:self.fourByFourButton14 anImage:object[@"image"]];
				LogDebug(@"-- 14 Loading image into button");
				break;

			case 15:[self loadIntoButton:self.fourByFourButton15 anImage:object[@"image"]];
				LogDebug(@"-- 15 Loading image into button");
				break;

			case 16:[self loadIntoButton:self.fourByFourButton16 anImage:object[@"image"]];
				LogDebug(@"-- 16 Loading image into button");
				break;
		}
	}
}

- (void)display4x4For:(PFObject *)info {
	[[self.nextButton imageView] setContentMode:UIViewContentModeScaleAspectFit];
	[self.nextButton setBackgroundImage:[UIImage imageNamed:@"red.png"]
	                           forState:UIControlStateNormal];

	self.currentQuestionType = 5;

	// Need to attach the 16 grid images to the buttons
	NSString *objId = info.objectId;
	LogDebug(@"4x4 loading images for question %@", objId);

	PFQuery *query = [PFQuery queryWithClassName:@"GridImages"];
	[query whereKey:@"uniqueName" equalTo:objId];

	[query findObjectsInBackgroundWithBlock: ^(NSArray *objects, NSError *error) {
	    if (!error) {
	        // The find succeeded.
	        LogDebug(@"Successfully retrieved %lu image references.", (unsigned long)objects.count);
	        // Do something with the found objects
	        for (PFObject * object in objects) {
	            LogDebug(@"%@", object.objectId);
			}
	        [self loadImagesIntoButtonsFor4x4:objects];
		}
	    else {
	        // Log details of the failure
	        LogDebug(@"Error: %@ %@", error, [error userInfo]);
		}
	}];

	[self.view addSubview:self.fourByFourSubView];
	self.firstText5.text = info[@"firstText"];
}

- (IBAction)infoImageButtonPressed:(id)sender {
	[self LogParse:self.question withStringResponse:@"Pressed the info image" andType:1];
	[self playFile:@"235167__reitanna__giggle2"];
}

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

/*
   #pragma mark - Navigation

   // In a storyboard-based application, you will often want to do a little
   preparation before navigation
   - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
   {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
   }
 */

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
		[self.nextButton setBackgroundImage:[UIImage imageNamed:@"red.png"]
		                           forState:UIControlStateNormal];
	}
	else {
		[self.nextButton setBackgroundImage:[UIImage imageNamed:@"green.png"]
		                           forState:UIControlStateNormal];
	}
}

// ****************************************** Grid Button Handling

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
		[self LogParse:self.question withNumberResponse:1 andType:1];
	}
	else {
		self.statusBtn1 = NO;
		[self LogParse:self.question withNumberResponse:0 andType:1];
	}
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
		[self LogParse:self.question withNumberResponse:2 andType:1];
	}
	else {
		self.statusBtn2 = NO;
		[self LogParse:self.question withNumberResponse:0 andType:1];
	}
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
		[self LogParse:self.question withNumberResponse:3 andType:1];
	}
	else {
		self.statusBtn3 = NO;
		[self LogParse:self.question withNumberResponse:0 andType:1];
	}
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
		[self LogParse:self.question withNumberResponse:4 andType:1];
	}
	else {
		self.statusBtn4 = NO;
		[self LogParse:self.question withNumberResponse:0 andType:1];
	}
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
		[self LogParse:self.question withNumberResponse:5 andType:1];
	}
	else {
		self.statusBtn5 = NO;
		[self LogParse:self.question withNumberResponse:0 andType:1];
	}
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
		[self LogParse:self.question withNumberResponse:6 andType:1];
	}
	else {
		self.statusBtn6 = NO;
		[self LogParse:self.question withNumberResponse:0 andType:1];
	}
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

//******************************************** Scroll Button Handling

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
		[self.nextButton setBackgroundImage:[UIImage imageNamed:@"red.png"]
		                           forState:UIControlStateNormal];
	}
	else {
		[self.nextButton setBackgroundImage:[UIImage imageNamed:@"green.png"]
		                           forState:UIControlStateNormal];
	}
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
		[self LogParse:self.question withNumberResponse:1 andType:1];
	}
	else {
		self.statusBtn1 = NO;
		[self LogParse:self.question withNumberResponse:0 andType:1];
	}
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
		[self LogParse:self.question withNumberResponse:1 andType:1];
	}
	else {
		self.statusBtn2 = NO;
		[self LogParse:self.question withNumberResponse:0 andType:1];
	}
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
		[self LogParse:self.question withNumberResponse:1 andType:1];
	}
	else {
		self.statusBtn3 = NO;
		[self LogParse:self.question withNumberResponse:0 andType:1];
	}
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
		[self LogParse:self.question withNumberResponse:1 andType:1];
	}
	else {
		self.statusBtn4 = NO;
		[self LogParse:self.question withNumberResponse:0 andType:1];
	}
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
		[self LogParse:self.question withNumberResponse:1 andType:1];
	}
	else {
		self.statusBtn5 = NO;
		[self LogParse:self.question withNumberResponse:0 andType:1];
	}
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
		[self LogParse:self.question withNumberResponse:1 andType:1];
	}
	else {
		self.statusBtn6 = NO;
		[self LogParse:self.question withNumberResponse:0 andType:1];
	}
	[self updateSelectedScrollStatusImage];
}

//********************************************* 4x4 question handling

- (void)updateSelectedFourByFourStatusImage {
	UIImage *anImage = [[UIImage imageNamed:@"cornerCheck"] resizedImageByMagick:@"65x65#"];

	LogDebug(@"updateSelectedFourByFourStatusImage");

	if (self.statusBtn1 == NO) {
		[self.fourByFourButton1 setImage:nil forState:UIControlStateNormal];
	}
	else {
		[self.fourByFourButton1 setImage:anImage forState:UIControlStateNormal];
	}

	if (self.statusBtn2 == NO) {
		[self.fourByFourButton2 setImage:nil forState:UIControlStateNormal];
	}
	else {
		[self.fourByFourButton2 setImage:anImage forState:UIControlStateNormal];
	}

	if (self.statusBtn3 == NO) {
		[self.fourByFourButton3 setImage:nil forState:UIControlStateNormal];
	}
	else {
		[self.fourByFourButton3 setImage:anImage forState:UIControlStateNormal];
	}

	if (self.statusBtn4 == NO) {
		[self.fourByFourButton4 setImage:nil forState:UIControlStateNormal];
	}
	else {
		[self.fourByFourButton4 setImage:anImage forState:UIControlStateNormal];
	}

	if (self.statusBtn5 == NO) {
		[self.fourByFourButton5 setImage:nil forState:UIControlStateNormal];
	}
	else {
		[self.fourByFourButton5 setImage:anImage forState:UIControlStateNormal];
	}

	if (self.statusBtn6 == NO) {
		[self.fourByFourButton6 setImage:nil forState:UIControlStateNormal];
	}
	else {
		[self.fourByFourButton6 setImage:anImage forState:UIControlStateNormal];
	}

	if (self.statusBtn7 == NO) {
		[self.fourByFourButton7 setImage:nil forState:UIControlStateNormal];
	}
	else {
		[self.fourByFourButton7 setImage:anImage forState:UIControlStateNormal];
	}

	if (self.statusBtn8 == NO) {
		[self.fourByFourButton8 setImage:nil forState:UIControlStateNormal];
	}
	else {
		[self.fourByFourButton8 setImage:anImage forState:UIControlStateNormal];
	}

	if (self.statusBtn9 == NO) {
		[self.fourByFourButton9 setImage:nil forState:UIControlStateNormal];
	}
	else {
		[self.fourByFourButton9 setImage:anImage forState:UIControlStateNormal];
	}

	if (self.statusBtn10 == NO) {
		[self.fourByFourButton10 setImage:nil forState:UIControlStateNormal];
	}
	else {
		[self.fourByFourButton10 setImage:anImage forState:UIControlStateNormal];
	}

	if (self.statusBtn11 == NO) {
		[self.fourByFourButton11 setImage:nil forState:UIControlStateNormal];
	}
	else {
		[self.fourByFourButton11 setImage:anImage forState:UIControlStateNormal];
	}

	if (self.statusBtn12 == NO) {
		[self.fourByFourButton12 setImage:nil forState:UIControlStateNormal];
	}
	else {
		[self.fourByFourButton12 setImage:anImage forState:UIControlStateNormal];
	}

	if (self.statusBtn13 == NO) {
		[self.fourByFourButton13 setImage:nil forState:UIControlStateNormal];
	}
	else {
		[self.fourByFourButton13 setImage:anImage forState:UIControlStateNormal];
	}

	if (self.statusBtn14 == NO) {
		[self.fourByFourButton14 setImage:nil forState:UIControlStateNormal];
	}
	else {
		[self.fourByFourButton14 setImage:anImage forState:UIControlStateNormal];
	}

	if (self.statusBtn15 == NO) {
		[self.fourByFourButton15 setImage:nil forState:UIControlStateNormal];
	}
	else {
		[self.fourByFourButton15 setImage:anImage forState:UIControlStateNormal];
	}

	if (self.statusBtn16 == NO) {
		[self.fourByFourButton16 setImage:nil forState:UIControlStateNormal];
	}
	else {
		[self.fourByFourButton16 setImage:anImage forState:UIControlStateNormal];
	}

	if (self.statusBtn17 == NO) {
		[self.fourByFourButton17 setTitleColor:[UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:1.0] forState:UIControlStateNormal];
	}
	else {
		[self.fourByFourButton17 setTitleColor:[UIColor colorWithRed:0 / 255.0 green:153 / 255.0 blue:0 / 255.0 alpha:1.0] forState:UIControlStateNormal];
	}

	if (!(self.statusBtn1 == YES || self.statusBtn2 == YES || self.statusBtn3 == YES ||
	      self.statusBtn4 == YES || self.statusBtn5 == YES || self.statusBtn6 == YES ||
	      self.statusBtn7 == YES || self.statusBtn8 == YES || self.statusBtn9 == YES ||
	      self.statusBtn10 == YES || self.statusBtn11 == YES || self.statusBtn12 == YES ||
	      self.statusBtn13 == YES || self.statusBtn14 == YES || self.statusBtn15 == YES ||
	      self.statusBtn16 == YES || self.statusBtn17 == YES)) {
		[self.nextButton setBackgroundImage:[UIImage imageNamed:@"red.png"]
		                           forState:UIControlStateNormal];
	}
	else {
		[self.nextButton setBackgroundImage:[UIImage imageNamed:@"green.png"]
		                           forState:UIControlStateNormal];
	}
}

- (IBAction)fourByFourButton1Pressed:(id)sender {
	LogDebug(@"4x4 button 1 pressed.");
	if (self.statusBtn1) {
		self.statusBtn1 = NO;
		[self LogParse:self.question withStringResponse:@"Button 1 deselected" andType:1];
	}
	else {
		self.statusBtn1 = YES;
		[self LogParse:self.question withStringResponse:@"Button 1 selected" andType:1];
	}
	self.statusBtn17 = NO;
	[self updateSelectedFourByFourStatusImage];
}

- (IBAction)fourByFourButton2Pressed:(id)sender {
	LogDebug(@"4x4 button 2 pressed.");
	if (self.statusBtn2) {
		self.statusBtn2 = NO;
		[self LogParse:self.question withStringResponse:@"Button 2 deselected" andType:1];
	}
	else {
		self.statusBtn2 = YES;
		[self LogParse:self.question withStringResponse:@"Button 2 selected" andType:1];
	}
	self.statusBtn17 = NO;
	[self updateSelectedFourByFourStatusImage];
}

- (IBAction)fourByFourButton3Pressed:(id)sender {
	LogDebug(@"4x4 button 3 pressed.");
	if (self.statusBtn3) {
		self.statusBtn3 = NO;
		[self LogParse:self.question withStringResponse:@"Button 3 deselected" andType:1];
	}
	else {
		self.statusBtn3 = YES;
		[self LogParse:self.question withStringResponse:@"Button 3 selected" andType:1];
	}
	self.statusBtn17 = NO;
	[self updateSelectedFourByFourStatusImage];
}

- (IBAction)fourByFourButton4Pressed:(id)sender {
	LogDebug(@"4x4 button 4 pressed.");
	if (self.statusBtn4) {
		self.statusBtn4 = NO;
		[self LogParse:self.question withStringResponse:@"Button 4 deselected" andType:1];
	}
	else {
		self.statusBtn4 = YES;
		[self LogParse:self.question withStringResponse:@"Button 4 selected" andType:1];
	}
	self.statusBtn17 = NO;
	[self updateSelectedFourByFourStatusImage];
}

- (IBAction)fourByFourButton5Pressed:(id)sender {
	LogDebug(@"4x4 button 5 pressed.");
	if (self.statusBtn5) {
		self.statusBtn5 = NO;
		[self LogParse:self.question withStringResponse:@"Button 5 deselected" andType:1];
	}
	else {
		self.statusBtn5 = YES;
		[self LogParse:self.question withStringResponse:@"Button 5 selected" andType:1];
	}
	self.statusBtn17 = NO;
	[self updateSelectedFourByFourStatusImage];
}

- (IBAction)fourByFourButton6Pressed:(id)sender {
	LogDebug(@"4x4 button 6 pressed.");
	if (self.statusBtn6) {
		self.statusBtn6 = NO;
		[self LogParse:self.question withStringResponse:@"Button 6 deselected" andType:1];
	}
	else {
		self.statusBtn6 = YES;
		[self LogParse:self.question withStringResponse:@"Button 6 selected" andType:1];
	}
	self.statusBtn17 = NO;
	[self updateSelectedFourByFourStatusImage];
}

- (IBAction)fourByFourButton7Pressed:(id)sender {
	LogDebug(@"4x4 button 7 pressed.");
	if (self.statusBtn7) {
		self.statusBtn7 = NO;
		[self LogParse:self.question withStringResponse:@"Button 7 deselected" andType:1];
	}
	else {
		self.statusBtn7 = YES;
		[self LogParse:self.question withStringResponse:@"Button 7 selected" andType:1];
	}
	self.statusBtn17 = NO;
	[self updateSelectedFourByFourStatusImage];
}

- (IBAction)fourByFourButton8Pressed:(id)sender {
	LogDebug(@"4x4 button 8 pressed.");
	if (self.statusBtn8) {
		self.statusBtn8 = NO;
		[self LogParse:self.question withStringResponse:@"Button 8 deselected" andType:1];
	}
	else {
		self.statusBtn8 = YES;
		[self LogParse:self.question withStringResponse:@"Button 8 selected" andType:1];
	}
	self.statusBtn17 = NO;
	[self updateSelectedFourByFourStatusImage];
}

- (IBAction)fourByFourButton9Pressed:(id)sender {
	LogDebug(@"4x4 button 9 pressed.");
	if (self.statusBtn9) {
		self.statusBtn9 = NO;
		[self LogParse:self.question withStringResponse:@"Button 9 deselected" andType:1];
	}
	else {
		self.statusBtn9 = YES;
		[self LogParse:self.question withStringResponse:@"Button 9 selected" andType:1];
	}
	self.statusBtn17 = NO;
	[self updateSelectedFourByFourStatusImage];
}

- (IBAction)fourByFourButton10Pressed:(id)sender {
	LogDebug(@"4x4 button 10 pressed.");
	if (self.statusBtn10) {
		self.statusBtn10 = NO;
		[self LogParse:self.question withStringResponse:@"Button 10 deselected" andType:1];
	}
	else {
		self.statusBtn10 = YES;
		[self LogParse:self.question withStringResponse:@"Button 10 selected" andType:1];
	}
	self.statusBtn17 = NO;
	[self updateSelectedFourByFourStatusImage];
}

- (IBAction)fourByFourButton11Pressed:(id)sender {
	LogDebug(@"4x4 button 11 pressed.");
	if (self.statusBtn11) {
		self.statusBtn11 = NO;
		[self LogParse:self.question withStringResponse:@"Button 11 deselected" andType:1];
	}
	else {
		self.statusBtn11 = YES;
		[self LogParse:self.question withStringResponse:@"Button 11 selected" andType:1];
	}
	self.statusBtn17 = NO;
	[self updateSelectedFourByFourStatusImage];
}

- (IBAction)fourByFourButton12Pressed:(id)sender {
	LogDebug(@"4x4 button 12 pressed.");
	if (self.statusBtn12) {
		self.statusBtn12 = NO;
		[self LogParse:self.question withStringResponse:@"Button 12 deselected" andType:1];
	}
	else {
		self.statusBtn12 = YES;
		[self LogParse:self.question withStringResponse:@"Button 12 selected" andType:1];
	}
	self.statusBtn17 = NO;
	[self updateSelectedFourByFourStatusImage];
}

- (IBAction)fourByFourButton13Pressed:(id)sender {
	LogDebug(@"4x4 button 13 pressed.");
	if (self.statusBtn13) {
		self.statusBtn13 = NO;
		[self LogParse:self.question withStringResponse:@"Button 13 deselected" andType:1];
	}
	else {
		self.statusBtn13 = YES;
		[self LogParse:self.question withStringResponse:@"Button 13 selected" andType:1];
	}
	self.statusBtn17 = NO;
	[self updateSelectedFourByFourStatusImage];
}

- (IBAction)fourByFourButton14Pressed:(id)sender {
	LogDebug(@"4x4 button 14 pressed.");
	if (self.statusBtn14) {
		self.statusBtn14 = NO;
		[self LogParse:self.question withStringResponse:@"Button 14 deselected" andType:1];
	}
	else {
		self.statusBtn14 = YES;
		[self LogParse:self.question withStringResponse:@"Button 14 selected" andType:1];
	}
	self.statusBtn17 = NO;
	[self updateSelectedFourByFourStatusImage];
}

- (IBAction)fourByFourButton15Pressed:(id)sender {
	LogDebug(@"4x4 button 15 pressed.");
	if (self.statusBtn15) {
		self.statusBtn15 = NO;
		[self LogParse:self.question withStringResponse:@"Button 15 deselected" andType:1];
	}
	else {
		self.statusBtn15 = YES;
		[self LogParse:self.question withStringResponse:@"Button 15 selected" andType:1];
	}
	self.statusBtn17 = NO;
	[self updateSelectedFourByFourStatusImage];
}

- (IBAction)fourByFourButton16Pressed:(id)sender {
	LogDebug(@"4x4 button 16 pressed.");
	if (self.statusBtn16) {
		self.statusBtn16 = NO;
		[self LogParse:self.question withStringResponse:@"Button 16 deselected" andType:1];
	}
	else {
		self.statusBtn16 = YES;
		[self LogParse:self.question withStringResponse:@"Button 16 selected" andType:1];
	}
	self.statusBtn17 = NO;
	[self updateSelectedFourByFourStatusImage];
}

- (IBAction)noneButtonPressed:(id)sender {
	LogDebug(@"4x4 None Button Pressed");

	if (self.statusBtn17) {
		self.statusBtn1 = NO;
		self.statusBtn2 = NO;
		self.statusBtn3 = NO;
		self.statusBtn4 = NO;
		self.statusBtn5 = NO;
		self.statusBtn6 = NO;
		self.statusBtn7 = NO;
		self.statusBtn8 = NO;
		self.statusBtn9 = NO;
		self.statusBtn10 = NO;
		self.statusBtn11 = NO;
		self.statusBtn12 = NO;
		self.statusBtn13 = NO;
		self.statusBtn14 = NO;
		self.statusBtn15 = NO;
		self.statusBtn16 = NO;
		self.statusBtn17 = NO;
		[self LogParse:self.question withStringResponse:@"Button NONE deselected" andType:1];
	}
	else {
		self.statusBtn1 = NO;
		self.statusBtn2 = NO;
		self.statusBtn3 = NO;
		self.statusBtn4 = NO;
		self.statusBtn5 = NO;
		self.statusBtn6 = NO;
		self.statusBtn7 = NO;
		self.statusBtn8 = NO;
		self.statusBtn9 = NO;
		self.statusBtn10 = NO;
		self.statusBtn11 = NO;
		self.statusBtn12 = NO;
		self.statusBtn13 = NO;
		self.statusBtn14 = NO;
		self.statusBtn15 = NO;
		self.statusBtn16 = NO;
		self.statusBtn17 = YES;
		[self LogParse:self.question withStringResponse:@"Button NONE selected" andType:1];
	}
	[self updateSelectedFourByFourStatusImage];
}

@end
