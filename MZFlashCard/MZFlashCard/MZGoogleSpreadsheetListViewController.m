//
//  MZGoogleSpreadsheetListViewController.m
//  MZFlashCard
//
//  Created by Zalan Mergl on 2018. 07. 13..
//

#import "MZGoogleSpreadsheetListViewController.h"
#import "GTLRDriveObjects.h"
#import "GTLRDriveQuery.h"
#import "GTLRDriveService.h"
#import "AppDelegate.h"

@import GoogleSignIn;

@interface MZGoogleSpreadsheetListViewController () <GIDSignInUIDelegate>
@property (nonatomic, strong) GTLRDriveService* driveService;
@property (nonatomic, strong) id<GTMFetcherAuthorizationProtocol> authorizer;
@end

@implementation MZGoogleSpreadsheetListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [GIDSignIn sharedInstance].uiDelegate = self;
    [GIDSignIn sharedInstance].scopes = [NSArray arrayWithObjects:kGTLRAuthScopeDrive, nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(abc:) name:@"abc" object:nil];
}
- (void)abc:(NSNotification*)noti
{
    self.authorizer = noti.object;
    
    [self fetchUserSpreadsheets];
}

- (void)fetchUserSpreadsheets
{
    self.driveService = [[GTLRDriveService alloc] init];
    
    [self.driveService setAuthorizer:self.authorizer];
    
    GTLRDriveQuery_FilesList *query = [GTLRDriveQuery_FilesList query];
    query.q = @"mimeType = 'application/vnd.google-apps.spreadsheet'";
    
    query.fields = @"kind,nextPageToken,files(mimeType,id,name)";
    
    
    GTLRServiceTicket* fileListTicket = [self.driveService executeQuery:query completionHandler:^(GTLRServiceTicket *callbackTicket, GTLRDrive_FileList *fileList, NSError *callbackError) {
        // Callback
        GTLRDrive_FileList* resultFileList = fileList;
        //                              _fileListFetchError = callbackError;
        //                              _fileListTicket = nil;
        
        //                              [self updateUI];
        
        for (GTLRDrive_File* file in resultFileList.files)
        {
            NSLog(@"mime type: %@", file.mimeType);
        }
        NSLog(@"%s", __PRETTY_FUNCTION__);
    }];
}

@end
