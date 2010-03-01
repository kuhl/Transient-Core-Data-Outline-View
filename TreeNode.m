// 
//  TreeNode.m
//  TransientCoreDataTree
//
//  Created by Derek Kuhl on 11/12/08.
//  Copyright 2008 Inventive Research, LLC. All rights reserved.
//

#import "TreeNode.h"


@implementation TreeNode 

- (void)awakeFromInsert
{
    static int untitledCount = 1;
    NSString* untitledContents = [NSString stringWithFormat: @"#%d", untitledCount++];
	[self setValue:untitledContents forKey: @"name"];
	[super awakeFromInsert];
}

- (void)setParent:(TreeNode *)aParent {
    [self willChangeValueForKey: @"parent"];
    [self setPrimitiveValue: aParent forKey: @"parent"];
    [self didChangeValueForKey: @"parent"];
	
    // Parent is a to one relationship, so when the parent relationship is set, also fill in the underlying storage
    [self willChangeValueForKey: @"parentURI"];
    [self setPrimitiveValue:[[[aParent objectID] URIRepresentation] description]
					 forKey: @"parentURI"];
    [self didChangeValueForKey: @"parentURI"];
}

- (void)setUpRelationships{
	NSString* parentID = [self primitiveValueForKey:@"parentURI"];
	id parentObject = nil;
	
	if(parentID)
		parentObject = [[self managedObjectContext] objectWithURI:[NSURL URLWithString:parentID]];
	if(parentObject)
		[self setParent:parentObject];	
}

@end

@implementation NSManagedObjectContext (FetchedObjectFromURI)
- (NSManagedObject *)objectWithURI:(NSURL *)uri
{
    NSManagedObjectID *objectID = [[self persistentStoreCoordinator] managedObjectIDForURIRepresentation:uri];
    
    if (!objectID)
    {
        return nil;
    }
    
    NSManagedObject *objectForID = [self objectWithID:objectID];
    if (![objectForID isFault])
    {
        return objectForID;
    }
	
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    [request setEntity:[objectID entity]];
    
    // Equivalent to
    // predicate = [NSPredicate predicateWithFormat:@"SELF = %@", objectForID];
    NSPredicate *predicate = [NSComparisonPredicate predicateWithLeftExpression:[NSExpression expressionForEvaluatedObject]
																rightExpression:[NSExpression expressionForConstantValue:objectForID]
																	   modifier:NSDirectPredicateModifier
																		   type:NSEqualToPredicateOperatorType
																		options:0];
    [request setPredicate:predicate];
	
    NSArray *results = [self executeFetchRequest:request error:nil];
    if ([results count] > 0 )
    {
        return [results objectAtIndex:0];
    }
	
    return nil;
}
@end

