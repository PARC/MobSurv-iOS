//
//  MSURVParseHelper.m
//  MobSurv
//
//  Created by Michael Youngblood on 9/9/15.
//  Copyright (c) 2015 PARC. All rights reserved.
//

#import "MSURVParseHelper.h"

@implementation MSURVParseHelper

+ (void)LogParse:(NSInteger)step withNumberResponse:(NSInteger)aNumber andType:(NSInteger)aType {
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

+ (void)LogParse:(NSInteger)step withStringResponse:(NSString *)aString andType:(NSInteger)aType {
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

+ (void)LogParse:(NSInteger)step withBooleanResponse:(BOOL)aBool andType:(NSInteger)aType {
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

@end
