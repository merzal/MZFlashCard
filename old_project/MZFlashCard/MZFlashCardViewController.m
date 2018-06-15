//
//  MZFlashCardViewController.m
//  MZFlashCard
//
//  Created by Zalan Mergl on 8/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MZFlashCardViewController.h"
#import "MZFlashCardItem.h"
#import "NSString+MZFlashCardUtils.h"

#define LIMIT 10.0 //a LIMIT százaléknyi legrosszabb szóból dobja a következőt; maximum 100.0

@interface MZFlashCardViewController (Private)
- (MZFlashCardItem*)getRandomFlashCardItem;
//- (void)prepareFlashCardsFromDatabaseAndFromFile;
- (void)goToNextRun;
- (NSString*)getActualFlashCardChallengeText;
- (NSString*)getActualFlashCardSolutionText;
//- (void)loadDataFromDisk;
//- (void)saveDataToDisk;
- (void)setupFontSizeForLabel:(UILabel*)label;
@end

@implementation MZFlashCardViewController

@synthesize challengeLabel;
@synthesize solutionLabel;
@synthesize okButton;
@synthesize dontOkButton;
@synthesize flashCardItems = _flashCardItems;

#pragma mark -
#pragma mark private methods

- (void)explainWord
{
    solutionLabel.text = [self getActualFlashCardSolutionText];
    [self setupFontSizeForLabel:solutionLabel];
}

- (IBAction)okButtonTouched:(id)sender
{
    _flashCardItem.viewed++;
    _flashCardItem.solved++;
    
    [self goToNextRun];
}

- (IBAction)dontOkButtonTouched:(id)sender
{
    _flashCardItem.viewed++;
    
    [self goToNextRun];
}

- (void) goToNextRun 
{
    _flashCardItem = [self getRandomFlashCardItem];
    
    
    challengeLabel.text = [self getActualFlashCardChallengeText];
    [self setupFontSizeForLabel:challengeLabel];
    
    
    solutionLabel.text = @"...";
    [self setupFontSizeForLabel:solutionLabel];
}

/*- (void)prepareFlashCardsFromDatabaseAndFromFile
{
    NSString* path = [[NSBundle mainBundle] pathForResource:@"exampleDataBase" ofType:@"plist"];
    NSArray* array = [[NSArray alloc] initWithContentsOfFile:path];
    
    _flashCardItems = [[NSMutableArray alloc] init];
    
    for (NSArray* item in array) 
    {
        NSString* itemChallenge = [item objectAtIndex:0];
        NSString* itemSolution = [item objectAtIndex:1];
        
        BOOL isFlashCardStored = NO;
        MZFlashCardItem* tempItem;
        
        for (MZFlashCardItem* flashCardFromFile in _flashCardItemsFromFile) 
        {
            NSString* fileChallenge = flashCardFromFile.challenge;
            NSString* fileSolution = flashCardFromFile.solution;
            
            if ([itemChallenge isEqualToString:fileChallenge] && [itemSolution isEqualToString:fileSolution]) 
            {
                isFlashCardStored = YES;
                tempItem = flashCardFromFile;
                break;
            }
        }
        
        if (isFlashCardStored) 
        {
            _flashCardItem = [tempItem retain];
        }
        else
        {
            _flashCardItem = [[MZFlashCardItem alloc] init];
            _flashCardItem.challenge = [item objectAtIndex:0];
            _flashCardItem.solution = [item objectAtIndex:1];
        }
        
        [_flashCardItems addObject:_flashCardItem];
        
        [_flashCardItem release];
    }
    
    [array release];
    
    [_flashCardItemsFromFile release];
    
    //[self logFlashCardItems];
}
 */

- (MZFlashCardItem*)getRandomFlashCardItem
{
    // sort flashCardItems by goodnessIndex
    [_flashCardItems sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        
        NSComparisonResult retVal;
        
        if ([(MZFlashCardItem*)obj1 goodnessIndex] < [(MZFlashCardItem*)obj2 goodnessIndex]) 
        {
            retVal = NSOrderedAscending;
        }
        else if ([(MZFlashCardItem*)obj1 goodnessIndex] > [(MZFlashCardItem*)obj2 goodnessIndex])
        {
            retVal = NSOrderedDescending;
        }
        else
        {
            retVal = NSOrderedSame;
        }
        
        return retVal;
    }];
    
    NSInteger countOfCardsHaveChance = (NSInteger)floor([_flashCardItems count] * (LIMIT / 100.0));
    
    if (countOfCardsHaveChance <= 1)
    {
        countOfCardsHaveChance = 2;
    }
    
    NSInteger randomNumber = arc4random() % countOfCardsHaveChance;
    
    MZFlashCardItem* newFlashCard = [_flashCardItems objectAtIndex:randomNumber];
    
    //if the count of flashcard items is too little
    NSInteger maxRoundCounter = 10;
    
    while ([newFlashCard isEqual:_flashCardItem])
    {
        randomNumber = arc4random() % countOfCardsHaveChance;
        
        newFlashCard = [_flashCardItems objectAtIndex:randomNumber];
        
        if (maxRoundCounter-- == 0) break;
    }
            
    MZFlashCardItem* retVal = newFlashCard;
    
    return retVal;
}

- (NSString*)getActualFlashCardChallengeText
{
    NSString* retVal;
    
    if (_challengeIsFront) 
    {
        retVal = _flashCardItem.challenge;
    } 
    else 
    {
        retVal = _flashCardItem.solution;
    }
    
    return retVal;
}

- (NSString*)getActualFlashCardSolutionText
{
    NSString* retVal;
    
    if (_challengeIsFront) 
    {
        retVal = _flashCardItem.solution;
    } 
    else 
    {
        retVal = _flashCardItem.challenge;
    }
    
    return retVal;
}

- (void)setupFontSizeForLabel:(UILabel*)label
{
    UIFont* referenceFont = [UIFont fontWithName:label.font.fontName size:30.0];
    
    CGSize maximumSize = CGSizeMake(label.frame.size.width, CGFLOAT_MAX);
    CGSize stringSize = [label.text sizeWithFont:referenceFont
                                           constrainedToSize:maximumSize
                                               lineBreakMode:label.lineBreakMode];
    
    CGFloat newFontSize = (label.frame.size.height / stringSize.height) * referenceFont.pointSize;
    
    if (newFontSize <= referenceFont.pointSize) 
    {
        label.font = [UIFont fontWithName:label.font.fontName size:newFontSize];
    }
    else
    {
        label.font = referenceFont;
    }
}

- (void)logFlashCardItems
{
    NSLog(@"flascarditems utána:\n");
    
    for (MZFlashCardItem* flashCard in _flashCardItems) 
    {
        NSLog(@"\%@: %i",flashCard.challenge, flashCard.goodnessIndex);
    }
    
    NSLog(@"------------------------");
    
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)awakeFromNib
{
    //[self loadDataFromDisk];
    
    //[self logFlashCardItems];
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
}

#pragma mark -
#pragma mark FlashCard repair functions

- (BOOL)canBecomeFirstResponder 
{
    return YES;
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (motion == UIEventSubtypeMotionShake)
    {
        // User WAS shaking the device.
        NSLog(@"shaked");
        
        UITapGestureRecognizer* tripleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fixFlashCardItem)];
        tripleTap.numberOfTapsRequired = 3;
        
        [self.challengeLabel addGestureRecognizer:tripleTap];
        
        [tripleTap release];
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(timeOut) userInfo:nil repeats:NO];
    }
}

- (void)removeGestureRecognizerFromChallengeLabel
{
    [self.challengeLabel removeGestureRecognizer:[[self.challengeLabel gestureRecognizers] objectAtIndex:0]];
}

- (void)timeOut
{
    [self removeGestureRecognizerFromChallengeLabel];
}

- (NSArray*)getFixItViewTextFields
{
    UITextField* chalTextField = nil;
    UITextField* solTextField = nil;
    
    for (UIView* subview in [_fixItView subviews]) 
    {
        if (subview.tag == 11)
        {
            chalTextField = (UITextField*)subview;
        }
        else if (subview.tag == 22)
        {
            solTextField = (UITextField*)subview;
        }
    }
    
    NSArray* retVal = [NSArray arrayWithObjects:chalTextField, solTextField, nil];
    
    return retVal;
}

- (void)fixFlashCardItem
{    
    if ([_timer isValid]) 
    {
        [_timer invalidate];
    }
    
    [self removeGestureRecognizerFromChallengeLabel];
    
    CGRect newRect = _fixItView.frame;
    newRect.origin.y = -200.0;
    _fixItView.frame = newRect;
    
    [self.view addSubview:_fixItView];
    
    [UIView animateWithDuration:0.25 animations:^(void)
     {
         CGRect newRect = _fixItView.frame;
         newRect.origin.y = 0.0;
         _fixItView.frame = newRect;
     }];
    
    UITextField* chalTextField = [[self getFixItViewTextFields] objectAtIndex:0];
    UITextField* solTextField = [[self getFixItViewTextFields] objectAtIndex:1];
    
    chalTextField.text = [self getActualFlashCardChallengeText];
    chalTextField.delegate = self;
    solTextField.text = [self getActualFlashCardSolutionText];
    solTextField.delegate = self;
    
    [chalTextField becomeFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{    
    UITextField* chalTextField = [[self getFixItViewTextFields] objectAtIndex:0];
    UITextField* solTextField = [[self getFixItViewTextFields] objectAtIndex:1];
    
    if (textField.tag == 11) 
    {
        [solTextField becomeFirstResponder];
    } 
    else if (textField.tag == 22)
    {
        //saving edited flashcard data and
        //modify text of challengeLabel and solutionLabel
        if (_challengeIsFront)
        {
            _flashCardItem.challenge = chalTextField.text;
            _flashCardItem.solution = solTextField.text;
            
            challengeLabel.text = chalTextField.text;
            [self setupFontSizeForLabel:challengeLabel];
            solutionLabel.text = solTextField.text;
            [self setupFontSizeForLabel:solutionLabel];
        }
        else
        {
            _flashCardItem.challenge = solTextField.text;
            _flashCardItem.solution = chalTextField.text;
            
            challengeLabel.text = solTextField.text;
            [self setupFontSizeForLabel:challengeLabel];
            solutionLabel.text = chalTextField.text;
            [self setupFontSizeForLabel:solutionLabel];
        }
        
        [textField resignFirstResponder];
        [self becomeFirstResponder];
        
        [UIView animateWithDuration:0.25 
                         animations:^(void)
         {
             CGRect newRect = _fixItView.frame;
             newRect.origin.y = -200.0;
             _fixItView.frame = newRect;
         }
                         completion:^(BOOL finished)
         {
             if (finished) 
             {
                 [_fixItView removeFromSuperview];
             }
         }];
    }
    
    return YES;
}

/*
- (void)applicationDidEnterBackground:(NSNotification*)note
{
    [self saveDataToDisk];
}
*/
/*- (void)loadDataFromDisk
{
    NSLog(@"path: %@",[[NSString applicationDocumentsDirectory] stringByAppendingString:@"/someFile.zal"]);
    
    _flashCardItemsFromFile = [[NSArray alloc] initWithArray:[NSKeyedUnarchiver unarchiveObjectWithFile:[[NSString applicationDocumentsDirectory] stringByAppendingString:@"/someFile.zal"]]];
}
*/
/*- (void)saveDataToDisk
{
    [NSKeyedArchiver archiveRootObject:_flashCardItems toFile:[[NSString applicationDocumentsDirectory] stringByAppendingString:@"/someFile.zal"]];
}
*/
#pragma mark - View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{    
    [super viewDidLoad];
    
    UITapGestureRecognizer* recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(explainWord)];
    [solutionLabel addGestureRecognizer:recognizer];
    [recognizer release];
    
    //[self prepareFlashCardsFromDatabaseAndFromFile];
    
    _flashCardItem = [self getRandomFlashCardItem];
    
    _challengeIsFront = [[NSUserDefaults standardUserDefaults] boolForKey:@"challengeIsFront"];
    
    challengeLabel.text = [self getActualFlashCardChallengeText];   
    [self setupFontSizeForLabel:challengeLabel];
}

- (void)viewDidAppear:(BOOL)animated 
{
    [super viewDidAppear:animated];
    [self becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FlashCardViewControllerWillDisappear" object:nil];
}

- (void)viewDidDisappear:(BOOL)animated 
{
    [self resignFirstResponder];
    [super viewDidDisappear:animated];
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

- (void)dealloc
{
    //[[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [_flashCardItems release];
    
    [super dealloc];
}

@end
