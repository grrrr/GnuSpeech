//
// $Id: NSOutlineView-Extensions.h,v 1.3 2004/03/24 19:43:35 nygard Exp $
//

//  This file is part of __APPNAME__, __SHORT_DESCRIPTION__.
//  Copyright (C) 2004 __OWNER__.  All rights reserved.

#import <AppKit/NSOutlineView.h>

@interface NSOutlineView (Extensions)

- (id)selectedItem;
- (id)selectedItemOfClass:(Class)aClass;

- (void)selectItem:(id)anItem;
- (void)scrollRowForItemToVisible:(id)anItem;

- (void)resizeOutlineColumnToFit;

@end