//
//  SubRootViewController.m
//  Event Locations-Sales
//
//  Created by Ujwal Trivedi on 4/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SubRootViewController.h"
#import "NYSDetailViewController.h"
#import "BorosDetailViewController.h"
#import "LIDetailViewController.h"
#import "HMDetailViewController.h"
#import "NJDetailViewController.h"
#import "ManDetailViewController.h"


@implementation SubRootViewController
@synthesize splitViewController;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [splitViewController release];
    splitViewController = nil;

    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}





- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"Manhattan";    
            break;
        case 1:
            cell.textLabel.text = @"Bronx, Queens, Brooklyn, SI";    
            break;
        case 2:
            cell.textLabel.text = @"Long Island";    
            break;
        case 3:
            cell.textLabel.text = @"New York State";    
            break;
        case 4:
            cell.textLabel.text = @"New Jersey";    
            break;
        case 5:
            cell.textLabel.text = @"Honeymoon";    
            break;

        default:
            break;
    }
    
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     Create and configure a new detail view controller appropriate for the selection.
     */
    NSUInteger row = indexPath.row;
    
    UIViewController <SubstitutableDetailViewController> *detailViewController = nil;
    
    if (row == 0) {
        ManDetailViewController *newDetailViewController = [[ManDetailViewController alloc] initWithNibName:@"ManDetailViewController" bundle:nil];
        detailViewController = newDetailViewController;
    }
    if (row == 1) {
        BorosDetailViewController *newDetailViewController = [[BorosDetailViewController alloc] initWithNibName:@"BorosDetailViewController" bundle:nil];
        detailViewController = newDetailViewController;
    }
    if (row == 2) {
        LIDetailViewController *newDetailViewController = [[LIDetailViewController alloc] initWithNibName:@"LIDetailViewController" bundle:nil];
        detailViewController = newDetailViewController;
    }
    if (row == 3) {
        NYSDetailViewController *newDetailViewController = [[NYSDetailViewController alloc] initWithNibName:@"NYSDetailViewController" bundle:nil];
        detailViewController = newDetailViewController;
    }
    if (row == 4) {
        NJDetailViewController *newDetailViewController = [[NJDetailViewController alloc] initWithNibName:@"NJDetailViewController" bundle:nil];
        detailViewController = newDetailViewController;
    }
    if (row == 5) {
        HMDetailViewController *newDetailViewController = [[HMDetailViewController alloc] initWithNibName:@"HMDetailViewController" bundle:nil];
        detailViewController = newDetailViewController;
    }

    
    
    // Update the split view controller's view controllers array.
    NSArray *viewControllers = [[NSArray alloc] initWithObjects:self.navigationController, detailViewController, nil];
    splitViewController.viewControllers = viewControllers;
    [viewControllers release];

    
    [detailViewController release];
}

@end
