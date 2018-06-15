//
//  NSString+MZFlashCardUtils.m
//  MZFlashCard
//
//  Created by Zalan Mergl on 9/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NSString+MZFlashCardUtils.h"


@implementation NSString (NSString_MZFlashCardUtils)

+ (NSString *)applicationDocumentsDirectory 
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

/*+ (NSString*)getPathForDirectory:(NSString*)directory
{
	NSFileManager* fm = [NSFileManager defaultManager];
	
	NSString* appSupportPath = [[NSString applicationDocumentsDirectory] stringByAppendingPathComponent:directory];
	
	if (![fm fileExistsAtPath:appSupportPath]) 
	{
		[fm createDirectoryAtPath:appSupportPath withIntermediateDirectories:YES attributes:nil error:nil];
	}
	
	return appSupportPath;
}
*/
@end
