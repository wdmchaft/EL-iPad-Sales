//
//  Event_Locations_SalesAppDelegate.h
//  Event Locations-Sales
//
//  Created by Ujwal Trivedi on 4/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

//@class RootViewController;
@interface Event_Locations_SalesAppDelegate : NSObject <UIApplicationDelegate> {

    UIWindow *window;
	UISplitViewController *splitViewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UISplitViewController *splitViewController;

@end
