//
//  MSURVQuestionInfoView.m
//  MobSurv
//
//  Created by Michael Youngblood on 9/11/15.
//  Copyright (c) 2015 PARC. All rights reserved.
//

#import "MSURVQuestionInfoView.h"
#import "Logging.h"
#import "globals.h"

#import <AudioToolbox/AudioToolbox.h>
#import "DLAVAlertView.h"

#import "MSURVParseHelper.h"

@interface MSURVQuestionInfoView ()
@property int question;
@end

//******************* IMPLEMENTATION ********************

@implementation MSURVQuestionInfoView

MSURVSurveyViewController *caller;

-(MSURVQuestionInfoView *) init{
    MSURVQuestionInfoView *result = nil;
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
    
    LogDebug(@">>>>>>>>>>>>>>> Creating an Info View");
    
    return result;
}

- (void)displayInfoFor:(PFObject *)info from:(MSURVSurveyViewController*)sender forQuestion:(int)q{
    caller = sender;
    self.question = q;
    
    self.infoImageButton.hidden = YES;
    
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
             
             self.infoImageButton.hidden = NO;
         }
         else {
             // Log details of the failure
             LogDebug(@"Error: %@ %@", error, [error userInfo]);
         }
     }];
    
    self.secondText3.text = info[@"secondText"];
}

- (IBAction)infoImageButtonPressed:(id)sender {
    [MSURVParseHelper LogParse:self.question withStringResponse:@"Pressed the info image" andType:1];
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

@end
