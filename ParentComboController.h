//
//  ParentComboController.h
//  TransientCoreDataTree
//
//  Created by Derek Kuhl on 2/25/10.
//  Copyright 2010 Inventive Research, LLC. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface ParentComboController : NSArrayController {
	NSArray*	invalidParents;
}

- (NSArray *)invalidParents;
- (void)setInvalidParents:(NSArray *)value;
@end
