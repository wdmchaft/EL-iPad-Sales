//
//  BronxDetailViewController.m
//  Event Locations-Sales
//
//  Created by Ujwal Trivedi on 5/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BronxDetailViewController.h"
#import "Functions.h"


@implementation BronxDetailViewController
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
    // Do any additional setup after loading the view from its nib.
    NSURL *targetURL =[NSURL URLWithString:[NSString stringWithFormat:@"http://locationsmagazine.com/Rank/RANKNYS%@.html", [Functions getMonthYear:self]]];
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
    [activityIndicator stopAnimating];
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
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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
