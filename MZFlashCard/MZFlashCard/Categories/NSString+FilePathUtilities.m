//
//  NSString+FilePathUtilities.m
//  MZFlashCard
//
//  Created by Zalan Mergl on 2018. 06. 16..
//

#import "NSString+FilePathUtilities.h"

@implementation NSString (FilePathUtilities)

+ (NSString *)applicationDocumentsDirectory
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

@end
