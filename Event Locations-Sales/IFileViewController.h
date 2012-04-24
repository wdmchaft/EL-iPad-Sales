//
//  IFileViewController.h
//  Event Locations-Sales
//
//  Created by Ujwal Trivedi on 6/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "SubRootViewController.h"


@interface IFileViewController : UIViewController <SubstitutableDetailViewController, UIWebViewDelegate, MFMailComposeViewControllerDelegate>{
    
    UIWebView *fileView;
    UIBarButtonItem *refreshButton;
    UIBarButtonItem *resizeButton;
    UIBarButtonItem *mailButton;
    UIActivityIndicatorView *activityIndicator;
    NSString *fileKey;
    BOOL isLeftPaneResized;
    UIView *attachingFilesProgressView;

}

@property(nonatomic, retain) IBOutlet NSString *fileKey;
@property(nonatomic, retain) IBOutlet UIWebView *fileView;
@property(nonatomic, retain) IBOutlet UIBarButtonItem *refreshButton;
@property(nonatomic, retain) IBOutlet UIBarButtonItem *mailButton;
@property(nonatomic, retain) IBOutlet UIActivityIndicatorView *activityIndicator;
@property(nonatomic, retain) IBOutlet UIBarButtonItem *resizeButton;
@property(nonatomic, retain) IBOutlet UIView *attachingFilesProgressView;


- (IBAction) sendContactEmail;
- (void) sendSelectedEmailView:(NSMutableArray *)fileNameArray;
- (IBAction) resizeLeftPane;
@end
