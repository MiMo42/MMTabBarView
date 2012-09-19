//
//  MMAttachedTabBarButton.h
//  MMTabBarView
//
//  Created by Michael Monscheuer on 9/5/12.
//
//

#import "MMTabBarButton.h"

#import "MMProgressIndicator.h"
#import "MMTabBarView.h"

@class MMAttachedTabBarButtonCell;

@protocol MMTabStyle;

@interface MMAttachedTabBarButton : MMTabBarButton {

@private
    NSTabViewItem *_tabViewItem;
}

@property (readonly) NSTabViewItem *tabViewItem;
@property (assign) NSRect slidingFrame;

// designated initializer
- (id)initWithFrame:(NSRect)frame tabViewItem:(NSTabViewItem *)anItem;

// overidden accessors (casting)
- (MMAttachedTabBarButtonCell *)cell;
- (void)setCell:(MMAttachedTabBarButtonCell *)aCell;

#pragma mark Drag Support

- (NSRect)draggingRect;
- (NSImage *)dragImage;

@end
