
/* Generated by Interface Builder */

#import <AppKit/NSResponder.h>

#import <AppKit/NSBrowser.h>
#import <AppKit/NSBrowserCell.h>
#import <AppKit/NSForm.h>

#import <AppKit/NSFont.h>

/*===========================================================================

	Author: Craig-Richard Taube-Schock
		Copyright (c) 1994, Trillium Sound Research Incorporated.
		All Rights Reserved.

=============================================================================



*/

@interface BrowserManager:NSResponder
{
	id	browser;
	id	controller;
	id	popUpList;

	id	list[5];
	int	currentList;

	id	addButton;
	id	renameButton;
	id	removeButton;

	id	nameField;

	NSFont    *courier, *courierBold;

}

- (BOOL) acceptsFirstResponder;
- (BOOL)becomeFirstResponder;
- (BOOL)resignFirstResponder;

- (void)applicationDidFinishLaunching:(NSNotification *)notification;
- (void)setCurrentList:sender;
- (void)updateBrowser;
- (void)updateLists;
- (void)addObjectToCurrentList:tempEntry;


/* Window Delegate Methods */
- (void)windowDidBecomeMain:(NSNotification *)notification;
- (BOOL)windowShouldClose:(id)sender;
- (void)windowDidResignMain:(NSNotification *)notification;


/* Browser Delegate Methods */
- (void)browserHit:sender;
- (void)browserDoubleHit:sender;
- (int)browser:(NSBrowser *)sender numberOfRowsInColumn:(int)column;
- (void)browser:(NSBrowser *)sender willDisplayCell:(id)cell atRow:(int)row column:(int)column;

- (void)add:sender;
- (void)rename:sender;
- (void)remove:sender;

- (void)cut:(id)sender;
- (void)copy:(id)sender;
- (void)paste:(id)sender;

@end
