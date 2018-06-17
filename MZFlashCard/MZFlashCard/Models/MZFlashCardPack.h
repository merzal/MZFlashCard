//
//  MZFlashCardPack.h
//  MZFlashCard
//
//  Created by Zalan Mergl on 2018. 06. 16..
//

#import <Foundation/Foundation.h>
#import "MZFlashCardItem.h"

@interface MZFlashCardPack : NSObject <NSCoding>

@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) NSMutableArray<MZFlashCardItem*>* flashCards;

- (instancetype)initWithTitle:(NSString*)title flashCards:(NSArray<MZFlashCardItem*>*)flashCards;

@end
