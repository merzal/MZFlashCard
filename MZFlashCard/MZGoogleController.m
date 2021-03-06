//
//  MZGoogleController.m
//  MZGoogleSpreadsheet
//
//  Created by Zalan Mergl on 9/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MZGoogleController.h"
#import "MZFlashCardPackChooser.h"
#import "GData.h"

@interface MZGoogleController (Private)
- (void)fetchFeedOfSpreadsheets;
- (void)fetchSelectedSpreadsheet;
- (void)fetchSelectedWorksheet;
- (void)validateAndProcessImportData;
- (void)importData;
- (void)changeTableViews;
@end

@implementation MZGoogleController

@synthesize cardPackChooserViewController = _cardPackChooserViewController;
@synthesize user = _user;
@synthesize passw = _passw;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _importedData = [[NSMutableArray alloc] init];
        _user = @"";
        _passw = @"";
    }
    return self;
}

- (IBAction)cancelButtonTouched
{
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)getSpreadsheetsButtonTouched
{
    [self importData];
//    NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
//    
//    NSString *username = _usernameTextField.text;
//    username = [username stringByTrimmingCharactersInSet:whitespace];
//    
//    if ([username rangeOfString:@"@"].location == NSNotFound) 
//    {
//        // if no domain was supplied, add @gmail.com
//        username = [username stringByAppendingString:@"@gmail.com"];
//    }
//    
//    _usernameTextField.text = username;
//    
//    [_usernameTextField resignFirstResponder];
//    [_passwordTextField resignFirstResponder];
//    
//    [self fetchFeedOfSpreadsheets];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_usernameTextField resignFirstResponder];
    [_passwordTextField resignFirstResponder];
}

- (void)changeTableViews
{
    if (_worksheetTable.hidden) 
    {
        _worksheetTable.hidden = NO;
        _infoLabel.text = @"Worksheets - select one";
        
        [UIView animateWithDuration:0.25f 
                animations:^{
                    _worksheetTable.frame = _spreadsheetTable.frame;
                    _worksheetTable.alpha = 1.0;
                                 
                    CGRect newSpreadSheetTableFrame = _spreadsheetTable.frame;
                    newSpreadSheetTableFrame.origin.x = newSpreadSheetTableFrame.origin.x - 320.0;
                    _spreadsheetTable.frame = newSpreadSheetTableFrame;
                    _spreadsheetTable.alpha = 0.0;
                }               
                completion:^(BOOL finished){
                    if (finished) 
                    {
                        _spreadsheetTable.hidden = YES;
                    }
                }
         ];
    } 
    else 
    {
        _spreadsheetTable.hidden = NO;
        _infoLabel.text = @"Spreadsheets - select one";
        
        [UIView animateWithDuration:0.25f 
                         animations:^{
                             _spreadsheetTable.frame = _worksheetTable.frame;
                             _spreadsheetTable.alpha = 1.0;
                             
                             CGRect newWorkSheetTableFrame = _worksheetTable.frame;
                             newWorkSheetTableFrame.origin.x = newWorkSheetTableFrame.origin.x + 320.0;
                             _worksheetTable.frame = newWorkSheetTableFrame;
                             _worksheetTable.alpha = 0.0;
                         }
                         completion:^(BOOL finished){
                             if (finished) 
                             {
                                 _worksheetTable.hidden = YES;
                             }
                         }
         ];
    }
}

// get a spreadsheet service object with the current username/password
//
// A "service" object handles networking tasks.  Service objects
// contain user authentication information as well as networking
// state information (such as cookies and the "last modified" date for
// fetched data.)

- (GDataServiceGoogleSpreadsheet *)spreadsheetService {
    
    static GDataServiceGoogleSpreadsheet* service = nil;
    
    if (!service) {
        service = [[GDataServiceGoogleSpreadsheet alloc] init];
        
        [service setShouldCacheResponseData:YES];
        [service setServiceShouldFollowNextLinks:YES];
    }
    
    // username/password may change
    NSString *username = _usernameTextField.text;
    NSString *password = _passwordTextField.text;
    
    [service setUserCredentialsWithUsername:username
                                   password:password];
    
    return service;
}

// get the spreadsheet selected in the top list, or nil if none
- (GDataEntrySpreadsheet*)selectedSpreadsheet 
{
    GDataEntrySpreadsheet* retVal = nil;
    
    NSArray *spreadsheets = [_spreadsheetFeed entries];
    
    NSInteger rowIndex = [_spreadsheetTable indexPathForSelectedRow].row;

    if ([spreadsheets count] > 0 && rowIndex > -1) 
    {
        retVal = [spreadsheets objectAtIndex:rowIndex];
    }
    
    return retVal;
}

// get the Worksheet selected in the second list, or nil if none
- (GDataEntryWorksheet *)selectedWorksheet 
{
    GDataEntryWorksheet* retVal = nil;
    
    NSArray *worksheets = [_worksheetFeed entries];
    
    NSInteger rowIndex = [_worksheetTable indexPathForSelectedRow].row;
    
    if ([worksheets count] > 0 && rowIndex > -1) 
    {
        retVal = [worksheets objectAtIndex:rowIndex];
    }
    
    return retVal;
}

#pragma mark -
#pragma mark Fetch feed of all of the user's spreadsheets

// begin retrieving the list of the user's spreadsheets
- (void)fetchFeedOfSpreadsheets 
{
    [_activityIndicator startAnimating];
    
    _spreadsheetFeed = nil;
    //_spreadsheetFetchError = nil;
    
    _worksheetFeed = nil;
    //_worksheetFetchError = nil;
    
    _entryFeed = nil;
    //_entryFetchError = nil;
    
    GDataServiceGoogleSpreadsheet *service = [self spreadsheetService];
    NSURL *feedURL = [NSURL URLWithString:kGDataGoogleSpreadsheetsPrivateFullFeed];
    [service fetchFeedWithURL:feedURL
                     delegate:self
            didFinishSelector:@selector(feedTicket:finishedWithFeed:error:)];
    
    //[self updateScreen];
}

// spreadsheet list fetch callback
- (void)feedTicket:(GDataServiceTicket *)ticket
  finishedWithFeed:(GDataFeedSpreadsheet *)feed
             error:(NSError *)error 
{
    [_activityIndicator stopAnimating];
    
    if (!error) 
    {
        _cardPackChooserViewController.loggedIn = YES;
        _cardPackChooserViewController.username = _usernameTextField.text;
        _cardPackChooserViewController.password = _passwordTextField.text;
        _user = _usernameTextField.text;
        _passw = _passwordTextField.text;
        
        _spreadsheetFeed = [feed retain];
        
        [_spreadsheetTable reloadData];
        
        if (_spreadsheetTable.hidden) 
        {
            [self changeTableViews];
        }
    } 
    else 
    {
        NSLog(@"error: %@",error);
    }
}

#pragma mark Fetch a spreadsheet's Worksheets

// for the spreadsheet selected in the top list, begin retrieving the list of
// Worksheets
- (void)fetchSelectedSpreadsheet 
{
    [_activityIndicator startAnimating];
    
    GDataEntrySpreadsheet *spreadsheet = [self selectedSpreadsheet];
    
    if (spreadsheet) 
    {
        NSURL *feedURL = [spreadsheet worksheetsFeedURL];
        
        if (feedURL) 
        {
            _worksheetFeed = nil;
            
            GDataServiceGoogleSpreadsheet *service = [self spreadsheetService];
            [service fetchFeedWithURL:feedURL
                             delegate:self
                    didFinishSelector:@selector(worksheetsTicket:finishedWithFeed:error:)];
        }
    }
}

// fetch worksheet feed callback
- (void)worksheetsTicket:(GDataServiceTicket *)ticket
        finishedWithFeed:(GDataFeedWorksheet *)feed
                   error:(NSError *)error 
{
    [_activityIndicator stopAnimating];
    
    if (!error) 
    {    
        _worksheetFeed = [feed retain];
        
        [_worksheetTable reloadData];
        
        [self changeTableViews];
    } 
    else 
    {
        NSLog(@"error: %@",error);
    }
}

#pragma mark Fetch a worksheet's entries

// for the worksheet selected, fetch either a cell feed or a list feed
// of its contents, depending on the segmented control's setting

- (void)fetchSelectedWorksheet 
{    
    [_activityIndicator startAnimating];
    
    GDataEntryWorksheet *worksheet = [self selectedWorksheet];
    
    if (worksheet) 
    {
        NSURL *feedURL = [[worksheet cellsLink] URL];
        
        if (feedURL) 
        {
            _entryFeed = nil;
                        
            GDataServiceGoogleSpreadsheet *service = [self spreadsheetService];
            [service fetchFeedWithURL:feedURL
                             delegate:self
                    didFinishSelector:@selector(entriesTicket:finishedWithFeed:error:)];
        }
    }
}

// fetch entries callback
- (void)entriesTicket:(GDataServiceTicket *)ticket
     finishedWithFeed:(GDataFeedBase *)feed
                error:(NSError *)error 
{
    [_activityIndicator stopAnimating];
    
    if (!error) 
    {        
        _entryFeed = [feed retain];
        
        [self validateAndProcessImportData];
        
        [self importData];
    } 
    else 
    {
        NSLog(@"error: %@",error);
    }
}

#pragma mark -
#pragma mark Data importing

- (void)validateAndProcessImportData
{
    NSInteger rowIndex = 0;
    NSMutableArray* actRowData = nil;
    
    for (GDataEntryBase* entry in [_entryFeed entries]) 
    {
        // format cell entry data
        GDataSpreadsheetCell *cell = [(GDataEntrySpreadsheetCell *)entry cell];
        
        NSString *title = [[entry title] stringValue]; // like "A3"
        NSString *resultStr = [cell resultString]; // like "3.1415926"
        
        if ([title characterAtIndex:0] == 'A')
        {
            rowIndex++;
            
            if (actRowData) 
            {
                [actRowData release], actRowData = nil;
            }
            
            actRowData = [[NSMutableArray alloc] init];
            [actRowData addObject:resultStr];
        }
        else if ([title characterAtIndex:0] == 'B')
        {
            NSInteger actIndex = [[[title componentsSeparatedByString:@"B"] objectAtIndex:1] intValue];
            if (rowIndex == actIndex) 
            {
                [actRowData addObject:resultStr];
                [_importedData addObject:actRowData];
                
                [actRowData release], actRowData = nil;
            }
            else
            {
                //NSLog(@"Error: cell B%i: wrong format",actIndex);
                rowIndex++;
            }
        }
        else
        {
            //NSLog(@"Error occured during importing");
            break;
        }
    }
    
    if (actRowData) 
    {
        [actRowData release], actRowData = nil;
    }
}

- (void)importData
{
    [_importedData addObject:@[@"egy", @"egyke"]];
    [_importedData addObject:@[@"kettő", @"kettőke"]];
    
    if ([_importedData count] == 0) 
    {
        UIAlertView* av = [[UIAlertView alloc] initWithTitle:@"Error" 
                                                     message:@"Error occured during importing" 
                                                    delegate:nil 
                                           cancelButtonTitle:@"Az fasza..." 
                                           otherButtonTitles:nil];
        [av show];
        [av release];
    }
    else
    {
        
        [_cardPackChooserViewController addCardPackFromArray:_importedData withTitle:@"valami"/*[[_entryFeed title] stringValue]*/];
        
        [self dismissModalViewControllerAnimated:YES];
    }
}

#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _spreadsheetTable) 
    {
        [self fetchSelectedSpreadsheet];
    }
    else if (tableView == _worksheetTable)
    {
        _actionSheet = [[UIActionSheet alloc] initWithTitle:@"Biztos, hogy blabla?" 
                                                   delegate:self 
                                          cancelButtonTitle:@"Cancel" 
                                     destructiveButtonTitle:nil 
                                          otherButtonTitles:@"OK", nil];
        [_actionSheet showInView:self.view];
        [_actionSheet release];
    }
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger retVal = 0;
    
    if (tableView == _spreadsheetTable) 
    {
        retVal = [[_spreadsheetFeed entries] count];
    }
    else if (tableView == _worksheetTable)
    {
        retVal = [[_worksheetFeed entries] count];
    }
        
    return retVal;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    if (tableView == _spreadsheetTable) 
    {
        // get the spreadsheet entry's title
        GDataEntrySpreadsheet *spreadsheet = [[_spreadsheetFeed entries] objectAtIndex:indexPath.row];
        cell.textLabel.text = [[spreadsheet title] stringValue];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else if (tableView == _worksheetTable)
    {
        GDataEntryWorksheet* worksheet = [[_worksheetFeed entries] objectAtIndex:indexPath.row];
        cell.textLabel.text = [[worksheet title] stringValue];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

#pragma mark -
#pragma mark UITextField delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _usernameTextField) 
    {
        [_passwordTextField becomeFirstResponder];
    } 
    else if (textField == _passwordTextField)
    {
        [_passwordTextField resignFirstResponder];
        
        [self getSpreadsheetsButtonTouched];
    }
    
    return YES;
}

#pragma mark -
#pragma mark UIActionSheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) 
    {
        case 0:
        {
            [self fetchSelectedWorksheet];
        }
            break;
        case 1:
        {
            [_worksheetTable deselectRowAtIndexPath:[_worksheetTable indexPathForSelectedRow] animated:NO];
        }
            break;
        default:
            break;
    }
}

#pragma mark -

- (void)dealloc
{
    [_importedData release], _importedData = nil;
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
    if (![_user isEqualToString:@""] && ![_passw isEqualToString:@""])
    {        
        _usernameTextField.text = _user;
        _passwordTextField.text = _passw;
    }
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
