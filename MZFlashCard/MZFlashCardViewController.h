//
//  MZFlashCardViewController.h
//  MZFlashCard
//
//  Created by Zalan Mergl on 8/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

/*enum {
    MZFlashCardIndexChallenge = 0,
    MZFlashCardIndexSolution
};
typedef NSUInteger MZFlashCardIndex;
*/

@class MZFlashCardItem;

@interface MZFlashCardViewController : UIViewController <UITextFieldDelegate>
{
    IBOutlet UILabel*       challengeLabel;
    IBOutlet UILabel*       solutionLabel;
    IBOutlet UIButton*      okButton;
    IBOutlet UIButton*      dontOkButton;
    IBOutlet UIView*        _fixItView;
    
    
    @private
    NSMutableArray*         _flashCardItems;
    MZFlashCardItem*        _flashCardItem;
    BOOL                    _challengeIsFront;
    NSTimer*                _timer;
//    NSArray*                _flashCardItemsFromFile;
}

@property (nonatomic, retain) IBOutlet UILabel*     challengeLabel;
@property (nonatomic, retain) IBOutlet UILabel*     solutionLabel;
@property (nonatomic, retain) IBOutlet UIButton*    okButton;
@property (nonatomic, retain) IBOutlet UIButton*    dontOkButton;
@property (nonatomic, retain) NSMutableArray*       flashCardItems;

- (IBAction)okButtonTouched:(id)sender;
- (IBAction)dontOkButtonTouched:(id)sender;
- (IBAction)loudspeakerButtonTouched:(id)sender;

@end
