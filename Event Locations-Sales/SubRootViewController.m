//
//  SubRootViewController.m
//  Event Locations-Sales
//
//  Created by Ujwal Trivedi on 4/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


#include <sys/socket.h>
#include <sys/dirent.h>
#include <CFNetwork/CFNetwork.h>

#import "SubRootViewController.h"
#import "NYSDetailViewController.h"
#import "BorosNavigationViewController.h"
#import "LIDetailViewController.h"
#import "HMDetailViewController.h"
#import "NJDetailViewController.h"
#import "ManDetailViewController.h"
#import "QueensDetailViewController.h"
#import "EventLocationsViewController.h"
#import "IFileViewController.h"
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
    
    countiesArray = [[NSArray alloc] initWithObjects:@"EventLocations.us",@"Manhattan", @"Boros", @"Long Island", @"New York State", @"New Jersey", @"Honeymoon",nil];

    
    /*
    mediaKitArray = [[NSArray alloc] initWithObjects:@"Page 1 Ranking 4SE", @"NY Times Review", @"iPhone, iPad, iTouch", @"Brides Email Addresses", @"Search: Manhattan", @"Search: Manhattan Corp", @"Search: Boros-Queens", @"Search: Long Island", @"Search NYS-Westchester", @"Search: New Jersey", @"Media Kit", nil];   
     */      
    
    mediaKitArray = [[NSArray alloc] initWithObjects:nil];
    filesToSend = [[NSMutableArray alloc] init];
    

    commonArray = countiesArray;
    
    self.title = @"EventLocations.us";
    
    isInSelectionMode = false;
    
    selectFiles = [[UIBarButtonItem alloc] initWithTitle:@"Select Files" style:UIBarButtonItemStylePlain target:self action:@selector(doSelection)];
    
    self.navigationItem.rightBarButtonItem = selectFiles;
    self.navigationItem.rightBarButtonItem.enabled = false;
    self.navigationItem.rightBarButtonItem = nil;
    
    
    emailSelectedFiles = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    emailSelectedFiles.frame = CGRectMake(10, 650, 260, 44); 
    [emailSelectedFiles setTitle:@"Send Selected Files" forState:UIControlStateNormal];
    [emailSelectedFiles addTarget:self action:@selector(sendFilesEmail) forControlEvents:UIControlEventTouchUpInside];
    emailSelectedFiles.hidden = TRUE;
    [self.view addSubview:emailSelectedFiles];
    

    
    if (self.listEntries == nil) {
        self.listEntries = [NSMutableArray array];
        assert(self.listEntries != nil);
    }
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}




/****************************************
 NETWORK FUNCTIONS
*****************************************/

@synthesize networkStream   = _networkStream;
@synthesize listData        = _listData;
@synthesize listEntries     = _listEntries;


- (void) _receiveDidStart
{
    // Clear the current image so that we get a nice visual cue if the receive fails.
    [self.listEntries removeAllObjects];
    //[self.tableView reloadData];
    [self _updateStatus:@"Receiving"];
}


- (void)_addListEntries:(NSArray *)newEntries
{
    assert(self.listEntries != nil);
    
    [self.listEntries addObjectsFromArray:newEntries];
    commonArray = self.listEntries;
    [self.tableView reloadData];
}

- (void)_receiveDidStopWithStatus:(NSString *)statusString
{
    if (statusString == nil) {
        statusString = @"List succeeded";
    }
    [self _updateStatus:statusString];
}


- (BOOL)isReceiving
{
    return (self.networkStream != nil);
}

- (void)_startReceive
// Starts a connection to download the current URL.
{
    BOOL                success;
    NSURL *             url;
    CFReadStreamRef     ftpStream;
    
    assert(self.networkStream == nil);      // don't tap receive twice in a row!
    
    // First get and check the URL.
    
    url = [NSURL URLWithString:@"ftp://<ftpuser>:<ftp-passwd>@eventlocations.us"];
    
    success = (url != nil);
    
    // If the URL is bogus, let the user know.  Otherwise kick off the connection.
    
    if ( ! success) {
        [self _updateStatus:@"Invalid URL"];
    } else {
        
        // Create the mutable data into which we will receive the listing.
        
        self.listData = [NSMutableData data];
        assert(self.listData != nil);
        
        // Open a CFFTPStream for the URL.
        
        ftpStream = CFReadStreamCreateWithFTPURL(NULL, (CFURLRef) url);
        assert(ftpStream != NULL);
        
        self.networkStream = (NSInputStream *) ftpStream;
        
        self.networkStream.delegate = self;
        [self.networkStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        [self.networkStream open];
        
        // Have to release ftpStream to balance out the create.  self.networkStream 
        // has retained this for our persistent use.
        
        CFRelease(ftpStream);
        
        // Tell the UI we're receiving.
        
        [self _receiveDidStart];
    }
}


- (void)_stopReceiveWithStatus:(NSString *)statusString
// Shuts down the connection and displays the result (statusString == nil) 
// or the error status (otherwise).
{
    if (self.networkStream != nil) {
        [self.networkStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        self.networkStream.delegate = nil;
        [self.networkStream close];
        self.networkStream = nil;
    }
    [self _receiveDidStopWithStatus:statusString];
    self.listData = nil;
}

- (void)_updateStatus:(NSString *)statusString
{
    //assert(statusString != nil);
    //self.status = statusString;
}


- (NSDictionary *)_entryByReencodingNameInEntry:(NSDictionary *)entry encoding:(NSStringEncoding)newEncoding
// CFFTPCreateParsedResourceListing always interprets the file name as MacRoman, 
// which is clearly bogus <rdar://problem/7420589>.  This code attempts to fix 
// that by converting the Unicode name back to MacRoman (to get the original bytes; 
// this works because there's a lossless round trip between MacRoman and Unicode) 
// and then reconverting those bytes to Unicode using the encoding provided. 
{
    NSDictionary *  result;
    NSString *      name;
    NSData *        nameData;
    NSString *      newName;
    
    newName = nil;
    
    // Try to get the name, convert it back to MacRoman, and then reconvert it 
    // with the preferred encoding.
    
    name = [entry objectForKey:(id) kCFFTPResourceName];
    if (name != nil) {
        assert([name isKindOfClass:[NSString class]]);
        
        nameData = [name dataUsingEncoding:NSMacOSRomanStringEncoding];
        if (nameData != nil) {
            newName = [[[NSString alloc] initWithData:nameData encoding:newEncoding] autorelease];
        }
    }
    
    // If the above failed, just return the entry unmodified.  If it succeeded, 
    // make a copy of the entry and replace the name with the new name that we 
    // calculated.
    
    if (newName == nil) {
        assert(NO);                 // in the debug builds, if this fails, we should investigate why
        result = (NSDictionary *) entry;
    } else {
        NSMutableDictionary *   newEntry;
        
        newEntry = [[entry mutableCopy] autorelease];
        assert(newEntry != nil);
        
        [newEntry setObject:newName forKey:(id) kCFFTPResourceName];
        
        result = newEntry;
    }
    
    return result;
}

- (void)_parseListData
{
    NSMutableArray *    newEntries;
    NSUInteger          offset;
    
    // We accumulate the new entries into an array to avoid a) adding items to the 
    // table one-by-one, and b) repeatedly shuffling the listData buffer around.
    
    newEntries = [NSMutableArray array];
    assert(newEntries != nil);
    
    offset = 0;
    do {
        CFIndex         bytesConsumed;
        CFDictionaryRef thisEntry;
        
        thisEntry = NULL;
        
        assert(offset <= self.listData.length);
        bytesConsumed = CFFTPCreateParsedResourceListing(NULL, &((const uint8_t *) self.listData.bytes)[offset], self.listData.length - offset, &thisEntry);
        if (bytesConsumed > 0) {
            
            // It is possible for CFFTPCreateParsedResourceListing to return a 
            // positive number but not create a parse dictionary.  For example, 
            // if the end of the listing text contains stuff that can't be parsed, 
            // CFFTPCreateParsedResourceListing returns a positive number (to tell 
            // the caller that it has consumed the data), but doesn't create a parse 
            // dictionary (because it couldn't make sense of the data).  So, it's 
            // important that we check for NULL.
            
            if (thisEntry != NULL) {
                NSDictionary *  entryToAdd;
                
                // Try to interpret the name as UTF-8, which makes things work properly 
                // with many UNIX-like systems, including the Mac OS X built-in FTP 
                // server.  If you have some idea what type of text your target system 
                // is going to return, you could tweak this encoding.  For example, 
                // if you know that the target system is running Windows, then 
                // NSWindowsCP1252StringEncoding would be a good choice here.
                // 
                // Alternatively you could let the user choose the encoding up 
                // front, or reencode the listing after they've seen it and decided 
                // it's wrong.
                //
                // Ain't FTP a wonderful protocol!
                
                entryToAdd = [self _entryByReencodingNameInEntry:(NSDictionary *) thisEntry encoding:NSUTF8StringEncoding];
                
                [newEntries addObject:entryToAdd];
            }
            
            // We consume the bytes regardless of whether we get an entry.
            
            offset += bytesConsumed;
        }
        
        if (thisEntry != NULL) {
            CFRelease(thisEntry);
        }
        
        if (bytesConsumed == 0) {
            // We haven't yet got enough data to parse an entry.  Wait for more data 
            // to arrive.
            break;
        } else if (bytesConsumed < 0) {
            // We totally failed to parse the listing.  Fail.
            [self _stopReceiveWithStatus:@"Listing parse failed"];
            break;
        }
    } while (YES);
    
    if (newEntries.count != 0) {
        [self _addListEntries:newEntries];
    }
    if (offset != 0) {
        [self.listData replaceBytesInRange:NSMakeRange(0, offset) withBytes:NULL length:0];
    }
}

- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode
{

    assert(aStream == self.networkStream);
    
    switch (eventCode) {
        case NSStreamEventOpenCompleted: {
            [self _updateStatus:@"Opened connection"];
        } break;
        case NSStreamEventHasBytesAvailable: {
            NSInteger       bytesRead;
            uint8_t         buffer[32768];
            
            [self _updateStatus:@"Receiving"];
            
            // Pull some data off the network.
            
            bytesRead = [self.networkStream read:buffer maxLength:sizeof(buffer)];
            if (bytesRead == -1) {
                [self _stopReceiveWithStatus:@"Network read error"];
            } else if (bytesRead == 0) {
                [self _stopReceiveWithStatus:nil];
            } else {
                assert(self.listData != nil);
                
                // Append the data to our listing buffer.
                
                [self.listData appendBytes:buffer length:bytesRead];
                
                // Check the listing buffer for any complete entries and update 
                // the UI if we find any.
                
                [self _parseListData];
            }
        } break;
        case NSStreamEventHasSpaceAvailable: {
            assert(NO);     // should never happen for the output stream
        } break;
        case NSStreamEventErrorOccurred: {
            [self _stopReceiveWithStatus:@"Stream open error"];
        } break;
        case NSStreamEventEndEncountered: {
            // ignore
        } break;
        default: {
            assert(NO);
        } break;
    }
}


/****************************************
 NETWORK FUNCTIONS ENDS
 *****************************************/



- (IBAction) segmentValuePicked{

    switch (segmentControl.selectedSegmentIndex) {
        case 0:
            [self removeAllSelection];
            self.title = @"Page 1 Rank 4SE";
            commonArray = countiesArray;
            
            [self.tableView reloadData ];
            self.navigationItem.rightBarButtonItem = nil;
            self.navigationItem.rightBarButtonItem.enabled = false;
            break;
        case 1:
            [self _startReceive];
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
    switch (segmentControl.selectedSegmentIndex) {
        case 0:
            return [commonArray count]; 
            break;
        case 1:
            return commonArray.count;
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    
    NSDictionary * listEntry;
    
    switch (segmentControl.selectedSegmentIndex) {
        case 0:
            cell.textLabel.text = [commonArray objectAtIndex:indexPath.row];    
            break;
        case 1:
            //assert(indexPath.row < (commonArray.count + 1));
            listEntry = [commonArray objectAtIndex:indexPath.row ];
            assert([listEntry isKindOfClass:[NSDictionary class]]);
            
            cell.textLabel.text = [self makeFancyFileName:[listEntry objectForKey:(id) kCFFTPResourceName]];
            break;
		default:
            break;
    }

    
    
    
    /*********BLOCK START**************/
    //This is just so that when FTP downloading is done 
    //then it will automatically load the first file
    //Safe to remove this code, if needed in future.
    if(indexPath.row+1 == [commonArray count] && segmentControl.selectedSegmentIndex == 1){
        UIViewController <SubstitutableDetailViewController> *detailViewController = nil;
        
        
        IFileViewController *newFileDetailViewController = [[IFileViewController alloc] initWithNibName:@"IFileViewController" bundle:nil];
        detailViewController = newFileDetailViewController;
        newFileDetailViewController.fileKey =  [[commonArray objectAtIndex:0]objectForKey:(id) kCFFTPResourceName];
        viewController = newFileDetailViewController;
    
        NSArray *viewControllers = [[NSArray alloc] initWithObjects:self.navigationController, detailViewController, nil];
        splitViewController.viewControllers = viewControllers;
        [viewControllers release];
        [detailViewController release];
    }
    /*********BLOCK END**************/

    
    return cell;
}




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
                    
                    [filesToSend removeObject:[self makeRealFileName:[[[tableView cellForRowAtIndexPath:indexPath] textLabel] text]]];
                }else{
                    [[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];
                    [filesToSend addObject:[self makeRealFileName:[[[tableView cellForRowAtIndexPath:indexPath] textLabel] text]]];
                }
                
            }else{
                
                /*
                FileViewController *newFileDetailViewController = [[FileViewController alloc] initWithNibName:@"FileViewController" bundle:nil];
                detailViewController = newFileDetailViewController;
                newFileDetailViewController.fileKey = [self getFileName:row];
                viewController = newFileDetailViewController;
                 */
                IFileViewController *newFileDetailViewController = [[IFileViewController alloc] initWithNibName:@"IFileViewController" bundle:nil];
                detailViewController = newFileDetailViewController;
                
                newFileDetailViewController.fileKey =  [self makeRealFileName:[[[tableView cellForRowAtIndexPath:indexPath] textLabel] text]];
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


- (NSString *)makeFancyFileName:(NSString *) fileName{
    NSString *str = fileName;
    str = [str stringByReplacingOccurrencesOfString:@"_" withString:@" "];
    str = [str stringByReplacingOccurrencesOfString:@".pdf" withString:@""];
    return str;
}

- (NSString *)makeRealFileName:(NSString *) fileName{
    NSString *str = fileName;
    str = [str stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    str = [str stringByAppendingString:@".pdf"];
    return str;
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
        
        [filesToSend addObject:[self makeRealFileName: [[[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]] textLabel] text]]];
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
    [self->_listEntries release];
    //[self _stopReceiveWithStatus:@"Stopped"];
    
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
