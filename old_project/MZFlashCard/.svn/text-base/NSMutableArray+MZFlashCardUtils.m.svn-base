//
//  NSMutableArray+MZFlashCardUtils.m
//  MZFlashCard
//
//  Created by Zalan Mergl on 9/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NSMutableArray+MZFlashCardUtils.h"


@implementation NSMutableArray (NSMutableArray_MZFlashCardUtils)

+ (NSMutableArray*)deserializedContentsOfArray:(NSMutableArray*)originalArray
{
	NSMutableArray* retVal = [NSMutableArray array];
    
	for (id obj in originalArray) 
	{
		[retVal addObject:[NSKeyedUnarchiver unarchiveObjectWithData:obj]];
	}
	
	return retVal;
}

+ (NSMutableArray*)serializedContentsOfArray:(NSMutableArray*)originalArray
{
	NSMutableArray* retVal = [NSMutableArray array];
	
	for (id obj in originalArray) 
	{
		[retVal addObject:[NSKeyedArchiver archivedDataWithRootObject:obj]];
	}
	
	return retVal;
}

@end
