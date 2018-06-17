//
//  MZFlashCardItem.m
//  MZFlashCard
//
//  Created by Zalan Mergl on 2018. 06. 16..
//

#import "MZFlashCardItem.h"

static NSString* const kChallengeCodingKey = @"challenge";
static NSString* const kSolutionCodingKey = @"solution";
static NSString* const kViewedCodingKey = @"viewed";
static NSString* const kSolvedCodingKey = @"solved";
static NSString* const kGoodnessIndexCodingKey = @"goodnessIndex";

@interface MZFlashCardItem ()

@property (nonatomic, assign, readwrite) NSInteger goodnessIndex;

@end

@implementation MZFlashCardItem

- (instancetype)initWithChallenge:(NSString*)challenge solution:(NSString*)solution
{
    self = [super init];
    
    if (self)
    {
        _challenge = challenge;
        _solution = solution;
    }
    
    return self;
}

#pragma mark - Custom getter

- (NSInteger)goodnessIndex
{
    NSInteger missed = self.viewed - self.solved;
    NSInteger goodnessIndex = missed == 0 ? 0 : self.viewed * self.solved / missed;
    
    return goodnessIndex;
}

#pragma mark - NSCoding protocol methods

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)aDecoder
{
    self = [super init];
    
    if (self)
    {
        _challenge = [aDecoder decodeObjectForKey:kChallengeCodingKey];
        _solution = [aDecoder decodeObjectForKey:kSolutionCodingKey];
        _viewed = [[aDecoder decodeObjectForKey:kViewedCodingKey] integerValue];
        _solved = [[aDecoder decodeObjectForKey:kSolvedCodingKey] integerValue];
        _goodnessIndex = [[aDecoder decodeObjectForKey:kGoodnessIndexCodingKey] integerValue];
    }
    
    return self;
}

- (void)encodeWithCoder:(nonnull NSCoder *)aCoder
{
    [aCoder encodeObject:self.challenge forKey:kChallengeCodingKey];
    [aCoder encodeObject:self.solution forKey:kSolutionCodingKey];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.viewed] forKey:kViewedCodingKey];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.solved] forKey:kSolvedCodingKey];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.goodnessIndex] forKey:kGoodnessIndexCodingKey];
}

@end
