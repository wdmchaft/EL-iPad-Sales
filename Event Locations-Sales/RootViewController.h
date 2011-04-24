//
//  RootViewController.h
//  Event Locations-Sales
//
//  Created by Ujwal Trivedi on 4/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RootViewController : UITableViewController <UISplitViewControllerDelegate>{

	UISplitViewController *splitViewController;
}

@property (nonatomic, assign) IBOutlet UISplitViewController *splitViewController;

@end
