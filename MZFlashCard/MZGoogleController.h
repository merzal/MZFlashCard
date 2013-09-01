//
//  MZGoogleController.h
//  MZGoogleSpreadsheet
//
//  Created by Zalan Mergl on 9/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


@class MZFlashCardPackChooser;
@class GDataFeedSpreadsheet;
@class GDataFeedWorksheet;
@class GDataFeedBase;

@interface MZGoogleController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIActionSheetDelegate>
{
    IBOutlet UITextField* _usernameTextField;
    IBOutlet UITextField* _passwordTextField;

    IBOutlet UILabel* _infoLabel;
    IBOutlet UIActivityIndicatorView* _activityIndicator;
    
    IBOutlet UITableView* _spreadsheetTable;
    IBOutlet UITableView* _worksheetTable; //on start it isn't visible in the xib file because its frame is out of bounds

    GDataFeedSpreadsheet* _spreadsheetFeed;
    //NSError* _spreadsheetFetchError;
    
    GDataFeedWorksheet* _worksheetFeed;
    //NSError* _worksheetFetchError;
    
    GDataFeedBase* _entryFeed;
    //NSError* _entryFetchError;
    
    UIActionSheet* _actionSheet;
    
    NSMutableArray* _importedData;
    MZFlashCardPackChooser* _cardPackChooserViewController;
    NSString* _user;
    NSString* _passw;
}

@property (nonatomic, retain) MZFlashCardPackChooser*   cardPackChooserViewController;
@property (nonatomic, retain) NSString*                 user;
@property (nonatomic, retain) NSString*                 passw;

- (IBAction)cancelButtonTouched;
- (IBAction)getSpreadsheetsButtonTouched;

@end
