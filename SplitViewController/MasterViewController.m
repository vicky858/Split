//
//  MasterViewController.m
//  SplitViewController
//
//  Created by vignesh on 9/8/16.
//  Copyright © 2016 vignesh. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "PatientDetails.h"
#import "MyTableViewCell.h"
#import "SQLiteManager.h"
#import "FMResultSet.h"


@interface MasterViewController ()
{
    PatientDetails *patientObj;
    

    
}
@property NSMutableArray *objects;
@property SQLiteManager *sqlManager;
@property BOOL Editing;
//@property UIRefreshControl *refreshControl;

@end

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _editBtn = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(editBtnAction:)];
    [self.navigationItem setRightBarButtonItem:_editBtn];
    
        
    _patientList = [[NSMutableArray alloc]init];
    
    // Initialize the refresh control.
//    self.refreshControl = [[UIRefreshControl alloc] init];
//    self.refreshControl.backgroundColor = [UIColor purpleColor];
//    self.refreshControl.tintColor = [UIColor whiteColor];
//    [self.refreshControl addTarget:self
//                            action:@selector(getPatientDetails)
//                  forControlEvents:UIControlEventValueChanged];
//    [self.tableView addSubview:self.refreshControl];
    
    
    /*
    patientObj = [[PatientDetails alloc]init];
    patientObj.usrImg = @"Male1.jpg";
    patientObj.usrName = @"Peter";
    patientObj.gender = @"Male";
    patientObj.age = @"25 Years Old(06/08/1984)";
    patientObj.mailId= @"peter@hotmail.com";
    patientObj.primayContactNo= @"9865777711";
    patientObj.secondaryContactNo= @"033-777711";
    patientObj.language=@"English";
    patientObj.financialClass= @"Commerical";
    patientObj.financialPayer= @"Humana";
    patientObj.nextAppointmentDate = @"09/08/2016";
    patientObj.appDocName = @"Sam";
    patientObj.lastAppDate = @"10/08/2017";
    patientObj.lastVisit = @"OfficalVisit";
    patientObj.transportation = @"None";
    patientObj.refDoc =@"Dr.GoldBerg";
    patientObj.lastSeenDoc=@"Dr.Escobar";
    patientObj.LastVisitDocAdd = @"Mimai Beach";
    patientObj.diagonises = @"Paralysis";
    patientObj.diganosesDate =@"09/02/2013";
    patientObj.allergies = @"Latex";
    patientObj.perfPharmacy = @"Omega Pharmacy";
    [_patientList addObject:patientObj];

    patientObj = [[PatientDetails alloc]init];
    patientObj.usrImg = @"Female2.jpg";
    patientObj.usrName = @"Jessi";
    patientObj.gender = @"Female";
    patientObj.age = @"25 Years Old(06/08/1984)";
    patientObj.mailId= @"jessi@hotmail.com";
    patientObj.primayContactNo= @"9865777711";
    patientObj.secondaryContactNo= @"033-777711";
    patientObj.language=@"English";
    patientObj.financialClass= @"Commerical";
    patientObj.financialPayer= @"Humana";
    patientObj.nextAppointmentDate = @"09/08/2016";
    patientObj.appDocName = @"Sam";
    patientObj.lastAppDate = @"10/08/2017";
    patientObj.lastVisit = @"OfficalVisit";
    patientObj.transportation = @"None";
    patientObj.refDoc =@"Dr.GoldBerg";
    patientObj.lastSeenDoc=@"Dr.Escobar";
    patientObj.LastVisitDocAdd = @"Mimai Beach";
    patientObj.diagonises = @"Paralysis";
    patientObj.diganosesDate =@"09/02/2013";
    patientObj.allergies = @"Latex";
    patientObj.perfPharmacy = @"Omega Pharmacy";
    [_patientList addObject:patientObj];
     */
   
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
    //[self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self performSegueWithIdentifier:@"showDetail" sender:self];
}



- (void)viewWillAppear:(BOOL)animated {
    self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
    [super viewWillAppear:animated];
    [self getPatientDetails];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getPatientDetails{
    [_patientList removeAllObjects];
    _sqlManager = [[SQLiteManager alloc] init];

    //fetch only male :
    //FMResultSet *resultSet = [_sqlManager ExecuteQuery:@"SELECT * FROM PatientDetails where Gender = "Male""];
    [_sqlManager OpenDB:[_sqlManager GetDBPath]];
    FMResultSet *resultSet = [_sqlManager ExecuteQuery:@"SELECT * FROM PatientDetails"];
    while ([resultSet next]) {
        patientObj = [[PatientDetails alloc]init];
        patientObj.patientID = [NSNumber numberWithInt:[resultSet intForColumn:@"PatientID"]];
        patientObj.usrImg = [resultSet stringForColumn:@"UserImage"];
        patientObj.usrName = [resultSet stringForColumn:@"UserName"];
        patientObj.gender = [resultSet stringForColumn:@"Gender"];
        patientObj.age = [resultSet stringForColumn:@"Age"];
        patientObj.mailId= [resultSet stringForColumn:@"EmailID"];
        patientObj.primayContactNo= [resultSet stringForColumn:@"PhoneNo"];
        patientObj.secondaryContactNo= [resultSet stringForColumn:@"MobileNo"];
        patientObj.language=[resultSet stringForColumn:@"Language"];
        patientObj.financialClass= [resultSet stringForColumn:@"FinicialClass"];
        patientObj.financialPayer= [resultSet stringForColumn:@"FinicalPayer"];
        patientObj.nextAppointmentDate = [resultSet stringForColumn:@"AppoinmentDate"];
        patientObj.appDocName = [resultSet stringForColumn:@"ApponimentDoctorName"];
        patientObj.lastAppDate = [resultSet stringForColumn:@"LastApponimentDate"];
        patientObj.lastVisit = [resultSet stringForColumn:@"ApponimentPlace"];
        patientObj.transportation = [resultSet stringForColumn:@"Transportation"];
        patientObj.refDoc =[resultSet stringForColumn:@"RefreredDoctor"];
        patientObj.lastSeenDoc=[resultSet stringForColumn:@"LastSeenDoctor"];
        patientObj.LastVisitDocAdd = [resultSet stringForColumn:@"LastSeenDoctorPlace"];
        patientObj.diagonises = [resultSet stringForColumn:@"Diagonses"];
        patientObj.diganosesDate =[resultSet stringForColumn:@"DiagonsesDate"];
        patientObj.allergies = [resultSet stringForColumn:@"Alleriges"];
        patientObj.perfPharmacy = [resultSet stringForColumn:@"PharamacyName"];
        [_patientList addObject:patientObj];
    }
    [resultSet close];
    [self.tableView reloadData];
}


-(void)deletePatient:(NSNumber *)patientID{
     _sqlManager = [[SQLiteManager alloc] init];
    BOOL isDeleted = [_sqlManager ExecuteUpdateQuery:[NSString stringWithFormat:@"DELETE FROM PatientDetails WHERE PatientID= %d", [patientID intValue], nil]];
    NSLog(@"Deleted Status %d",isDeleted);
    if(isDeleted){
        [self getPatientDetails];
    }
}
/*
-(void)getPatientDetails{
    
    
    patientObj = [[PatientDetails alloc]init];
    patientObj.usrImg = @"person-man.png";
    patientObj.usrName = [NSString stringWithFormat:@"Ana %i",_patientList.count];
    patientObj.gender = @"Female";
    patientObj.age = @"25 Years Old(06/08/1984)";
    patientObj.mailId= @"Male";
    patientObj.primayContactNo= @"eamplame@exapmle.com";
    patientObj.secondaryContactNo= @"1234567";
    patientObj.language=@"9876554";
    patientObj.financialClass= @"Commerical";
    patientObj.financialPayer= @"Humana";
    patientObj.nextAppointmentDate = @"09/08/2016";
    patientObj.appDocName = @"Sam";
    patientObj.lastAppDate = @"10/08/2017";
    patientObj.lastVisit = @"OfficeVisit";
    patientObj.transportation = @"None";
    patientObj.refDoc =@"Dr.GoldBerg";
    patientObj.lastSeenDoc=@"Dr.Escobar";
    patientObj.LastVisitDocAdd = @"Mimai Beach";
    patientObj.diagonises = @"Paralysis";
    patientObj.diganosesDate =@"09/02/2013";
    patientObj.allergies = @"Latex";
    patientObj.perfPharmacy = @"Address";
    [_patientList addObject:patientObj];
    [self performSelector:@selector(hideRefreshViewControl) withObject:nil afterDelay:3.0];
}

-(void)hideRefreshViewControl{
    
    [self.tableView reloadData];
    
    // End the refreshing
    if (self.refreshControl) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMM d, h:mm a"];
        NSString *title = [NSString stringWithFormat:@"Last update: %@", [formatter stringFromDate:[NSDate date]]];
        NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor whiteColor]
                                                                    forKey:NSForegroundColorAttributeName];
        NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
        self.refreshControl.attributedTitle = attributedTitle;
        
        [self.refreshControl endRefreshing];
    }
}
*/
#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue identifier] isEqualToString:@"showDetail"] && sender == nil){
        DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
        [controller setPatientList:_patientList];
        [controller setPatDetails:nil];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }else if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        if(_patientList.count == 0){
            [self getPatientDetails];
        }
        if(_patientList.count>0){
            
            patientObj = _patientList[indexPath.row];
            DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
            [controller setPatientList:_patientList];
            [controller setPatDetails:patientObj];
            controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
            controller.navigationItem.leftItemsSupplementBackButton = YES;
        }
    }
}

#pragma mark - Table View
/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if (_patientList.count > 0) {
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        return 1;
        
    } else {
        
        // Display a message when the table is empty
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        
        messageLabel.text = @"No data is currently available. Please pull down to refresh.";
        messageLabel.textColor = [UIColor blackColor];
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.font = [UIFont fontWithName:@"Palatino-Italic" size:20];
        [messageLabel sizeToFit];
        
        self.tableView.backgroundView = messageLabel;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    
    return 0;
}
 */


/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
*/


- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    int count = [self.patientList count];
    if(self.editing) count++;
    return count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    MyTableViewCell *cell = [tableView
                             dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[MyTableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier];
    }
    
    int count = 0;
    if(self.editing && indexPath.row != 0)
        count = 1;
    if(indexPath.row == ([self.patientList count]) && self.editing){
        UIImage *cellImage = [UIImage imageNamed:@"person-man"];
        cell.imgView.image = cellImage;
        cell.imgView.backgroundColor = [UIColor colorWithRed:(20.0f/255.0f) green:(173.0f/255.0f) blue:(199.0f/255.0f) alpha:1.0];
        cell.imgView.layer.masksToBounds = YES;
        cell.imgView.layer.cornerRadius = 32.0f;
        cell.nameLbl.text = @"Add Patient";
        return cell;
    }
    
    //NSDate *object = _objects[indexPath.row];
    //cell.textLabel.text = [object description];
    patientObj = _patientList[indexPath.row];
    
    UIImage *cellImage = [UIImage imageNamed:patientObj.usrImg];
    cell.imgView.image = cellImage;
    
    cell.imgView.backgroundColor = [UIColor colorWithRed:(20.0f/255.0f) green:(173.0f/255.0f) blue:(199.0f/255.0f) alpha:1.0];
    cell.imgView.layer.masksToBounds = YES;
    cell.imgView.layer.cornerRadius = 32.0f;
    
    cell.nameLbl.text = patientObj.usrName;
    cell.nameLbl.font = [UIFont boldSystemFontOfSize:14.0f];
    cell.nameLbl.textColor= [UIColor colorWithRed:(10.0f/255.0f) green:(173.0f/255.0f) blue:(193.0f/255.0f) alpha:1.0];
    cell.ageLbl.text=[NSString stringWithFormat:@"%@ Years old",patientObj.age];
    cell.genderLbl.text=patientObj.gender;
    return cell;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle) editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        patientObj = _patientList[indexPath.row];
        [self deletePatient:patientObj.patientID];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert)
    {
        //[self.patientList insertObject:@"New Patient" atIndex:[self.patientList count]];
        //[tableView reloadData];
        [self editBtnAction:nil];
        [self performSegueWithIdentifier:@"showDetail" sender:nil];
        self.splitViewController.preferredDisplayMode = UISplitViewControllerDisplayModePrimaryHidden;
        UINavigationController *navigationController = [self.splitViewController.viewControllers lastObject];
        navigationController.topViewController.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.editing == NO || !indexPath)
        return UITableViewCellEditingStyleNone;
    
    if (self.editing && indexPath.row == ([self.patientList count]))
        return UITableViewCellEditingStyleInsert;
    else
        return UITableViewCellEditingStyleDelete;
    
    return UITableViewCellEditingStyleNone;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.splitViewController.preferredDisplayMode = UISplitViewControllerDisplayModePrimaryHidden;
    UINavigationController *navigationController = [self.splitViewController.viewControllers lastObject];
    navigationController.topViewController.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
}
- (void)editBtnAction:(id)sender {
    if(self.editing)
    {
        [super setEditing:NO animated:NO];
        [self.tableView setEditing:NO animated:NO];
        [self.tableView reloadData];
        [self.navigationItem.rightBarButtonItem setTitle:@"Edit"];
        [self.navigationItem.rightBarButtonItem setStyle:UIBarButtonItemStylePlain];
    }
    else
    {
        [super setEditing:YES animated:YES];
        [self.tableView setEditing:YES animated:YES];
        [self.tableView reloadData];
        [self.navigationItem.rightBarButtonItem setTitle:@"Done"];
        [self.navigationItem.rightBarButtonItem setStyle:UIBarButtonItemStyleDone];
    }
}
@end
