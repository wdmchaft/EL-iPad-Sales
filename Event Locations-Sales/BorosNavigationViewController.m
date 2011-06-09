//
//  BorosNavigationViewController.m
//  Event Locations-Sales
//
//  Created by Ujwal Trivedi on 5/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BorosNavigationViewController.h"
#import "BorosDetailViewController.h"


@implementation BorosNavigationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
    [navigationController release];
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
    
    navigationController=[[UINavigationController alloc] init];
    //navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
	
    
	BorosDetailViewController *firstController=[[BorosDetailViewController alloc] initWithNibName:@"BorosDetailViewController" bundle:nil];
	
	

    
    [navigationController pushViewController:firstController animated:NO];
    [firstController release];
	[self.view addSubview:navigationController.view];

    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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
