//
//  MZFlashCardItem.h
//  MZFlashCard
//
//  Created by Zalan Mergl on 2018. 06. 16..
//

#import <Foundation/Foundation.h>

@interface MZFlashCardItem : NSObject <NSCoding>

@property (nonatomic, strong) NSString* challenge;
@property (nonatomic, strong) NSString* solution;
@property (nonatomic, assign) NSInteger viewed; // number of the cases when this card was displayed to the user
@property (nonatomic, assign) NSInteger solved; // number of the cases when user pushed 'OK' button for this card
@property (nonatomic, assign, readonly) NSInteger goodnessIndex;  // the more the better; more means infrequently occurrence

- (instancetype)initWithChallenge:(NSString*)challenge solution:(NSString*)solution;

@end
