//
//  TreeNode.h
//  TransientCoreDataTree
//
//  Created by Derek Kuhl on 11/12/08.
//  Copyright 2008 Inventive Research, LLC. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface TreeNode :  NSManagedObject  
{
}

- (void)setParent:(TreeNode *)value;

- (void)setUpRelationships;

@end
