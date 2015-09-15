//
//  MSURVQuestionInfoHTMLView.m
//  MobSurv
//
//  Created by Michael Youngblood on 9/12/15.
//  Copyright (c) 2015 PARC. All rights reserved.
//

#import "MSURVQuestionInfoHTMLView.h"
#import "Logging.h"
#import "globals.h"

#import <AudioToolbox/AudioToolbox.h>
#import "DLAVAlertView.h"

#import "MSURVParseHelper.h"

@interface MSURVQuestionInfoHTMLView ()
@property int question;
@end

//******************* IMPLEMENTATION ********************

@implementation MSURVQuestionInfoHTMLView

MSURVSurveyViewController *caller;

-(MSURVQuestionInfoHTMLView *) init{
    MSURVQuestionInfoHTMLView *result = nil;
    NSArray* elements = [[NSBundle mainBundle] loadNibNamed: NSStringFromClass([self class]) owner:self options: nil];
    for (id anObject in elements)
    {
        if ([anObject isKindOfClass:[self class]])
        {
            result = anObject;
            break;
        }
    }
    
    caller = nil;
    
    LogDebug(@">>>>>>>>>>>>>>> Creating an Info HTML View");
    
    return result;
}

- (void)displayInfoHTMLFor:(PFObject *)info from:(MSURVSurveyViewController*)sender forQuestion:(int)q{
    caller = sender;
    self.question = q;
    
    PFFile *htmlObject = info[@"htmlFile"];
    // UIImage *btnImage = [self.ImageDictionary objectForKey:userImageFile.name];
    [htmlObject getDataInBackgroundWithBlock: ^(NSData *htmlData, NSError *error) {
         if (!error) {
             NSString* htmlString = [[NSString alloc] initWithData:htmlData encoding:NSUTF8StringEncoding];
             [self.webView loadHTMLString:htmlString baseURL:nil];
         }
         else {
             // Log details of the failure
             LogDebug(@"Error: %@ %@", error, [error userInfo]);
         }
     }];

}


@end
