//
//  FileViewController.m
//  Event Locations-Sales
//
//  Created by Ujwal Trivedi on 5/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <dispatch/dispatch.h>
#import "FileViewController.h"
#import "Functions.h"

@implementation FileViewController
@synthesize fileView;
@synthesize refreshButton;
@synthesize activityIndicator;
@synthesize mailButton;
@synthesize fileKey;
@synthesize updateFilesButton;
@synthesize updatingFilesView;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"FileList" ofType:@"plist"];
	NSDictionary *dictionaryx = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    NSString *fileName = [dictionaryx objectForKey:fileKey];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:@"pdf"];
    NSURL *targetURL = [NSURL fileURLWithPath:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:targetURL];
    [fileView loadRequest:request];
    
    updatingFilesView.hidden = TRUE;
    // Do any additional setup after loading the view from its nib.
}


-(IBAction) refreshClicked: (id) sender{

}

-(IBAction) sendContactEmail{

	
    NSString *messageBody = @"Thank you for the opportunity to show you EventLocations.us and our company owned sites."
    "<br/><br/>See attached Media Kit and Bridal Show PDF files.";
    
    
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self;
	
	//[picker setToRecipients:[NSArray arrayWithObjects:@"sales@eventlocations.us", nil]];
    [picker setSubject:[NSString stringWithFormat:@"EventLocations.us Media Kit %@", [Functions getYearPlusOne:self]]];
    [picker setMessageBody:messageBody isHTML:YES];
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"FileList" ofType:@"plist"];
	NSDictionary *dictionaryx = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    NSString *fileName = [dictionaryx objectForKey:fileKey];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:@"pdf"];
    NSURL *targetURL = [NSURL fileURLWithPath:path];
    NSData *pdfData = [NSData dataWithContentsOfURL:targetURL options:NSUncachedRead error:nil];
    [picker addAttachmentData:pdfData mimeType:@"application/pdf" fileName:[NSString stringWithFormat:@"%@.pdf",fileName]];

    /*
     UIImage *roboPic = [UIImage imageNamed:@"RobotWithPencil.jpg"];
     NSData *imageData = UIImageJPEGRepresentation(roboPic, 1);
     [picker addAttachmentData:imageData mimeType:@"application/pdf" fileName:@"RobotWithPencil.jpg"];
     NSString *emailBody = @"";
     [picker setMessageBody:emailBody isHTML:YES];
     */
    
	[self presentModalViewController:picker animated:YES];
	[picker release];
}

-(void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [self dismissModalViewControllerAnimated:YES];
}


- (void) sendSelectedEmailView:(NSMutableArray *)fileNameArray{
    
    NSString *messageBody = @"Thank you for the opportunity to show you EventLocations.us and our company owned sites."
    "<br/><br/>See attached Media Kit and Bridal Show PDF files.";
    
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self;
	
    [picker setSubject:[NSString stringWithFormat:@"EventLocations.us Media Kit %@", [Functions getYearPlusOne:self]]];
    [picker setMessageBody:messageBody isHTML:YES];
        
        
    for(NSString *fileNameKey in fileNameArray) {
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"FileList" ofType:@"plist"];
        NSDictionary *dictionaryx = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
        NSString *fileName = [dictionaryx objectForKey:fileNameKey];
        NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:@"pdf"];
        NSURL *targetURL = [NSURL fileURLWithPath:path];
        NSData *pdfData = [NSData dataWithContentsOfURL:targetURL options:NSUncachedRead error:nil];
        [picker addAttachmentData:pdfData mimeType:@"application/pdf" fileName:[NSString stringWithFormat:@"%@.pdf",fileName]];
    }

	[self presentModalViewController:picker animated:YES];
	[picker release];
}

- (IBAction) updateFiles{
    
   updatingFilesView.hidden = FALSE;
    [self updateFilesFunction]; 
   
}

- (void) updateFilesFunction{
    
    NSArray *fileToBeUpdated = [[NSArray alloc] initWithObjects:@"google_ranking", @"nytimes_review", @"iphone_pr", @"brides_email", @"manhattan", @"manhattan_corp", @"boros", @"longisland", @"nys", @"newjersey", @"mediakit",nil];
    
    NSString *file = [[NSString alloc] init];
    
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // Add code here to do background processing
        for(file in fileToBeUpdated){
            NSURL *  theURL = [NSURL URLWithString:[NSString stringWithFormat: @"http://www.eventlocations.us/mediakit/%@.pdf",file]];
            NSData * theData = [NSData dataWithContentsOfURL: theURL];
            NSString * theFolder = [NSHomeDirectory() stringByAppendingPathComponent:@"Event Locations-Sales.app"];
            NSString * theFileName = [theFolder stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.pdf",file]];
            [theData writeToFile:theFileName atomically:true];
        }
        
        dispatch_async( dispatch_get_main_queue(), ^{
            // Add code here to update the UI/send notifications based on the
            // results of the background processing
            updatingFilesView.hidden = TRUE;
        });
    });
    
    
    /** List all the files in the folder
     NSError **error = nil;
     NSFileManager* fileManager = [NSFileManager defaultManager];
     NSArray * filesInFolderStringArray = [fileManager contentsOfDirectoryAtPath:theFolder error:error];
     NSString *files;
     for(files in filesInFolderStringArray){
     ///NSLog(files);
     }
     **/
    [file release];
    [fileToBeUpdated release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    //return UIInterfaceOrientationIsPortrait(interfaceOrientation);
	return YES;
}

- (void)showRootPopoverButtonItem:(UIBarButtonItem *)barButtonItem {

}

- (void)invalidateRootPopoverButtonItem:(UIBarButtonItem *)barButtonItem {
    
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    [fileView release];
    [refreshButton release];
    [activityIndicator release];
    [updateFilesButton release];
    [updatingFilesView release];
    [mailButton release];
    [fileKey release];
    fileView = nil;
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
}



@end
