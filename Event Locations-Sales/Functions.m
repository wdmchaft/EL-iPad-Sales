//
//  Functions.m
//  Event Locations-Sales
//
//  Created by Ujwal Trivedi on 4/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Functions.h"


@implementation Functions


+ (NSString*) getMonthYear:(id)sender{
    NSDateFormatter* formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateFormat:@"Myyyy"];
    return [formatter stringFromDate:[NSDate date]];
}

+ (NSString*) getPreviousMonthCurrentYear:(id)sender{
    NSTimeInterval secondsPerMonth =31 * 24 * 60 * 60;
    NSDateFormatter* formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateFormat:@"Myyyy"];
    return [formatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:-secondsPerMonth]];
}

+ (NSString*) getYearPlusOne:(id)sender{
    NSTimeInterval secondsPerYear = 365 * 24 * 60 * 60;
    NSDateFormatter* formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateFormat:@"yyyy"];
    return [formatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:secondsPerYear]];
}


@end
