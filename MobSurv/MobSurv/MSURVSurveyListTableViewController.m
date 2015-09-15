//
//  MSURVSurveyListTableViewController.m
//  MobSurv
//
//  Created by Michael Youngblood on 10/9/14.
//  Copyright (c) 2014 PARC. All rights reserved.
//

#import "MSURVSurveyListTableViewController.h"
#import "Logging.h"
#import "globals.h"

@interface MSURVSurveyListTableViewController ()

@end

//******************* IMPLEMENTATION ********************

@implementation MSURVSurveyListTableViewController

- (id)initWithCoder:(NSCoder *)aCoder {
	self = [super initWithCoder:aCoder];

	if (self) {
		// Customize the table

		// The className to query on
		self.parseClassName = @"Study";

		// The key of the PFObject to display in the label of the default cell style
		self.textKey = @"name";

		// Uncomment the following line to specify the key of a PFFile on the PFObject to display in the imageView of the default cell style
		// self.imageKey = @"image";

		// Whether the built-in pull-to-refresh is enabled
		self.pullToRefreshEnabled = YES;

		// Whether the built-in pagination is enabled
		self.paginationEnabled = YES;

		// The number of objects to show per page
		self.objectsPerPage = 25;
	}

	return self;
}

- (IBAction)backButtonPressed:(id)sender {
	LogDebug(@"Returning to the login view");
	[self performSegueWithIdentifier:@"loginScreen" sender:self];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

#pragma mark - UIViewController

- (void)viewDidLoad {
	[super viewDidLoad];

	// Uncomment the following line to preserve selection between presentations.
	// self.clearsSelectionOnViewWillAppear = NO;

	// Uncomment the following line to display an Edit button in the navigation bar for this view controller.
	// self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload {
	[super viewDidUnload];
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - PFQueryTableViewController

- (void)objectsWillLoad {
	[super objectsWillLoad];

	// This method is called before a PFQuery is fired to get more objects
}

- (void)objectsDidLoad:(NSError *)error {
	[super objectsDidLoad:error];

	// This method is called every time objects are loaded from Parse via the PFQuery
}

// Override if you need to change the ordering of objects in the table.
- (PFObject *)objectAtIndex:(NSIndexPath *)indexPath {
	return [self.objects objectAtIndex:indexPath.row];
}

#pragma mark - UITableViewDataSource
#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[super tableView:tableView didSelectRowAtIndexPath:indexPath];

	PFObject *indexObject = [self objectAtIndex:indexPath];

	NSString *surveyName = indexObject[@"name"];
	LogDebug(@"### Button Pressed for Index %ld - %@", (long)indexPath.row, surveyName);

	g_surveyName = surveyName;

	LogDebug(@"Transitioning...");
	[self performSegueWithIdentifier:@"startSurvey" sender:self];
}

@end
