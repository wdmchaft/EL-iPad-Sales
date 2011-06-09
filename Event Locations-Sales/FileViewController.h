//
//  FileViewController.h
//  Event Locations-Sales
//
//  Created by Ujwal Trivedi on 5/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "SubRootViewController.h"

@interface FileViewController : UIViewController <SubstitutableDetailViewController, UIWebViewDelegate, MFMailComposeViewControllerDelegate>{
    UIWebView *fileView;
    UIBarButtonItem *refreshButton;
    UIBarButtonItem *mailButton;
    UIBarButtonItem *updateFilesButton;
    UIView *updatingFilesView;
    UIActivityIndicatorView *activityIndicator;
    NSString *fileKey;
}

@property(nonatomic, retain) IBOutlet NSString *fileKey;
@property(nonatomic, retain) IBOutlet  UIView *updatingFilesView;
@property(nonatomic, retain) IBOutlet UIWebView *fileView;
@property(nonatomic, retain) IBOutlet UIBarButtonItem *refreshButton;
@property(nonatomic, retain) IBOutlet UIBarButtonItem *mailButton;
@property(nonatomic, retain) IBOutlet UIBarButtonItem *updateFilesButton;
@property(nonatomic, retain) IBOutlet UIActivityIndicatorView *activityIndicator;

- (IBAction) refreshClicked: (id) sender;
- (IBAction) sendContactEmail;
- (IBAction) updateFiles;
- (void) sendSelectedEmailView:(NSMutableArray *)fileNameArray;
- (void) updateFilesFunction;

@end
