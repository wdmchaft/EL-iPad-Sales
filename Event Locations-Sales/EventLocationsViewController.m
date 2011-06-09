//
//  EventLocationsViewController.m
//  Event Locations-Sales
//
//  Created by Ujwal Trivedi on 5/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "EventLocationsViewController.h"
#import "Functions.h"


@implementation EventLocationsViewController
@synthesize rankView;
@synthesize backButton;
@synthesize forwardButton;
@synthesize refreshButton;
@synthesize stopButton;
@synthesize activityIndicator;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    NSURL *targetURL =[NSURL URLWithString:[NSString stringWithFormat:@"http://www.eventlocations.us/"]];
    NSURLRequest *request = [NSURLRequest requestWithURL:targetURL];
    [rankView loadRequest:request];
}


-(void) webViewDidStartLoad:(UIWebView *)webView{
    [activityIndicator startAnimating];
}

-(void) webViewDidFinishLoad:(UIWebView *)webView{
    [activityIndicator stopAnimating];
}
-(IBAction) stopClicked: (id) sender{
    [rankView stopLoading];
    //[activityIndicator stopAnimating];
    
    [self sendContactEmail];
}

-(void) sendContactEmail{
    
    NSString *messageBody = @"Thank you for the opportunity to show you EventLocations.us and our company owned sites."
    "<br/><br/>See attached Media Kit and Bridal Show PDF files.<br/><br/>";
    
    
    messageBody =  [rankView stringByEvaluatingJavaScriptFromString:@"document.documentElement.outerHTML"];
    
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self;	
    [picker setSubject:[NSString stringWithFormat:@"Manhattan Site Ranked #1"]];
    [picker setMessageBody:messageBody isHTML:YES];
    
	[self presentModalViewController:picker animated:YES];
	[picker release];
}

-(void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [self dismissModalViewControllerAnimated:YES];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (void)showRootPopoverButtonItem:(UIBarButtonItem *)barButtonItem {
}


- (void)invalidateRootPopoverButtonItem:(UIBarButtonItem *)barButtonItem {
}

- (void)dealloc
{
    [super dealloc];
    [rankView release];
    [backButton release];
    [forwardButton release];
    [refreshButton release];
    [stopButton release];
    [activityIndicator release];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


- (void)viewDidUnload
{
    [super viewDidUnload];
    rankView = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


@end
