//
//  AppDelegate.m
//  MZFlashCard
//
//  Created by Zalan Mergl on 2018. 06. 15..
//

#import "AppDelegate.h"


#import "GTLRSheets.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor],
                                                           NSFontAttributeName: [UIFont fontWithName:@"Menlo" size:20.0f]}];
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor],
                                                           NSFontAttributeName: [UIFont fontWithName:@"Menlo" size:18.0f]}
                                                forState:UIControlStateNormal];
    
    [GIDSignIn sharedInstance].clientID = @"987624862256-kr0qtbtfrhjavm0ld3smnj9oeo14t69p.apps.googleusercontent.com";
    [GIDSignIn sharedInstance].delegate = self;
    
    return YES;
}

- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user withError:(NSError *)error {
    // Perform any operations on signed in user here.
//    NSString *userId = user.userID;                  // For client-side use only!
//    NSString *idToken = user.authentication.idToken; // Safe to send to the server
//    NSString *fullName = user.profile.name;
//    NSString *givenName = user.profile.givenName;
//    NSString *familyName = user.profile.familyName;
//    NSString *email = user.profile.email;
    // ...
    
    [self fetchUserSpreadsheets];
}

- (void)signIn:(GIDSignIn *)signIn didDisconnectWithUser:(GIDGoogleUser *)user withError:(NSError *)error {
    // Perform any operations when the user disconnects from app here.
    // ...
}

- (void)fetchUserSpreadsheets
{
    GTLRSheetsService *service = [[GTLRSheetsService alloc] init];
    service.APIKey = @"AIzaSyAcwE9vVYusrJek9zFn3HPWWlXJw5sWL_U";
    
    GTLRSheetsQuery_SpreadsheetsGet* query = [GTLRSheetsQuery_SpreadsheetsGet queryWithSpreadsheetId:@"1minTU8I6IzASmXd3eVM8eY7h145knX_cG0OEIvTMr6Q"];
    
    //    GTLRDriveQuery_FilesList *query = [GTLRDriveQuery_FilesList query];
    
    // Because GTLRDrive_FileList is derived from GTLCollectionObject and the service
    // property shouldFetchNextPages is enabled, this may do multiple fetches to
    // retrieve all items in the file list.
    
    // Google APIs typically allow the fields returned to be limited by the "fields" property.
    // The Drive API uses the "fields" property differently by not sending most of the requested
    // resource's fields unless they are explicitly specified.
    //    query.fields = @"kind,nextPageToken,files(mimeType,id,kind,name,webViewLink,thumbnailLink,trashed)";
    
    [service executeQuery:query completionHandler:^(GTLRServiceTicket * _Nonnull callbackTicket, id  _Nullable object, NSError * _Nullable callbackError) {
        
        NSLog(@"meggyöttünk");
    }];
    //    _fileListTicket = [service executeQuery:query
    //                          completionHandler:^(GTLRServiceTicket *callbackTicket,
    //                                              GTLRDrive_FileList *fileList,
    //                                              NSError *callbackError) {
    //                              // Callback
    //                              self->_fileList = fileList;
    //                              self->_fileListFetchError = callbackError;
    //                              self->_fileListTicket = nil;
    
    //                              [self updateUI];
    //                          }];
    
    //    [self updateUI];
}


- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
    return [[GIDSignIn sharedInstance] handleURL:url sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey] annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
