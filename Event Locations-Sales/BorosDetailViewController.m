//
//  BorosDetailViewController.m
//  Event Locations-Sales
//
//  Created by Ujwal Trivedi on 4/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BorosDetailViewController.h"
#import "QueensDetailViewController.h"
#import "BronxDetailViewController.h"
#import "BrooklynDetailViewController.h"
#import "SIDetailViewController.h"
#import "Functions.h"


@implementation BorosDetailViewController
@synthesize queensButton;
@synthesize bronxButton;
@synthesize siButton;
@synthesize brooklynButton;

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
    self.title = @"Boros";
    // Do any additional setup after loading the view from its nib.
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}


- (IBAction)queensClicked:(id)sender{
    QueensDetailViewController* detailViewController = [[QueensDetailViewController alloc] initWithNibName:@"QueensDetailViewController" bundle:nil];
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
}

- (IBAction)bronxClicked:(id)sender{
    BronxDetailViewController* detailViewController = [[BronxDetailViewController alloc] initWithNibName:@"BronxDetailViewController" bundle:nil];
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
}

- (IBAction)siClicked:(id)sender{
    SIDetailViewController* detailViewController = [[SIDetailViewController alloc] initWithNibName:@"SIDetailViewController" bundle:nil];
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
}

- (IBAction)brooklynClicked:(id)sender{
    BrooklynDetailViewController* detailViewController = [[BrooklynDetailViewController alloc] initWithNibName:@"BrooklynDetailViewController" bundle:nil];
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
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
    [queensButton release];
    [bronxButton release];
    [siButton release];
    [brooklynButton release];
}



@end
