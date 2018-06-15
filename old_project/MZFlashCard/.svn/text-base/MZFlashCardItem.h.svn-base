//
//  MZFlashCardItem.h
//  MZFlashCard
//
//  Created by Zalan Mergl on 8/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MZFlashCardItem : NSObject
{
    NSString*       _challenge;
    NSString*       _solution;
    
    NSInteger       _viewed;
    NSInteger       _solved;
    
    NSInteger       _goodnessIndex;
}

@property (nonatomic, retain) NSString*     challenge;
@property (nonatomic, retain) NSString*     solution;
@property (assign)            NSInteger     viewed;
@property (assign)            NSInteger     solved;
@property (readonly)          NSInteger     goodnessIndex;  // the more the better; more means infrequently occurrence

//designated initializer
//- (id)initWithChallenge:(NSString*)chal andSolution:(NSString*)sol;

@end
