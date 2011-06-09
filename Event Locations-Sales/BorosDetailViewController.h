//
//  BorosDetailViewController.h
//  Event Locations-Sales
//
//  Created by Ujwal Trivedi on 4/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BorosDetailViewController : UIViewController {
    UIButton *queensButton;
    UIButton *bronxButton;
    UIButton *siButton;
    UIButton *brooklynButton;
}

@property(nonatomic, retain) IBOutlet UIButton *queensButton; 
@property(nonatomic, retain) IBOutlet UIButton *bronxButton; 
@property(nonatomic, retain) IBOutlet UIButton *siButton;
@property(nonatomic, retain) IBOutlet UIButton *brooklynButton; 

- (IBAction)queensClicked:(id)sender;
- (IBAction)bronxClicked:(id)sender;
- (IBAction)siClicked:(id)sender;
- (IBAction)brooklynClicked:(id)sender;

@end
