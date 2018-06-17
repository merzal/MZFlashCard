//
//  MZFlashCardPack.m
//  MZFlashCard
//
//  Created by Zalan Mergl on 2018. 06. 16..
//

#import "MZFlashCardPack.h"

static NSString* const kTitleCodingKey = @"title";
static NSString* const kFlashCardsCodingKey = @"flashCards";

@implementation MZFlashCardPack

- (instancetype)initWithTitle:(NSString*)title flashCards:(NSArray<MZFlashCardItem*>*)flashCards
{
    self = [super init];
    
    if (self)
    {
        _title = title;
        _flashCards = [NSMutableArray arrayWithArray:flashCards];
    }
    
    return self;
}

#pragma mark - NSCoding protocol methods

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)aDecoder
{
    self = [super init];
    
    if (self)
    {
        _title = [aDecoder decodeObjectForKey:kTitleCodingKey];
        _flashCards = [aDecoder decodeObjectForKey:kFlashCardsCodingKey];
    }
    
    return self;
}

- (void)encodeWithCoder:(nonnull NSCoder *)aCoder
{
    [aCoder encodeObject:self.title forKey:kTitleCodingKey];
    [aCoder encodeObject:self.flashCards forKey:kFlashCardsCodingKey];
}

@end
