//
//  MZFlashCardPackChooser.m
//  MZFlashCard
//
//  Created by Zalan Mergl on 2018. 06. 16..
//

#import "MZFlashCardPackChooser.h"
#import "MZFlashCardPack.h"
#import "NSString+FilePathUtilities.h"

@interface MZFlashCardPackChooser ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *noCardPackAvailableLabel;

@property (nonatomic, strong) NSMutableArray<MZFlashCardPack*>* cardPacks;

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
    
    self.cardPacks = [NSMutableArray array];
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

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/







#pragma mark - Actions

- (void)addCardPackButtonPushed:(UIBarButtonItem*)barButtonItem
{
    NSArray* flashCards = @[[[MZFlashCardItem alloc] initWithChallenge:@"challenge1" solution:@"solution1"],
                            [[MZFlashCardItem alloc] initWithChallenge:@"challenge2" solution:@"solution2"],
                            [[MZFlashCardItem alloc] initWithChallenge:@"challenge3" solution:@"solution3"],
                            [[MZFlashCardItem alloc] initWithChallenge:@"challenge4" solution:@"solution4"],
                            [[MZFlashCardItem alloc] initWithChallenge:@"challenge5" solution:@"solution5"],
                            ];
    
    NSArray* cardPacks = @[[[MZFlashCardPack alloc] initWithTitle:@"First card pack" flashCards:flashCards],
                           [[MZFlashCardPack alloc] initWithTitle:@"Second card pack" flashCards:flashCards],
                           [[MZFlashCardPack alloc] initWithTitle:@"Third card pack" flashCards:flashCards],
                           [[MZFlashCardPack alloc] initWithTitle:@"Fourth card pack" flashCards:flashCards],
                           ];
    
    self.cardPacks = [NSMutableArray arrayWithArray:cardPacks];
    
    [self saveCardPacksToDisk];
}

#pragma mark - Private helper methods

- (void)saveCardPacksToDisk
{
    for (MZFlashCardPack* cardPack in self.cardPacks)
    {
        NSString* fileName = [cardPack.title stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLPathAllowedCharacterSet]];
        
        NSString* finalFileName = [NSString stringWithFormat:@"%@.mzcf", fileName];
        
        NSString* filePath = [[NSString applicationDocumentsDirectory] stringByAppendingPathComponent:finalFileName];

        [NSKeyedArchiver archiveRootObject:cardPack toFile:filePath];
    }
}

@end
