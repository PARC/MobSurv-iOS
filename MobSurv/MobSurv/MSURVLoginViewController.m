//
//  MSURVLoginViewController.m
//  MobSurv
//
//  Created by Michael Youngblood on 8/19/14.
//  Copyright (c) 2014 PARC. All rights reserved.
//

#import "MSURVLoginViewController.h"
#import "Logging.h"
#import "globals.h"

#import <AudioToolbox/AudioToolbox.h>
#import <Parse/Parse.h>


@interface MSURVLoginViewController ()
@property (weak, nonatomic) IBOutlet UIButton *logInOutButton;
@property (weak, nonatomic) IBOutlet UITextField *participantNumber;
@property (weak, nonatomic) IBOutlet UIButton *startButton;

@property BOOL startStatus;

- (void)playFile:(NSString *)nameOfFile;

@end

@implementation MSURVLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		// Custom initialization
		self.startStatus = NO;
	}
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];

	LogDebug(@"MSURVLoginViewController::viewDidAppear");

	if (!g_loggedIn) { /*![PFUser currentUser])*/
		g_loggedIn = YES;
		// No user logged in
		LogDebug(@"No user logged in?");
		[self.logInOutButton setTitle:@"Sign In" forState:UIControlStateNormal];

		// Create the log in view controller
		PFLogInViewController *logInViewController = [[PFLogInViewController alloc] init];
		[logInViewController setDelegate:self]; // Set ourselves as the delegate

		// Create the sign up view controller
		PFSignUpViewController *signUpViewController = [[PFSignUpViewController alloc] init];
		[signUpViewController setDelegate:self]; // Set ourselves as the delegate

		signUpViewController.fields = PFSignUpFieldsUsernameAndPassword | PFSignUpFieldsSignUpButton | PFSignUpFieldsDismissButton;

		// Assign our sign up controller to be displayed from the login controller
		[logInViewController setSignUpController:signUpViewController];

		// Present the log in view controller
		[self presentViewController:logInViewController animated:YES completion:NULL];

		[self.logInOutButton setTitle:@"Sign Out" forState:UIControlStateNormal];
	}
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (IBAction)registerButtonPressed:(id)sender {
	LogDebug(@"Registration button pressed");

	if (!g_loggedIn) { /*![PFUser currentUser])*/   // No user logged in
		g_loggedIn = YES;
		LogDebug(@"Logging in...");
		[self.logInOutButton setTitle:@"Sign In" forState:UIControlStateNormal];

		// Create the log in view controller
		PFLogInViewController *logInViewController = [[PFLogInViewController alloc] init];
		[logInViewController setDelegate:self]; // Set ourselves as the delegate

		// Create the sign up view controller
		PFSignUpViewController *signUpViewController = [[PFSignUpViewController alloc] init];
		[signUpViewController setDelegate:self]; // Set ourselves as the delegate

		signUpViewController.fields = PFSignUpFieldsUsernameAndPassword | PFSignUpFieldsSignUpButton | PFSignUpFieldsDismissButton;

		// Assign our sign up controller to be displayed from the login controller
		[logInViewController setSignUpController:signUpViewController];

		// Present the log in view controller
		[self presentViewController:logInViewController animated:YES completion:NULL];

		[self.logInOutButton setTitle:@"Sign Out" forState:UIControlStateNormal];
	}
	else {
		LogDebug(@"Logging out...");
		if (g_loggedIn) {
			[PFUser logOut];
			g_loggedIn = NO;
		}
		[self.logInOutButton setTitle:@"Sign In" forState:UIControlStateNormal];
	}

	if ([self.participantNumber.text length] > 0 && g_loggedIn) {
		LogDebug(@"Setting start button background to GREEN!");
		[[self.startButton imageView] setContentMode:UIViewContentModeScaleAspectFit];
		[self.startButton setBackgroundImage:[UIImage imageNamed:@"green.png"] forState:UIControlStateNormal];
		self.startStatus = YES;
	}
	else {
		LogDebug(@"Setting start button background to RED!");
		[[self.startButton imageView] setContentMode:UIViewContentModeScaleAspectFit];
		[self.startButton setBackgroundImage:[UIImage imageNamed:@"red.png"] forState:UIControlStateNormal];
		self.startStatus = NO;
	}
}

- (IBAction)loginButtonPressed:(id)sender {
	if (!g_loggedIn) { /* ![PFUser currentUser]) */
		LogDebug(@"User not signed infailure message!");

		NSString *alertTitle = @"Can't Start!";
		NSString *alertMessage = @"Please log into system";
		UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:alertTitle
		                                                   message:alertMessage
		                                                  delegate:self
		                                         cancelButtonTitle:@"OK"
		                                         otherButtonTitles:nil];
		[theAlert show];
	}
	else {
		if (self.startStatus) {
			[self playFile:@"Tiny Button Push-SoundBible.com-513260752"];
			LogDebug(@"Starting the survey!");

			g_participantNumber = [self.participantNumber.text intValue];

			LogDebug(@"Starting survey for user \'%@\'", [PFUser currentUser].username);
			g_username = [NSString stringWithFormat:@"%@", [PFUser currentUser].username];
			[self performSegueWithIdentifier:@"loginToSurveyList" sender:self];
		}
		else {
			LogDebug(@"Login failure message!");

			NSString *alertTitle = @"Can't Start!";
			NSString *alertMessage = @"Please enter a participant #";
			UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:alertTitle
			                                                   message:alertMessage
			                                                  delegate:self
			                                         cancelButtonTitle:@"OK"
			                                         otherButtonTitles:nil];
			[theAlert show];
		}
	}
}

- (IBAction)closeKeyboard:(id)sender {
	[self.view endEditing:YES];
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.35f];
	CGRect frame = self.view.frame;
	frame.origin.y = 0;
	[self.view setFrame:frame];
	[UIView commitAnimations];
}

- (IBAction)enteredParticipantId:(id)sender {
	if ([self.participantNumber.text length] > 0 && g_loggedIn) {
		LogDebug(@"Setting start button background to GREEN!");
		[[self.startButton imageView] setContentMode:UIViewContentModeScaleAspectFit];
		[self.startButton setBackgroundImage:[UIImage imageNamed:@"green.png"] forState:UIControlStateNormal];
		self.startStatus = YES;
	}
	else {
		LogDebug(@"Setting start button background to RED!");
		[[self.startButton imageView] setContentMode:UIViewContentModeScaleAspectFit];
		[self.startButton setBackgroundImage:[UIImage imageNamed:@"red.png"] forState:UIControlStateNormal];
		self.startStatus = NO;
	}
}

- (IBAction)startedEnteringParticipantId:(id)sender {
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.35f];
	CGRect frame = self.view.frame;
	frame.origin.y = -90;
	[self.view setFrame:frame];
	[UIView commitAnimations];
}

- (IBAction)unwindToList:(UIStoryboardSegue *)segue {
}

#pragma mark - PFLogInViewControllerDelegate

// Sent to the delegate to determine whether the log in request should be submitted to the server.
- (BOOL)logInViewController:(PFLogInViewController *)logInController shouldBeginLogInWithUsername:(NSString *)username password:(NSString *)password {
	// Check if both fields are completed
	if (username && password && username.length && password.length) {
		return YES; // Begin login process
	}

	[[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Missing Information", nil) message:NSLocalizedString(@"Make sure you fill out all of the information!", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
	return NO; // Interrupt login process
}

// Sent to the delegate when a PFUser is logged in.
- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
	[self dismissViewControllerAnimated:YES completion:NULL];
	[self.logInOutButton setTitle:@"Sign Out" forState:UIControlStateNormal];
	LogDebug(@"User is signed in...");
	g_loggedIn = YES;
}

// Sent to the delegate when the log in attempt fails.
- (void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error {
	LogDebug(@"Failed to log in...");
	[self.logInOutButton setTitle:@"Sign In" forState:UIControlStateNormal];
	g_loggedIn = NO;
}

// Sent to the delegate when the log in screen is dismissed.
- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController {
	LogDebug(@"User dismissed the logInViewController");
	[self.logInOutButton setTitle:@"Sign In" forState:UIControlStateNormal];
	g_loggedIn = NO;
}

#pragma mark - PFSignUpViewControllerDelegate

// Sent to the delegate to determine whether the sign up request should be submitted to the server.
- (BOOL)signUpViewController:(PFSignUpViewController *)signUpController shouldBeginSignUp:(NSDictionary *)info {
	BOOL informationComplete = YES;

	// loop through all of the submitted data
	for (id key in info) {
		NSString *field = [info objectForKey:key];
		if (!field || !field.length) { // check completion
			informationComplete = NO;
			break;
		}
	}

	// Display an alert if a field wasn't completed
	if (!informationComplete) {
		[[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Missing Information", nil) message:NSLocalizedString(@"Make sure you fill out all of the information!", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
	}

	return informationComplete;
}

// Sent to the delegate when a PFUser is signed up.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user {
	[self dismissViewControllerAnimated:YES completion:NULL];
	LogDebug(@"User signed up...");
	g_loggedIn = YES;
}

// Sent to the delegate when the sign up attempt fails.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didFailToSignUpWithError:(NSError *)error {
	LogDebug(@"Failed to sign up...");
	g_loggedIn = NO;
}

// Sent to the delegate when the sign up screen is dismissed.
- (void)signUpViewControllerDidCancelSignUp:(PFSignUpViewController *)signUpController {
	LogDebug(@"User dismissed the signUpViewController");
	g_loggedIn = NO;
}

/*
   #pragma mark - Navigation

   // In a storyboard-based application, you will often want to do a little preparation before navigation
   - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
   {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
   }
 */

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
