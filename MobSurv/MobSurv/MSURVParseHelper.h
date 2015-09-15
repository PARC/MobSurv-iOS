//
//  MSURVParseHelper.h
//  MobSurv
//
//  Created by Michael Youngblood on 9/9/15.
//  Copyright (c) 2015 PARC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

#import "globals.h"

@interface MSURVParseHelper : NSObject  

+ (void)LogParse:(NSInteger)step withNumberResponse:(NSInteger)aNumber andType:(NSInteger)aType;
+ (void)LogParse:(NSInteger)step withStringResponse:(NSString *)aString andType:(NSInteger)aType;
+ (void)LogParse:(NSInteger)step withBooleanResponse:(BOOL)aBool andType:(NSInteger)aType;

@end
