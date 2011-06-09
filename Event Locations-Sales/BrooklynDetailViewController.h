//
//  BrooklynDetailViewController.h
//  Event Locations-Sales
//
//  Created by Ujwal Trivedi on 5/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SubRootViewController.h"


@interface BrooklynDetailViewController : UIViewController<SubstitutableDetailViewController, UIWebViewDelegate>  {
    
    UIWebView *rankView;
    UIBarButtonItem *backButton;
    UIBarButtonItem *forwardButton;
    UIBarButtonItem *refreshButton;
    UIBarButtonItem *stopButton;
    UIActivityIndicatorView *activityIndicator;
}

@property(nonatomic, retain) IBOutlet UIWebView *rankView;
@property(nonatomic, retain) IBOutlet UIBarButtonItem *backButton;
@property(nonatomic, retain) IBOutlet UIBarButtonItem *forwardButton;
@property(nonatomic, retain) IBOutlet UIBarButtonItem *refreshButton;
@property(nonatomic, retain) IBOutlet UIBarButtonItem *stopButton;
@property(nonatomic, retain) IBOutlet UIActivityIndicatorView *activityIndicator;

-(IBAction) stopClicked: (id) sender;


@end
