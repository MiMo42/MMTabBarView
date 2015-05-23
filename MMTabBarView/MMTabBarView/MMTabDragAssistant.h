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

@interface MMTabDragAssistant : NSObject <NSAnimationDelegate>

// Creation/destruction
+ (instancetype)sharedDragAssistant;

#pragma mark Properties

@property (strong) MMTabBarView *sourceTabBar;
@property (strong) MMAttachedTabBarButton *attachedTabBarButton;
@property (strong) MMTabPasteboardItem *pasteboardItem;
@property (strong) MMTabBarView *destinationTabBar;
@property (assign) BOOL isDragging;
@property (assign) NSPoint currentMouseLocation;

@property (assign) BOOL isSliding;

#pragma mark Dragging Source Handling

- (NSDragOperation)draggingSourceOperationMaskForLocal:(BOOL)isLocal ofTabBarView:(MMTabBarView *)tabBarView;

- (BOOL)shouldStartDraggingAttachedTabBarButton:(MMAttachedTabBarButton *)aButton ofTabBarView:(MMTabBarView *)tabBarView withMouseDownEvent:(NSEvent *)event;

- (void)startDraggingAttachedTabBarButton:(MMAttachedTabBarButton *)aButton fromTabBarView:(MMTabBarView *)tabBarView withMouseDownEvent:(NSEvent *)event;

- (void)draggedImageBeganAt:(NSPoint)aPoint withTabBarView:(MMTabBarView *)tabBarView;
- (void)draggedImageMovedTo:(NSPoint)aPoint;
- (void)draggedImageEndedAt:(NSPoint)aPoint operation:(NSDragOperation)operation;

#pragma mark Dragging Destination Handling

- (NSDragOperation)draggingEntered:(id <NSDraggingInfo>)sender inTabBarView:(MMTabBarView *)tabBarView;

- (NSDragOperation)draggingUpdated:(id <NSDraggingInfo>)sender inTabBarView:(MMTabBarView *)tabBarView;

- (void)draggingExitedTabBarView:(MMTabBarView *)tabBarView draggingInfo:(id <NSDraggingInfo>)sender;

- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender forTabBarView:(MMTabBarView *)tabBarView;

- (void)finishDragOfPasteboardItem:(MMTabPasteboardItem *)pasteboardItem;

#pragma mark Dragging Helpers

- (NSUInteger)destinationIndexForButton:(MMAttachedTabBarButton *)aButton atPoint:(NSPoint)aPoint inTabBarView:(MMTabBarView *)tabBarView;

@end

void CGContextCopyWindowCaptureContentsToRect(void *grafport, CGRect rect, NSInteger cid, NSInteger wid, NSInteger zero);
OSStatus CGSSetWindowTransform(NSInteger cid, NSInteger wid, CGAffineTransform transform);

@interface NSApplication (CoreGraphicsUndocumented)
- (NSInteger)contextID;
@end
