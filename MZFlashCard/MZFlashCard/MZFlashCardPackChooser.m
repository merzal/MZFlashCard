//
//  MZFlashCardPackChooser.m
//  MZFlashCard
//
//  Created by Zalan Mergl on 2018. 06. 16..
//

#import "MZFlashCardPackChooser.h"
#import "MZFlashCardPack.h"
#import "NSString+FilePathUtilities.h"
#import "MZFlashCardPackChooserTableViewCell.h"
#import "MZFlashCardViewController.h"

#define MZ_FLASHCARD_FILE_EXTENSION @"mzfc"
#define CARD_PACK_CELL_ID @"CardPackCellID"

@interface MZFlashCardPackChooser ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *noCardPackAvailableLabel;

@property (nonatomic, strong) NSMutableArray<MZFlashCardPack*>* cardPacks;
@property (nonatomic, strong) MZFlashCardPack* selectedCardPack;

- (void)saveCardPacksToDisk;

@end

@implementation MZFlashCardPackChooser

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:NO];
    
    self.title = @"Choose a pack";
    
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addCardPackButtonPushed:)];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MZFlashCardPackChooserTableViewCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:CARD_PACK_CELL_ID];
    
    self.cardPacks = [NSMutableArray array];
    
    [self loadCardPacksFromDisk];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    self.noCardPackAvailableLabel.hidden = self.cardPacks.count != 0;
    
    tableView.separatorStyle = self.cardPacks.count == 0 ? UITableViewCellSeparatorStyleNone : UITableViewCellSeparatorStyleSingleLine;
    
    return self.cardPacks.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MZFlashCardPack* cardPackForCell = self.cardPacks[indexPath.row];
    
    MZFlashCardPackChooserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CARD_PACK_CELL_ID forIndexPath:indexPath];

    cell.titleLabel.text = cardPackForCell.title;
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [self deleteCardPackAtIndex:indexPath.row];
        
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedCardPack = self.cardPacks[indexPath.row];
    
    [self performSegueWithIdentifier:@"showFlashCardVC" sender:nil];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showFlashCardVC"])
    {
        MZFlashCardViewController* flashCardVC = (MZFlashCardViewController*)segue.destinationViewController;
        flashCardVC.cardPack = self.selectedCardPack;
    }
}

#pragma mark - Actions

- (void)addCardPackButtonPushed:(UIBarButtonItem*)barButtonItem
{
    [self performSegueWithIdentifier:@"showGoogleVC" sender:nil];
//    if (self.cardPacks.count == 0)
//    {
//        NSArray* flashCards = @[[[MZFlashCardItem alloc] initWithChallenge:@"challenge1" solution:@"solution1"],
//                                [[MZFlashCardItem alloc] initWithChallenge:@"challenge2" solution:@"solution2"],
//                                [[MZFlashCardItem alloc] initWithChallenge:@"challenge3" solution:@"solution3"],
//                                [[MZFlashCardItem alloc] initWithChallenge:@"challenge4" solution:@"solution4"],
//                                [[MZFlashCardItem alloc] initWithChallenge:@"challenge5" solution:@"solution5"]
//                                ];
//
//        NSArray* cardPacks = @[[[MZFlashCardPack alloc] initWithTitle:@"First card pack" flashCards:flashCards]
////                               [[MZFlashCardPack alloc] initWithTitle:@"Second card pack" flashCards:flashCards],
////                               [[MZFlashCardPack alloc] initWithTitle:@"Third card pack" flashCards:flashCards],
////                               [[MZFlashCardPack alloc] initWithTitle:@"Fourth card pack" flashCards:flashCards],
//                               ];
//
//        self.cardPacks = [NSMutableArray arrayWithArray:cardPacks];
//
//        [self saveCardPacksToDisk];
//
//        [self.tableView reloadData];
//    }
}

#pragma mark - Private helper methods

- (void)loadCardPacksFromDisk
{
    [self.cardPacks removeAllObjects];
    
    NSArray* fileNames = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[NSString applicationDocumentsDirectory] error:nil];
    
    for (NSString* fileName in fileNames)
    {
        NSString* fileExtension = [fileName pathExtension];
        
        if ([[fileExtension lowercaseString] isEqualToString:MZ_FLASHCARD_FILE_EXTENSION])
        {
            NSString* filePath = [[NSString applicationDocumentsDirectory] stringByAppendingPathComponent:fileName];
            
            MZFlashCardPack* cardPack = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
            
            [self.cardPacks addObject:cardPack];
        }
    }
    
    for (MZFlashCardPack* cardPack in self.cardPacks)
    {
        NSLog(@"Loaded cardPack: %@", cardPack.title);
    }
    
    [self.tableView reloadData];
}

- (void)saveCardPacksToDisk
{
    for (MZFlashCardPack* cardPack in self.cardPacks)
    {
        NSString* fileName = [cardPack.title stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLPathAllowedCharacterSet]];
        
        NSString* finalFileName = [NSString stringWithFormat:@"%@.%@", fileName, MZ_FLASHCARD_FILE_EXTENSION];
        
        NSString* filePath = [[NSString applicationDocumentsDirectory] stringByAppendingPathComponent:finalFileName];

        [NSKeyedArchiver archiveRootObject:cardPack toFile:filePath];
    }
}

- (void)deleteCardPackAtIndex:(NSInteger)index
{
    MZFlashCardPack* cardPackToDelete = self.cardPacks[index];
    
    NSString* fileName = [cardPackToDelete.title stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLPathAllowedCharacterSet]];
    
    NSString* finalFileName = [NSString stringWithFormat:@"%@.%@", fileName, MZ_FLASHCARD_FILE_EXTENSION];
    
    NSString* filePath = [[NSString applicationDocumentsDirectory] stringByAppendingPathComponent:finalFileName];
    
    [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
    
    [self.cardPacks removeObjectAtIndex:index];
}

@end
