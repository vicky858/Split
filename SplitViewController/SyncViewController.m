//
//  SyncViewController.m
//  SplitViewController
//
//  Created by Ram Venugopal on 21/09/16.
//  Copyright © 2016 vignesh. All rights reserved.
//

#import "SyncViewController.h"
#import "AppDelegate.h"
#import "AFNetworking/AFNetworking.h"
#import "AFNetworking/AFHTTPSessionManager.h"
#import "SQLiteManager.h"

@interface SyncViewController ()

@end

@implementation SyncViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)syncBtnAction:(id)sender {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager setRequestSerializer:[AFJSONRequestSerializer serializer]];
//    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"application/zip"];
    [manager GET:@"http://192.168.0.52/~Ram/PatientDetails.json" parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        
        NSLog(@"JSON Data: %@", responseObject);
        
        [self updateSQLiteDB:responseObject];
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    

}

-(BOOL)isExistingPatient:(NSNumber *)patientID{
     SQLiteManager *sqlManager = [[SQLiteManager alloc] init];
    [sqlManager OpenDB:[sqlManager GetDBPath]];
    FMResultSet *resultSet = [sqlManager ExecuteQuery:[NSString stringWithFormat:@"SELECT * FROM PatientDetails where PatientID = %@",patientID]];
    //[sqlManager ExecuteQueryWithArg:@"SELECT * FROM PatientDetails WHERE PatientID = ?" Argument:[NSArray arrayWithObjects:patientID, nil]];
    BOOL isExist = NO;
    while ([resultSet next]) {
        isExist = YES;
    }
    [resultSet close];
    return isExist;
}

-(void)updateSQLiteDB:(NSDictionary*)responseObject{

    SQLiteManager *sqlManager = [[SQLiteManager alloc] init];
    [sqlManager OpenDB:[sqlManager GetDBPath]];
    
    NSArray *patientList = [responseObject objectForKey:@"Patients"];
    for(NSDictionary *patientDic in patientList){
        
        NSMutableArray *values = [[NSMutableArray alloc] init];
        NSNumber *patientID = (NSNumber*)[patientDic objectForKey:@"PatientID"];
        if([self isExistingPatient:patientID]){
            
            [values addObject:[patientDic objectForKey:@"UserName"]];
            [values addObject:[patientDic objectForKey:@"Gender"]];
            [values addObject:[patientDic objectForKey:@"UserImage"]];
            [values addObject:[patientDic objectForKey:@"Age"]];
            [values addObject:[patientDic objectForKey:@"EmailID"]];
            [values addObject:[patientDic objectForKey:@"PhoneNo"]];
            [values addObject:[patientDic objectForKey:@"MobileNo"]];
            [values addObject:[patientDic objectForKey:@"Language"]];
            [values addObject:[patientDic objectForKey:@"FinicialClass"]];
            [values addObject:[patientDic objectForKey:@"FinicalPayer"]];
            [values addObject:[patientDic objectForKey:@"AppoinmentDate"]];
            [values addObject:[patientDic objectForKey:@"ApponimentDoctorName"]];
            [values addObject:[patientDic objectForKey:@"LastApponimentDate"]];
            [values addObject:[patientDic objectForKey:@"ApponimentPlace"]];
            [values addObject:[patientDic objectForKey:@"Transportation"]];
            [values addObject:[patientDic objectForKey:@"RefreredDoctor"]];
            [values addObject:[patientDic objectForKey:@"LastSeenDoctor"]];
            [values addObject:[patientDic objectForKey:@"LastSeenDoctorPlace"]];
            [values addObject:[patientDic objectForKey:@"Diagonses"]];
            [values addObject:[patientDic objectForKey:@"DiagonsesDate"]];
            [values addObject:[patientDic objectForKey:@"Alleriges"]];
            [values addObject:[patientDic objectForKey:@"PharamacyName"]];
            [values addObject:patientID];
            
            BOOL isUpdated = [sqlManager ExecuteInsertQuery:@"UPDATE PatientDetails set UserName= ?, Gender= ?, UserImage=?, Age= ?, EmailID= ?, PhoneNo= ?, MobileNo= ?, Language= ?, FinicialClass= ?, FinicalPayer= ?, AppoinmentDate= ?, ApponimentDoctorName= ?, LastApponimentDate= ?, ApponimentPlace= ?, Transportation= ?, RefreredDoctor= ?, LastSeenDoctor= ?, LastSeenDoctorPlace= ?, Diagonses= ?, DiagonsesDate= ?, Alleriges= ?, PharamacyName= ? where PatientID= ?" withCollectionOfValues:values];
            NSLog(@"isUpdated : %d",isUpdated);
        }else{
            [values addObject:[patientDic objectForKey:@"PatientID"]];
            [values addObject:[patientDic objectForKey:@"UserName"]];
            [values addObject:[patientDic objectForKey:@"Gender"]];
            [values addObject:[patientDic objectForKey:@"UserImage"]];
            [values addObject:[patientDic objectForKey:@"Age"]];
            [values addObject:[patientDic objectForKey:@"EmailID"]];
            [values addObject:[patientDic objectForKey:@"PhoneNo"]];
            [values addObject:[patientDic objectForKey:@"MobileNo"]];
            [values addObject:[patientDic objectForKey:@"Language"]];
            [values addObject:[patientDic objectForKey:@"FinicialClass"]];
            [values addObject:[patientDic objectForKey:@"FinicalPayer"]];
            [values addObject:[patientDic objectForKey:@"AppoinmentDate"]];
            [values addObject:[patientDic objectForKey:@"ApponimentDoctorName"]];
            [values addObject:[patientDic objectForKey:@"LastApponimentDate"]];
            [values addObject:[patientDic objectForKey:@"ApponimentPlace"]];
            [values addObject:[patientDic objectForKey:@"Transportation"]];
            [values addObject:[patientDic objectForKey:@"RefreredDoctor"]];
            [values addObject:[patientDic objectForKey:@"LastSeenDoctor"]];
            [values addObject:[patientDic objectForKey:@"LastSeenDoctorPlace"]];
            [values addObject:[patientDic objectForKey:@"Diagonses"]];
            [values addObject:[patientDic objectForKey:@"DiagonsesDate"]];
            [values addObject:[patientDic objectForKey:@"Alleriges"]];
            [values addObject:[patientDic objectForKey:@"PharamacyName"]];
            
            BOOL isInserted = [sqlManager ExecuteInsertQuery:@"INSERT into PatientDetails (PatientID, UserName, Gender, UserImage, Age, EmailID, PhoneNo, MobileNo, Language, FinicialClass, FinicalPayer, AppoinmentDate, ApponimentDoctorName, LastApponimentDate, ApponimentPlace, Transportation, RefreredDoctor, LastSeenDoctor, LastSeenDoctorPlace, Diagonses, DiagonsesDate, Alleriges, PharamacyName) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)" withCollectionOfValues:values];
            NSLog(@"isInserted : %d",isInserted);
        }
    }
    
        AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        [delegate showSplitView];
}
@end
