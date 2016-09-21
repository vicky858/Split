//
//  MasterViewController.h
//  SplitViewController
//
//  Created by vignesh on 9/8/16.
//  Copyright © 2016 vignesh. All rights reserved.
//

#import <UIKit/UIKit.h>



@class DetailViewController;

@interface MasterViewController : UITableViewController

@property (strong, nonatomic) UIBarButtonItem *editBtn;


@property (nonatomic, strong) NSMutableArray *patientList;

@property (strong, nonatomic) DetailViewController *detailViewController;

- (void)editBtnAction:(id)sender;
- (IBAction)goToSyncAction:(id)sender;

@end

