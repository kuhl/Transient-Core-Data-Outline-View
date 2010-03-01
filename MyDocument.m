//
//  MyDocument.m
//  TransientCoreDataTree
//
//  Created by Derek Kuhl on 11/12/08.
//  Copyright Inventive Research, LLC 2008 . All rights reserved.
//

#import "MyDocument.h"

@implementation MyDocument

- (id)init 
{
    self = [super init];
    if (self != nil) {
		saveOnce = YES;
        // initialization code
    }
    return self;
}

- (id)initWithType:(NSString *)type error:(NSError **)error {
    self = [super initWithType:type error:error];
    if (self != nil)
	{
		
    }
    return self;
}

- (NSString *)windowNibName 
{
    return @"MyDocument";
}

- (void)windowControllerDidLoadNib:(NSWindowController *)windowController 
{
    [super windowControllerDidLoadNib:windowController];
    // user interface preparation code
	
	[treeController setSortDescriptors:[[NSArray alloc] initWithObjects:[[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES], nil]];
}


#pragma mark 
#pragma mark Error Handling

- (void)handleManagedObjectContextDidChangeNotification:(NSNotification *)notification
{
    NSError *error = nil;
	id managedContext = [self managedObjectContext];
	if (![self fileURL])
		return;
    if (![managedContext obtainPermanentIDsForObjects:[[managedContext registeredObjects] allObjects] error:&error]) {
		error = [NSError errorWithDomain:[self className] code:5000 userInfo:nil];
        [[NSApplication sharedApplication] presentError:error];
    }
}


#pragma mark -
#pragma mark Overloading

- (void)saveDocumentWithDelegate:(id)delegate didSaveSelector:(SEL)didSaveSelector contextInfo:(void *)contextInfo
{
	if(!delegate)
		delegate = self;
	if(!didSaveSelector)
		didSaveSelector = @selector(document:didSave:contextInfo:);
	
	[super saveDocumentWithDelegate:delegate didSaveSelector:didSaveSelector contextInfo:contextInfo];
}

- (void)document:(NSDocument *)doc didSave:(BOOL)didSaveSuccessfully  contextInfo:(void  *)contextInfo
{
	if(!didSaveSuccessfully)
	{
		return;
	}
	
	if(saveOnce)
	{
		saveOnce = NO;
		
		NSUndoManager *windowUndoMgr = [[self managedObjectContext] undoManager];
		[windowUndoMgr disableUndoRegistration];
		
		NSEnumerator* enumerator = [[[self managedObjectContext] registeredObjects] objectEnumerator];
		id newModel;
		
		while(newModel = [enumerator nextObject])
		{
			if([newModel valueForKey:@"parentURI"])
			{
				[newModel setValue:[[[[newModel valueForKey:@"parent"] objectID] URIRepresentation] description]
							forKey:@"parentURI"];
			}
		}
		
		[[self managedObjectContext] processPendingChanges];
		[self saveDocument:self];
		
		[windowUndoMgr enableUndoRegistration];
	}
}
@end
