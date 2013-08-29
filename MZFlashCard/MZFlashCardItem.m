//
//  MZFlashCardItem.m
//  MZFlashCard
//
//  Created by Zalan Mergl on 8/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MZFlashCardItem.h"

@implementation MZFlashCardItem

@synthesize challenge = _challenge;
@synthesize solution = _solution;
@synthesize viewed = _viewed;
@synthesize solved = _solved;
@synthesize goodnessIndex = _goodnessIndex;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        _viewed = 1;
        _solved = 0;
        _goodnessIndex = 0;
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder*)coder
{
    self = [super init];
    if (self) {
        self.challenge = [coder decodeObjectForKey:@"challenge"];
        self.solution = [coder decodeObjectForKey:@"solution"];
        _viewed = [[coder decodeObjectForKey:@"viewed"] intValue];
        _solved = [[coder decodeObjectForKey:@"solved"] intValue];
        _goodnessIndex = [[coder decodeObjectForKey:@"goodnessIndex"] intValue];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder*)coder
{
    [coder encodeObject:_challenge forKey:@"challenge"];
    [coder encodeObject:_solution forKey:@"solution"];
    [coder encodeObject:[NSNumber numberWithInt:_viewed] forKey:@"viewed"];
    [coder encodeObject:[NSNumber numberWithInt:_solved] forKey:@"solved"];
    [coder encodeObject:[NSNumber numberWithInt:_goodnessIndex] forKey:@"goodnessIndex"];
}

- (NSInteger)goodnessIndex
{
    NSInteger missed = _viewed - _solved;
    NSInteger retVal = _viewed * _solved / missed;
    
    return retVal;
}

@end
