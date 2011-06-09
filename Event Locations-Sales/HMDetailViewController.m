//
//  HMDetailViewController.m
//  Event Locations-Sales
//
//  Created by Ujwal Trivedi on 4/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HMDetailViewController.h"
#import "Functions.h"


@implementation HMDetailViewController
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
    // Do any additional setup after loading the view from its nib.

    [self loadWebRequest:true];

}


-(void) webViewDidStartLoad:(UIWebView *)webView{
    [activityIndicator startAnimating];
}

-(void) webViewDidFinishLoad:(UIWebView *)webView{
    [activityIndicator stopAnimating];
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    
    if ([httpResponse statusCode] >= 400) {
        [self loadWebRequest:false];   
    } else {
        // start recieving data
    }
}

-(void)loadWebRequest:(BOOL) currentMonth{
    
    NSURL *targetURL;
    
    if(currentMonth){
        targetURL =[NSURL URLWithString:[NSString stringWithFormat:@"http://locationsmagazine.com/Rank/RANKMan%@.html", [Functions getMonthYear:self]]];
    }else{
        targetURL =[NSURL URLWithString:[NSString stringWithFormat:@"http://locationsmagazine.com/Rank/RANKMan%@.html", [Functions getPreviousMonthCurrentYear:self]]];
    }
    
    NSURLRequest *request = [NSURLRequest requestWithURL:targetURL];
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [conn release];
    [rankView loadRequest:request];
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
    [picker setSubject:[NSString stringWithFormat:@"Honeymoon Site Ranked #1"]];
    [picker setMessageBody:messageBody isHTML:YES];
    
	[self presentModalViewController:picker animated:YES];
	[picker release];
}

-(void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [self dismissModalViewControllerAnimated:YES];
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


#pragma mark - View lifecycle


- (void)viewDidUnload
{
    [super viewDidUnload];
    rankView = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
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



@end
