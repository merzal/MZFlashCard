//
//  MZSettingsViewController.m
//  MZFlashCard
//
//  Created by Zalan Mergl on 9/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MZSettingsViewController.h"


@implementation MZSettingsViewController

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    self.view.backgroundColor = [UIColor mzFlashCardMainBlueColor];
    
    self.tableView.separatorColor = [UIColor clearColor];
    
    self.navigationItem.title = @"Settings";
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
    return 1;
}

/*- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"General";
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
    cell.textLabel.text = @"Foreign language in front";
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15.0];
    cell.accessoryType = UITableViewCellAccessoryNone;
    UIImageView *selBgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cellBackground_3.png"]];
    cell.selectedBackgroundView = selBgView;
    [selBgView release];
    
    UISwitch* switchButton = [[[UISwitch alloc] initWithFrame:CGRectZero] autorelease];
    switchButton.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"challengeIsFront"];
    [switchButton addTarget:self action:@selector(setOrderOfChallengeAndSolution:) forControlEvents:UIControlEventValueChanged];
    cell.accessoryView = switchButton;
    
    return cell;
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
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section 
{
    UIView *headerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 40)] autorelease];
    headerView.backgroundColor = [UIColor mzFlashCardMainBlueColor];
    //headerView.backgroundColor = [UIColor clearColor];
    
    
    CGRect labelRect = CGRectMake(8.0, 10.0, headerView.bounds.size.width - 16.0, 30.0);
    
    UILabel* headerLabel = [[[UILabel alloc] initWithFrame:labelRect] autorelease];
    //headerLabel.backgroundColor = [UIColor lightGrayColor];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.font = [UIFont fontWithName:@"Futura" size:18.0];
    headerLabel.text = @"General";
    
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
#pragma mark private methods

- (void)setOrderOfChallengeAndSolution:(UISwitch*)sender
{
    if (sender.isOn) 
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"challengeIsFront"];
    } 
    else 
    {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"challengeIsFront"];
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
