//
//  SubRootViewController.m
//  Event Locations-Sales
//
//  Created by Ujwal Trivedi on 4/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SubRootViewController.h"
#import "NYSDetailViewController.h"
#import "BorosNavigationViewController.h"
#import "LIDetailViewController.h"
#import "HMDetailViewController.h"
#import "NJDetailViewController.h"
#import "ManDetailViewController.h"
#import "QueensDetailViewController.h"
#import "EventLocationsViewController.h"
#import "FileViewController.h"

@implementation SubRootViewController
@synthesize splitViewController;
@synthesize segmentControl;
@synthesize selectFiles;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    countiesArray = [[NSArray alloc] initWithObjects:@"EventLocations.us",@"Manhattan", @"Bronx, Queens, Brooklyn, SI", @"Long Island", @"New York State", @"New Jersey", @"Honeymoon",nil];

    mediaKitArray = [[NSArray alloc] initWithObjects:@"Page 1 Ranking 4SE", @"NY Times Review", @"iPhone, iPad, iTouch", @"Brides Email Addresses", @"Search: Manhattan", @"Search: Manhattan Corp", @"Search: Boros-Queens", @"Search: Long Island", @"Search NYS-Westchester", @"Search: New Jersey", @"Media Kit", nil];   
            
    filesToSend = [[NSMutableArray alloc] init];
    
    commonArray = countiesArray;
    self.title = @"EventLocations.us";
    
    isInSelectionMode = false;
    
    selectFiles = [[UIBarButtonItem alloc] initWithTitle:@"Select Files" style:UIBarButtonItemStylePlain target:self action:@selector(doSelection)];
    
    self.navigationItem.rightBarButtonItem = selectFiles;
    self.navigationItem.rightBarButtonItem.enabled = false;
    self.navigationItem.rightBarButtonItem = nil;
    
    
    emailSelectedFiles = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    emailSelectedFiles.frame = CGRectMake(10, 650, 300, 44); 
    [emailSelectedFiles setTitle:@"Send Selected Files" forState:UIControlStateNormal];
    [emailSelectedFiles addTarget:self action:@selector(sendFilesEmail) forControlEvents:UIControlEventTouchUpInside];
    emailSelectedFiles.hidden = TRUE;
    [self.view addSubview:emailSelectedFiles];
    
    
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}



- (IBAction) segmentValuePicked{

    switch (segmentControl.selectedSegmentIndex) {
        case 0:
            [self removeAllSelection];
            //self.title = @"Page 1 Rank 4SE";
            commonArray = countiesArray;
            [self.tableView reloadData ];
            self.navigationItem.rightBarButtonItem = nil;
            self.navigationItem.rightBarButtonItem.enabled = false;
            break;
        case 1:
            //self.title = @"Media Kit";
            commonArray = mediaKitArray;
            [self.tableView reloadData];
            self.navigationItem.rightBarButtonItem = selectFiles;
            self.navigationItem.rightBarButtonItem.enabled = true;
            break;
		default:
            break;
    }
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
    return [commonArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    cell.textLabel.text = [commonArray objectAtIndex:indexPath.row];    
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
    
    switch (segmentControl.selectedSegmentIndex) {
        case 0:
                if (row == 0) {
                    EventLocationsViewController *newDetailViewController = [[EventLocationsViewController alloc] initWithNibName:@"EventLocationsViewController" bundle:nil];
                    detailViewController = newDetailViewController;
                }
                if (row == 1) {
                    ManDetailViewController *newDetailViewController = [[ManDetailViewController alloc] initWithNibName:@"ManDetailViewController" bundle:nil];
                    detailViewController = newDetailViewController;
                }
                if (row == 2) {
                    /*
                    BorosNavigationViewController *newDetailViewController = [[BorosNavigationViewController alloc] initWithNibName:@"BorosNavigationViewController" bundle:nil];
                    */
                    
                    QueensDetailViewController *newDetailViewController = [[QueensDetailViewController alloc] initWithNibName:@"QueensDetailViewController" bundle:nil];
                    detailViewController = newDetailViewController;
                }
                if (row == 3) {
                    LIDetailViewController *newDetailViewController = [[LIDetailViewController alloc] initWithNibName:@"LIDetailViewController" bundle:nil];
                    detailViewController = newDetailViewController;
                }
                if (row == 4) {
                    NYSDetailViewController *newDetailViewController = [[NYSDetailViewController alloc] initWithNibName:@"NYSDetailViewController" bundle:nil];
                    detailViewController = newDetailViewController;
                }
                if (row == 5) {
                    NJDetailViewController *newDetailViewController = [[NJDetailViewController alloc] initWithNibName:@"NJDetailViewController" bundle:nil];
                    detailViewController = newDetailViewController;
                }
                if (row == 6) {
                    HMDetailViewController *newDetailViewController = [[HMDetailViewController alloc] initWithNibName:@"HMDetailViewController" bundle:nil];
                    detailViewController = newDetailViewController;
                }
            break;
        case 1:
            
            if (isInSelectionMode) {
                
                if ([[tableView cellForRowAtIndexPath:indexPath] accessoryType] == UITableViewCellAccessoryCheckmark) {
                    [[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryNone];
                    [filesToSend removeObject:[self getFileName:indexPath.row]];
                }else{
                    [[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];
                    [filesToSend addObject:[self getFileName:indexPath.row]];
                }
                
            }else{
                
                FileViewController *newFileDetailViewController = [[FileViewController alloc] initWithNibName:@"FileViewController" bundle:nil];
                detailViewController = newFileDetailViewController;
                newFileDetailViewController.fileKey = [self getFileName:row];
                viewController = newFileDetailViewController;
            }
            break;
		default:
            break;
    }

    if (!isInSelectionMode) {
        // Update the split view controller's view controllers array.
        NSArray *viewControllers = [[NSArray alloc] initWithObjects:self.navigationController, detailViewController, nil];
        splitViewController.viewControllers = viewControllers;
        [viewControllers release];
        [detailViewController release];
    }
    
}

- (void) sendFilesEmail{
    [viewController sendSelectedEmailView:filesToSend];
    emailSelectedFiles.hidden = TRUE;
    [self removeAllSelection];
}


- (NSString *) getFileName:(NSInteger)row{
    if (row == 0) {
       return @"googleranking";
    }
    if (row == 1) {       
        return @"nytimesreview";
    }
    if (row == 2) {
       return @"iphonepr";
    }
    if (row == 3) {
        return @"bridesemail";
    }
    if (row == 4) {
        return @"manhattan";
    }
    if (row == 5) {
        return @"manhattancorp";
    }
    if (row == 6) {
        return @"boros";
    }
    if (row == 7) {
        return @"longisland";
    }
    if (row == 8) {
        return @"nys";
    }
    if (row == 9) {
        return @"newjersey";
    }
    if (row == 10) {
        return @"mediakit";
    }
    return @"";
}

- (void)doSelection
{
    isInSelectionMode = TRUE;
    //[viewController openSelectedEmailView];
    emailSelectedFiles.hidden = FALSE;
    self.navigationItem.rightBarButtonItem.style = UIBarButtonItemStyleDone;
    self.navigationItem.rightBarButtonItem.title = @"Cancel";
    self.navigationItem.rightBarButtonItem.action = @selector(removeAllSelection);
    
    for (int i=0; i<[self.tableView numberOfRowsInSection:0]; i++){
        [[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]] setAccessoryType:UITableViewCellAccessoryCheckmark];  
        [filesToSend addObject:[self getFileName:i]];
    }
}

- (void)removeAllSelection
{   
    isInSelectionMode = FALSE;
    //[viewController closeSelectedEmailView];
    emailSelectedFiles.hidden = TRUE;
    self.navigationItem.rightBarButtonItem.style = UIBarButtonItemStylePlain;
    self.navigationItem.rightBarButtonItem.title = @"Select Files";
    self.navigationItem.rightBarButtonItem.action = @selector(doSelection);
    
    for (int i=0; i<[self.tableView numberOfRowsInSection:0]; i++){
        [[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]] setAccessoryType:UITableViewCellAccessoryNone];  
    }
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

- (void)viewDidUnload
{
    [super viewDidUnload];
    [splitViewController release];
    splitViewController = nil;
    [segmentControl release];
    [countiesArray release];
    [mediaKitArray release];
    [filesToSend release];
    [selectFiles release];
    [emailSelectedFiles release];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

@end
