//
//  SubRootViewController.h
//  Event Locations-Sales
//
//  Created by Ujwal Trivedi on 4/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


/*
 SubstitutableDetailViewController defines the protocol that detail view controllers must adopt. The protocol specifies methods to hide and show the bar button item controlling the popover.
 */


@protocol SubstitutableDetailViewController
- (void)showRootPopoverButtonItem:(UIBarButtonItem *)barButtonItem;
- (void)invalidateRootPopoverButtonItem:(UIBarButtonItem *)barButtonItem;
@end

@interface SubRootViewController : UITableViewController {
 
    UISplitViewController *splitViewController;
    UISegmentedControl *segmentControl;
    NSArray *countiesArray;
    NSArray *mediaKitArray;
    NSArray *commonArray;
    UIBarButtonItem *selectFiles;
    BOOL isInSelectionMode;   
    id viewController;
    UIButton *emailSelectedFiles;
    NSMutableArray *filesToSend;
}
@property (nonatomic, assign) UIBarButtonItem *selectFiles;
@property (nonatomic, assign) UISplitViewController *splitViewController;
@property (nonatomic, assign) IBOutlet UISegmentedControl *segmentControl;

- (IBAction) segmentValuePicked;
- (void)doSelection;
- (void)removeAllSelection;
- (void)sendFilesEmail;
- (NSString *) getFileName:(NSInteger)row;
@end
