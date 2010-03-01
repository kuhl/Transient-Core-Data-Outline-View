//
//  ParentComboController.m
//  TransientCoreDataTree
//
//  Created by Derek Kuhl on 2/25/10.
//  Copyright 2010 Inventive Research, LLC. All rights reserved.
//

#import "ParentComboController.h"


@implementation ParentComboController

- (NSArray *)invalidParents
{
    return [[invalidParents retain] autorelease];
}

- (void)setInvalidParents:(NSArray *)value {
    if (invalidParents != value)
	{
        [invalidParents release];
        invalidParents = [value copy];
		[self rearrangeObjects];
    }
}

#pragma mark -
#pragma mark Overloading

- (NSArray *)arrangeObjects:(NSArray *)objectsToArrange
{
    int count = [invalidParents count];
	
    if ((count == 0) || !invalidParents)
    {
        return [super arrangeObjects:objectsToArrange];   
    }
	
    NSMutableArray *arrangedObjects;
    arrangedObjects = [NSMutableArray arrayWithCapacity:[objectsToArrange count] - count];
	
	NSMutableArray* invalids = [NSMutableArray arrayWithArray:invalidParents];
	id invalidPointer;
	count = 0;
	do
	{
		invalidPointer = [invalids objectAtIndex:count];
		if([invalidPointer valueForKey:@"children"])
		{
			[invalids addObjectsFromArray:[[invalids objectAtIndex:count] valueForKey:@"children"]];
		}
		count++;
	}while(invalidPointer && invalidPointer != [invalids lastObject]);
    
    NSEnumerator *objectEnumerator = [objectsToArrange objectEnumerator];
    id item;
    while (item = [objectEnumerator nextObject])
	{
        if (![invalids containsObject:item])
		{
            [arrangedObjects addObject:item];
        }
    }
	
    return [super arrangeObjects:arrangedObjects];
}

@end
