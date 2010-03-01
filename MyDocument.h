//
//  MyDocument.h
//  TransientCoreDataTree
//
//  Created by Derek Kuhl on 11/12/08.
//  Copyright Inventive Research, LLC 2008 . All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface MyDocument : NSPersistentDocument {
	IBOutlet NSOutlineView*						completeOutlineView;
	
	IBOutlet NSTreeController*					treeController;
	
	IBOutlet NSArrayController*					parentController;
	IBOutlet NSArrayController*					modelController;
	
	BOOL										saveOnce;
	
	NSMutableSet*								includeSet;
}
@end
