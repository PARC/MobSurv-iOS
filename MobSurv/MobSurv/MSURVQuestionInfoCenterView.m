//
//  MSURVQuestionInfoCenterView.m
//  MobSurv
//
//  Created by Michael Youngblood on 9/12/15.
//  Copyright (c) 2015 PARC. All rights reserved.
//

#import "MSURVQuestionInfoCenterView.h"
#import "Logging.h"
#import "globals.h"

#import <AudioToolbox/AudioToolbox.h>
#import "DLAVAlertView.h"

#import "MSURVParseHelper.h"

@interface MSURVQuestionInfoCenterView ()
@property int question;
@end

//******************* IMPLEMENTATION ********************

@implementation MSURVQuestionInfoCenterView

MSURVSurveyViewController *caller;

-(MSURVQuestionInfoCenterView *) init{
    MSURVQuestionInfoCenterView *result = nil;
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
    
    LogDebug(@">>>>>>>>>>>>>>> Creating an Info Center View");
    
    return result;
}

- (void)displayInfoCenterFor:(PFObject *)info from:(MSURVSurveyViewController*)sender forQuestion:(int)q{
    caller = sender;
    self.question = q;
    
    self.titleText.text = info[@"firstText"];
    self.bodyText.text = info[@"secondText"];
}

@end
