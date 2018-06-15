//
//  MZFlashCardPackChooser.m
//  MZFlashCard
//
//  Created by Zalan Mergl on 9/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
//  Structure of _cardPacks mutable array:
//      |+NSMutableDictionary: CardPack1
//      |----@"cardPackTitle"  :   NSString:packTitle
//      |----@"cardPack"       :   NSMutableArray:pack
//      |+NSMutableDictionary: CardPack2
//      ...
//      

#import "MZFlashCardPackChooser.h"
#import "MZGoogleController.h"
#import "NSString+MZFlashCardUtils.h"
#import "MZFlashCardItem.h"
#import "MZFlashCardViewController.h"

@interface MZFlashCardPackChooser (Private)
- (void)loadCardPacksFromDisk;
- (void)saveCardPacksToDisk;
- (void)deleteCardPackAtIndex:(NSInteger)index;
- (void)updateTableView;
@end

@implementation MZFlashCardPackChooser

@synthesize loggedIn = _loggedIn;
@synthesize username = _username;
@synthesize password = _password;

- (id)initWithStyle:(UITableViewStyle)style 
{    
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
	if ((self = [super initWithStyle:style])) 
	{
        // Custom initialization.
        _loggedIn = NO;
        _cardPacks = [[NSMutableArray alloc] init];
        //_cardPackTitles = [[NSMutableArray alloc] init];
        
        _username = @"";
        _password = @"";
    }
    	
    return self;
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad
{    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = [UIColor mzFlashCardMainBlueColor];
    
    self.tableView.separatorColor = [UIColor clearColor];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationItem.title = @"Choose a pack";
    
    
//    UIToolbar* bottomToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0, self.view.frame.size.height - 88, self.view.frame.size.width, 44.0)];
//    [bottomToolbar setBarStyle:UIBarStyleBlack];
//    [self.view addSubview:bottomToolbar];
    
    
    
    
    UIBarButtonItem *newRightButton = [[UIBarButtonItem alloc] init];
	newRightButton.title = @"Import";
	self.navigationItem.rightBarButtonItem = newRightButton;
    self.navigationItem.rightBarButtonItem.target = self;
    self.navigationItem.rightBarButtonItem.action = @selector(importButtonTouched);
	[newRightButton release];
    
    _noPackLabel = [[UILabel alloc] initWithFrame:self.view.bounds];
    _noPackLabel.text = @"No FlashCard Pack is available!\nPlease import one.";
    _noPackLabel.backgroundColor = [UIColor clearColor];
    _noPackLabel.numberOfLines = 0;
    _noPackLabel.textAlignment = UITextAlignmentCenter;
    _noPackLabel.hidden = YES;
    
    [self.view addSubview:_noPackLabel];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveCardPacksToDisk) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveCardPacksToDisk) name:@"FlashCardViewControllerWillDisappear" object:nil];
    
    [self loadCardPacksFromDisk];
    
    [self updateTableView];
}

- (void)dealloc
{
    [_cardPacks release], _cardPacks = nil;
    //[_cardPackTitles release], _cardPackTitles = nil;
    [_noPackLabel release];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super dealloc];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    return [_cardPacks count];
}

/*- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return @"My FlashCard Library";
}*/

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
	if (cell == nil) 
	{
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    cell.textLabel.text = [[_cardPacks objectAtIndex:indexPath.row] objectForKey:@"cardPackTitle"];
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17.0];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    UIImageView *selBgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cellBackground_3.png"]];
    cell.selectedBackgroundView = selBgView;
    [selBgView release];
    
    return cell;
}

/*
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCellEditingStyle retVal = UITableViewCellEditingStyleNone;
	
	if (self.tableView.editing)
	{
		NSDictionary* itemDictionary = [[[self.tableView.editing ? _editingContent : _content objectAtIndex:[indexPath section]] valueForKey:@"children"] objectAtIndex:[indexPath row]]; 
		
		NSString* itemFieldName = [itemDictionary valueForKey:@"field"];
		
		if ([itemFieldName hasPrefix:@"_ADDMOREFIELDS"] || [itemFieldName hasPrefix:@"_MANAGEUSERS"]) 
		{
			retVal = UITableViewCellEditingStyleInsert;
		}
		else if ([[[self.tableView.editing ? _editingContent : _content objectAtIndex:[indexPath section]] valueForKey:@"sectionTitle"] isEqual:NSLocalizedString(@"ParticipantsKey", @"Participants Section title (Appointment View)")])
		{
			//participants
			if (![[itemDictionary valueForKey:@"id"] isEqual:[[CASXRMContentManager sharedContentManager] selfGguid]]) 
			{
				retVal = UITableViewCellEditingStyleDelete;
			}
		}
        //		else 
        //		{
        //			//only enable removal of optional fields
        //			BOOL canRemove = [[[itemDictionary valueForKey:@"properties"] valueForKey:@"optional"] boolValue];
        //			
        //			if (canRemove) 
        //			{
        //				retVal = UITableViewCellEditingStyleDelete;
        //			}
        //		}				
	}
    
	return retVal;
}
 */

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath 
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath 
{    
    if (editingStyle == UITableViewCellEditingStyleDelete) 
    {
        // Delete the row from the data source.
        
        [self deleteCardPackAtIndex:indexPath.row];
        
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) 
    {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    // Navigation logic may go here. Create and push another view controller.
    /*
	 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
	 // ...
	 // Pass the selected object to the new view controller.
	 [self.navigationController pushViewController:detailViewController animated:YES];
	 [detailViewController release];
	 */
    
    MZFlashCardViewController* vc = [[MZFlashCardViewController alloc] init];
    vc.flashCardItems = [[_cardPacks objectAtIndex:indexPath.row] valueForKey:@"cardPack"];
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section 
{
    UIView *headerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 40)] autorelease];
    //headerView.backgroundColor = [UIColor purpleColor];
    headerView.backgroundColor = [UIColor mzFlashCardMainBlueColor];
    

    CGRect labelRect = CGRectMake(8.0, 10.0, headerView.bounds.size.width - 16.0, 30.0);

    UILabel* headerLabel = [[[UILabel alloc] initWithFrame:labelRect] autorelease];
    //headerLabel.backgroundColor = [UIColor lightGrayColor];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.font = [UIFont fontWithName:@"Futura" size:18.0];
    headerLabel.text = @"My FlashCard Library";
    
    CGRect lineRect = CGRectMake(0.0, labelRect.size.height - 1.0, labelRect.size.width, 1.0);
    UIView* line = [[[UIView alloc] initWithFrame:lineRect] autorelease];
    line.backgroundColor = [UIColor blackColor];
    
    [headerLabel addSubview:line];
    [headerView addSubview:headerLabel];
    
    
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.0;
}

#pragma mark -
#pragma mark Public methods

- (void)addCardPackFromArray:(NSMutableArray*)pack withTitle:(NSString*)title
{
    NSString* utf8Title = [title stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

//    NSString* cardPackTitle = [[NSUserDefaults standardUserDefaults] valueForKey:utf8Title];
    
    if (0/*cardPackTitle*/)
    {
        //cardpack is already here
        UIAlertView* av = [[UIAlertView alloc] initWithTitle:@"This cardpack is already available!" 
                                                     message:@"Overwrite existing cardpack with the new cardpack?" 
                                                    delegate:self 
                                           cancelButtonTitle:@"Cancel" 
                                           otherButtonTitles:@"OK", nil];
        [av show];
        [av release];
    }
    else
    {
        //a new cardpack
        NSMutableArray* flashCardItems = [[NSMutableArray alloc] init];
        
        for (NSArray* item in pack) 
        {
            MZFlashCardItem* flashCardItem = [[MZFlashCardItem alloc] init];
            flashCardItem.challenge = [item objectAtIndex:0];
            flashCardItem.solution = [item objectAtIndex:1];
            
            [flashCardItems addObject:flashCardItem];
            
            [flashCardItem release];
        }
        
        NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
        
        [dict setObject:title forKey:@"cardPackTitle"];
        [dict setObject:flashCardItems forKey:@"cardPack"];
        
        [_cardPacks addObject:dict];
        
        [flashCardItems release];
        [dict release];
        
        [self updateTableView];
        
        [self saveCardPacksToDisk];
        
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Success"
                                                     message:@"Importing was success" 
                                                    delegate:nil
                                           cancelButtonTitle:@"Juhuhuuu"
                                           otherButtonTitles:nil];
        
        [av performSelector:@selector(show) withObject:nil afterDelay:0.3];
        
        //[av show];
        [av release];
    }
}

#pragma mark -
#pragma mark Private methods

- (void)loadCardPacksFromDisk
{
    NSLog(@"%s",__PRETTY_FUNCTION__);
    
    NSFileManager* fm = [NSFileManager defaultManager];
	
    NSArray* utf8FileNames = [fm contentsOfDirectoryAtPath:[NSString applicationDocumentsDirectory] error:nil];
    
    NSLog(@"utf8filenames: %@",utf8FileNames);
    
    for (NSString* utf8FileName in utf8FileNames) 
    {
        NSString* extension = [utf8FileName substringFromIndex:[utf8FileName length]-4];
        
        if ([extension isEqualToString:@"MZFC"]) 
        {
            NSString* filePath = [[NSString applicationDocumentsDirectory] stringByAppendingString:[NSString stringWithFormat:@"/%@",utf8FileName]];
            
            NSString* utf8FileNameWithoutExtension = [utf8FileName stringByDeletingPathExtension];
            
            
            //load filename from plist
            //        NSString* fileNamesPath = [[NSBundle mainBundle] pathForResource:@"FileNames" ofType:@"plist"];
            //        NSMutableDictionary* fileNames = [NSMutableDictionary dictionaryWithContentsOfFile:fileNamesPath];
            
            
            //        NSString* title = [fileNames valueForKey:utf8FileNameWithoutExtension];
            
            NSString* title = [[NSUserDefaults standardUserDefaults] valueForKey:utf8FileNameWithoutExtension];
            
            
            NSMutableArray* flashCardItemsFromFile = [NSMutableArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithFile:filePath]];
            
            NSArray* objects = [NSArray arrayWithObjects:title, flashCardItemsFromFile, nil];
            NSArray* keys = [NSArray arrayWithObjects:@"cardPackTitle", @"cardPack", nil];
            
            NSDictionary* dict = [NSMutableDictionary dictionaryWithObjects:objects forKeys:keys];
            
            [_cardPacks addObject:dict];
        }
    }
        
    for (NSDictionary* dict in _cardPacks) 
    {
        NSLog(@"Loaded cardPack: %@",[dict objectForKey:@"cardPackTitle"]);
    }
    
    
	//NSString* appSupportPath = [[NSString applicationDocumentsDirectory] stringByAppendingPathComponent:directory];
	
	//if (![fm fileExistsAtPath:appSupportPath]) 
	//{
	//	[fm createDirectoryAtPath:appSupportPath withIntermediateDirectories:YES attributes:nil error:nil];
	//}
    //_flashCardItemsFromFile = [[NSArray alloc] initWithArray:[NSKeyedUnarchiver unarchiveObjectWithFile:[[NSString applicationDocumentsDirectory] stringByAppendingString:@"/someFile.zal"]]];
}

- (void)saveCardPacksToDisk
{
    NSLog(@"%s",__PRETTY_FUNCTION__);
    NSLog(@"%i elem mentésre kerül",[_cardPacks count]);
    
    for (NSMutableDictionary* cardPack in _cardPacks) 
    {
        NSString* title = [cardPack objectForKey:@"cardPackTitle"];
        NSString* utf8Title = [title stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSMutableArray* cards = [cardPack objectForKey:@"cardPack"];
        
        NSString* fileName = [NSString stringWithFormat:@"%@.MZFC",utf8Title];
        
        [NSKeyedArchiver archiveRootObject:cards toFile:[[NSString applicationDocumentsDirectory] stringByAppendingString:[NSString stringWithFormat:@"/%@",fileName]]];
        
        //save filenames to plist
        [[NSUserDefaults standardUserDefaults] setValue:title forKey:utf8Title];
        [[NSUserDefaults standardUserDefaults] synchronize];
//        NSString* fileNamesPath = [[NSBundle mainBundle] pathForResource:@"FileNames" ofType:@"plist"];
//        NSMutableDictionary* fileNames = [NSMutableDictionary dictionaryWithContentsOfFile:fileNamesPath];
//        [fileNames setValue:title forKey:utf8Title];
//        [fileNames writeToFile:fileNamesPath atomically:YES];
    }
}


- (void)deleteCardPackAtIndex:(NSInteger)index
{
    NSString* cardPackTitle = [[_cardPacks objectAtIndex:index] valueForKey:@"cardPackTitle"];
    NSString* utf8Title = [cardPackTitle stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    //remove fileName from fileNames plist
//    NSString* fileNamesPath = [[NSBundle mainBundle] pathForResource:@"FileNames" ofType:@"plist"];
//    NSMutableDictionary* fileNames = [NSMutableDictionary dictionaryWithContentsOfFile:fileNamesPath];
//    [fileNames removeObjectForKey:utf8Title];
//    [fileNames writeToFile:fileNamesPath atomically:YES];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:utf8Title];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //remove card from cardPacks
    [_cardPacks removeObjectAtIndex:index];
    
    //remove file from file system
    NSFileManager* fm = [NSFileManager defaultManager];
    
    NSString* filePath = [[NSString applicationDocumentsDirectory] stringByAppendingString:[NSString stringWithFormat:@"/%@.MZFC",utf8Title]];
    
    [fm removeItemAtPath:filePath error:nil];
    
    [self performSelector:@selector(updateTableView) withObject:nil afterDelay:0.2];
    
    //[self updateTableView];
}

- (void)importButtonTouched
{
    MZGoogleController* googleController = [[MZGoogleController alloc] initWithNibName:@"MZGoogleController" bundle:nil];
    googleController.cardPackChooserViewController = self;
    googleController.user = _username;
    googleController.passw = _password;
    
    if (_loggedIn) 
    {
        [googleController performSelector:@selector(getSpreadsheetsButtonTouched) withObject:nil afterDelay:0.1];
    }
    
    [self presentModalViewController:googleController animated:YES];
    [googleController release];
}

- (void)updateTableView
{
    if ([_cardPacks count] == 0 && _noPackLabel.hidden == YES) 
    {
        _noPackLabel.hidden = NO;
    }
    else
    {
        _noPackLabel.hidden = YES;
    }
    
    [self.tableView reloadData];
}

@end
