//
//  MMTabDragAssistant.h
//  MMTabBarView
//
//  Created by John Pannell on 4/10/06.
//  Copyright 2006 Positive Spin Media. All rights reserved.
//

/*
   This class is a sigleton that manages the details of a tab drag and drop.  The details were beginning to overwhelm me when keeping all of this in the control and buttons :-)
 */

#import <Cocoa/Cocoa.h>
#import "MMTabBarView.h"

@class MMTabDragWindowController, MMTabPasteboardItem;

extern NSString *AttachedTabBarButtonUTI;

@interface MMTabDragAssistant : NSObject <NSAnimationDelegate> {

@private

	NSPoint							_currentMouseLocation;

        // standard drag & drop support
    MMTabPasteboardItem             *_pasteboardItem;
	MMTabBarView                    *_destinationTabBar;
	NSMutableSet					*_participatingTabBars;
	BOOL							_isDragging;
        
        // sliding support
    BOOL                            _isSliding;

        // Support for dragging into new windows
	MMTabDragWindowController		*_draggedTab;
	MMTabDragWindowController		*_draggedView;
	NSSize							_dragWindowOffset;
	NSTimer							*_fadeTimer;
	BOOL							_centersDragWindows;
	MMTabBarTearOffStyle			_currentTearOffStyle;

        // Animation
    MMSlideButtonsAnimation         *_slideButtonsAnimation;
}

@property (retain) MMTabPasteboardItem *pasteboardItem;
@property (retain) MMTabBarView *destinationTabBar;
@property (assign) BOOL isDragging;
@property (assign) NSPoint currentMouseLocation;

@property (assign) BOOL isSliding;

// Creation/destruction
+ (MMTabDragAssistant *)sharedDragAssistant;

// Functionality
- (void)startDraggingAttachedTabBarButton:(MMAttachedTabBarButton *)aButton fromTabBarView:(MMTabBarView *)tabBarView withMouseDownEvent:(NSEvent *)event;
- (void)draggingEnteredTabBarView:(MMTabBarView *)tabBarView atPoint:(NSPoint)mouseLoc draggingInfo:(id <NSDraggingInfo>)sender;
- (void)draggingUpdatedInTabBarView:(MMTabBarView *)tabBarView atPoint:(NSPoint)mouseLoc draggingInfo:(id <NSDraggingInfo>)sender;
- (void)draggingExitedTabBarView:(MMTabBarView *)tabBarView draggingInfo:(id <NSDraggingInfo>)sender;
- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender forTabBarView:(MMTabBarView *)tabBarView;
- (void)draggedImageEndedAt:(NSPoint)aPoint operation:(NSDragOperation)operation;
- (void)finishDragOfPasteboardItem:(MMTabPasteboardItem *)pasteboardItem;

- (void)draggedImageBeganAt:(NSPoint)aPoint withTabBarView:(MMTabBarView *)tabBarView;
- (void)draggedImageMovedTo:(NSPoint)aPoint;

- (MMAttachedTabBarButton *)attachedTabBarButtonForDraggedItems;

@end

void CGContextCopyWindowCaptureContentsToRect(void *grafport, CGRect rect, NSInteger cid, NSInteger wid, NSInteger zero);
OSStatus CGSSetWindowTransform(NSInteger cid, NSInteger wid, CGAffineTransform transform);

@interface NSApplication (CoreGraphicsUndocumented)
- (NSInteger)contextID;
@end
