//
//  MSURVSurveyViewController.m
//  MobSurv
//
//  Created by Michael Youngblood on 8/19/14.
//  Copyright (c) 2014 PARC. All rights reserved.
//

#import "MSURVSurveyViewController.h"
#import "Logging.h"

#import <AudioToolbox/AudioToolbox.h>
#import <Parse/Parse.h>

@interface MSURVSurveyViewController ()

// View Types
//      1 - Grid Questions
//      2 - Scroll Questions
//      3 - Info
//      4 - ResponseSummary
- (void)displayGridFor:(PFObject *)question;
- (void)displayScrollFor:(PFObject *)question;
- (void)displayInfoFor:(PFObject *)info;
- (void)displayResultsSummaryFor:(PFObject *)summary;
- (void)loadViewForType:(NSNumber *)type withObject:(PFObject *)question;

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

// Scroll View
@property (weak, nonatomic) IBOutlet UILabel *firstText2;

// Info View
@property (weak, nonatomic) IBOutlet UILabel *firstText3;
@property (weak, nonatomic) IBOutlet UIButton *infoImageButton;
@property (weak, nonatomic) IBOutlet UILabel *secondText3;

// Summary Response View
@property (weak, nonatomic) IBOutlet UILabel *firstText4;

@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UIButton *backButton;

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

	self.statusBtn1 = NO;
	self.statusBtn2 = NO;
	self.statusBtn3 = NO;
	self.statusBtn4 = NO;
	self.statusBtn5 = NO;
	self.statusBtn6 = NO;

	// Need to select which version of the survey we are delivering

	[self retrieveSurveyWithName:@"TIPI-Grid"];

	self.question += 1;
	LogDebug(@"Load question %d", self.question);

	// Connect double taps to buttons
	[self.gridButton1 addTarget:self action:@selector(multipleTap1:withEvent:) forControlEvents:UIControlEventTouchDownRepeat];
	[self.gridButton2 addTarget:self action:@selector(multipleTap2:withEvent:) forControlEvents:UIControlEventTouchDownRepeat];
	[self.gridButton3 addTarget:self action:@selector(multipleTap3:withEvent:) forControlEvents:UIControlEventTouchDownRepeat];
	[self.gridButton4 addTarget:self action:@selector(multipleTap4:withEvent:) forControlEvents:UIControlEventTouchDownRepeat];
	[self.gridButton5 addTarget:self action:@selector(multipleTap5:withEvent:) forControlEvents:UIControlEventTouchDownRepeat];
	[self.gridButton6 addTarget:self action:@selector(multipleTap6:withEvent:) forControlEvents:UIControlEventTouchDownRepeat];

	//[self.view addSubview:self.scrollView];
}

- (IBAction)nextButtonPressed:(id)sender {
	if (self.question == self.maxQuestion) {
		LogDebug(@"Survey complete.");
		[self performSegueWithIdentifier:@"backToStart" sender:self];
		return;
	}

	self.question += 1;

	if (self.question >= self.maxQuestion)
		self.question = self.maxQuestion;

	LogDebug(@"Load question %d", self.question);

	if ((self.question + 1) > self.maxQuestion) {
		[self.nextButton setTitle:@"Leave Survey" forState:UIControlStateNormal];
		[[self.nextButton imageView]
		 setContentMode:UIViewContentModeScaleAspectFit];
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
}

- (IBAction)backButtonPressed:(id)sender {
	self.question -= 1;

	if (self.question <= 0)
		self.question = 1;

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

			default:
				LogError(@"Default switch-case error fall through!");
		}
	}

	LogDebug(@"-- replacing images.");
	self.keyCount = 0;
	[self replaceInImageDictionary];
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
			break;

		case 2:
			[self displayScrollFor:question];
			break;

		case 3:
			[self displayInfoFor:question];
			break;

		case 4:
			[self displayResultsSummaryFor:question];
			break;
	}
}

- (void)displayGridFor:(PFObject *)question {
	[[self.nextButton imageView] setContentMode:UIViewContentModeScaleAspectFit];
	[self.nextButton setBackgroundImage:[UIImage imageNamed:@"red.png"]
	                           forState:UIControlStateNormal];

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
	        [self.gridButton3 setBackgroundImage:image
	                                    forState:UIControlStateNormal];
		}
	    else {
	        // Log details of the failure
	        LogDebug(@"Error: %@ %@", error, [error userInfo]);
		}
	}];
}

- (void)displayScrollFor:(PFObject *)question {
	[[self.nextButton imageView] setContentMode:UIViewContentModeScaleAspectFit];
	[self.nextButton setBackgroundImage:[UIImage imageNamed:@"red.png"]
	                           forState:UIControlStateNormal];

	[self.view addSubview:self.scrollView];
	self.firstText2.text = question[@"firstText"];
}

- (void)displayInfoFor:(PFObject *)info {
	[[self.nextButton imageView] setContentMode:UIViewContentModeScaleAspectFit];
	[self.nextButton setBackgroundImage:[UIImage imageNamed:@"red.png"]
	                           forState:UIControlStateNormal];

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

	[self.view addSubview:self.summaryView];
	self.firstText4.text = summary[@"firstText"];

	//[self.nextButton setBackgroundImage:[UIImage imageNamed:@"green.png"]
	//forState:UIControlStateNormal];
}

- (IBAction)infoImageButtonPressed:(id)sender {
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


//
// Image 1 Handling...
//
- (IBAction)gridButton1Pressed:(id)sender {
	LogDebug(@"Button 1 single tap.");
}

- (IBAction)multipleTap1:(id)sender withEvent:(UIEvent *)event {
	UITouch *touch = [[event allTouches] anyObject];
	if (touch.tapCount == 2) {
		// do action.
		LogDebug(@"Button 1 DOUBLE tap!");
	}
}

//
// Image 2 Handling...
//
- (IBAction)gridButton2Pressed:(id)sender {
	LogDebug(@"Button 2 single tap.");
}

- (IBAction)multipleTap2:(id)sender withEvent:(UIEvent *)event {
	UITouch *touch = [[event allTouches] anyObject];
	if (touch.tapCount == 2) {
		// do action.
		LogDebug(@"Button 2 DOUBLE tap!");
	}
}

//
// Image 3 Handling...
//
- (IBAction)gridButton3Pressed:(id)sender {
	LogDebug(@"Button 3 single tap.");
}

- (IBAction)multipleTap3:(id)sender withEvent:(UIEvent *)event {
	UITouch *touch = [[event allTouches] anyObject];
	if (touch.tapCount == 2) {
		// do action.
		LogDebug(@"Button 3 DOUBLE tap!");
	}
}

//
// Image 4 Handling...
//
- (IBAction)gridButton4Pressed:(id)sender {
	LogDebug(@"Button 4 single tap.");
}

- (IBAction)multipleTap4:(id)sender withEvent:(UIEvent *)event {
	UITouch *touch = [[event allTouches] anyObject];
	if (touch.tapCount == 2) {
		// do action.
		LogDebug(@"Button 4 DOUBLE tap!");
	}
}

//
// Image 5 Handling...
//
- (IBAction)gridButton5Pressed:(id)sender {
	LogDebug(@"Button 5 single tap.");
}

- (IBAction)multipleTap5:(id)sender withEvent:(UIEvent *)event {
	UITouch *touch = [[event allTouches] anyObject];
	if (touch.tapCount == 2) {
		// do action.
		LogDebug(@"Button 5 DOUBLE tap!");
	}
}

//
// Image 6 Handling...
//
- (IBAction)gridButton6Pressed:(id)sender {
	LogDebug(@"Button 6 single tap.");
}

- (IBAction)multipleTap6:(id)sender withEvent:(UIEvent *)event {
	UITouch *touch = [[event allTouches] anyObject];
	if (touch.tapCount == 2) {
		// do action.
		LogDebug(@"Button 6 DOUBLE tap!");
	}
}

@end
