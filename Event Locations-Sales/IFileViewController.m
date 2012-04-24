//
//  IFileViewController.m
//  Event Locations-Sales
//
//  Created by Ujwal Trivedi on 6/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "IFileViewController.h"
#import <dispatch/dispatch.h>
#import "Functions.h"



@implementation IFileViewController

@synthesize fileView;
@synthesize refreshButton;
@synthesize activityIndicator;
@synthesize mailButton;
@synthesize fileKey;
@synthesize resizeButton;
@synthesize attachingFilesProgressView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSURL *targetURL=[NSURL URLWithString:[NSString stringWithFormat:@"http://eventlocations.us/mediakit/%@",fileKey]];        
    NSURLRequest *request = [NSURLRequest requestWithURL:targetURL];
    
    isLeftPaneResized = NO;
    attachingFilesProgressView.hidden = YES;
    
    [activityIndicator startAnimating];
    [fileView loadRequest:request];
    
}

-(void) webViewDidStartLoad:(UIWebView *)webView{
    [activityIndicator startAnimating];
}

-(void) webViewDidFinishLoad:(UIWebView *)webView{
    [activityIndicator stopAnimating];
}

-(IBAction) resizeLeftPane{
    
    /*
    if(isLeftPaneResized){
        
        //[self.splitViewController setValue:[NSNumber numberWithFloat:320.0] forKey:@"_masterColumnWidth"];
        [resizeButton setStyle:UIBarButtonSystemItemRewind ];
        isLeftPaneResized = NO;
        
    }else{
        //[self.splitViewController setValue:[NSNumber numberWithFloat:0.0] forKey:@"_masterColumnWidth"];
        [resizeButton setStyle:UIBarButtonSystemItemFastForward];
        isLeftPaneResized = YES;
        
        self.splitViewController.modalPresentationStyle = UIModalPresentationFullScreen;
        [self.splitViewController presentModalViewController:[[self.splitViewController viewControllers] objectAtIndex:1] animated:NO];
    }
     */
 
}

-(IBAction) sendContactEmail{
    	
    NSString *messageBody = @"Thank you for the opportunity to show you EventLocations.us and our company owned sites."
    "<br/><br/>See attached Media Kit and Bridal Show PDF files.";
    
    
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self;
	
    [picker setSubject:[NSString stringWithFormat:@"EventLocations.us Media Kit %@", [Functions getYearPlusOne:self]]];
    [picker setMessageBody:messageBody isHTML:YES];
  
    NSURL *targetURL=[NSURL URLWithString:[NSString stringWithFormat:@"http://eventlocations.us/mediakit/%@",fileKey]];        
    NSData *pdfData = [NSData dataWithContentsOfURL:targetURL options:NSUncachedRead error:nil];
    
    [picker addAttachmentData:pdfData mimeType:@"application/pdf" fileName:fileKey];
	[self presentModalViewController:picker animated:YES];
	[picker release];
}

-(void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [self dismissModalViewControllerAnimated:YES];
}


- (void) sendSelectedEmailView:(NSMutableArray *)fileNameArray{
    
    attachingFilesProgressView.hidden = NO;
    
    NSString *messageBody = @"Thank you for the opportunity to show you EventLocations.us and our company owned sites."
    "<br/><br/>See attached Media Kit and Bridal Show PDF files.";
    
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self;

    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // Add code here to do background processing
        
        for(NSString *fileNameKey in fileNameArray) {
            NSURL *targetURL=[NSURL URLWithString:[NSString stringWithFormat:@"http://eventlocations.us/mediakit/%@",fileNameKey]];        
            NSData *pdfData = [NSData dataWithContentsOfURL:targetURL options:NSUncachedRead error:nil];
            [picker addAttachmentData:pdfData mimeType:@"application/pdf" fileName:fileNameKey];
        }

        dispatch_async( dispatch_get_main_queue(), ^{
            // Add code here to update the UI/send notifications based on the
            // results of the background processing
            [picker setSubject:[NSString stringWithFormat:@"EventLocations.us Media Kit %@", [Functions getYearPlusOne:self]]];
            [picker setMessageBody:messageBody isHTML:YES];
            [self presentModalViewController:picker animated:YES];

            attachingFilesProgressView.hidden = TRUE;
        });
    });
    
		[picker release];
}



- (void)viewDidUnload
{
    [super viewDidUnload];

    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc
{
    [super dealloc];
    [fileView release];
    fileView = nil;

    [refreshButton release];
    [activityIndicator release];
    [mailButton release];
    [fileKey release];
    [resizeButton release];
    [attachingFilesProgressView release];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (void)showRootPopoverButtonItem:(UIBarButtonItem *)barButtonItem {
    
}

- (void)invalidateRootPopoverButtonItem:(UIBarButtonItem *)barButtonItem {
    
}


@end
