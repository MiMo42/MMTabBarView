//
//  MMSafariTabStyle.m
//  MMTabBarView
//
//  Created by Michael Monscheuer on 9/20/12.
//  Copyright 2011 Marrintech. All rights reserved.
//

#import "MMSafariTabStyle.h"

#import "MMTabBarView.h"
#import "MMAttachedTabBarButton.h"
#import "NSView+MMTabBarViewExtensions.h"

#define StaticImage(name) \
static NSImage* _static##name##Image() \
{ \
    static NSImage* image = nil; \
    if (!image) \
        image = [[NSImage alloc] initByReferencingFile:[[MMTabBarView bundle] pathForImageResource:@#name]]; \
    return image; \
}

@implementation MMSafariTabStyle

StaticImage(TabClose_Front)
StaticImage(TabClose_Front_Pressed)
StaticImage(TabClose_Front_Rollover)
StaticImage(TabClose_Dirty)
StaticImage(TabClose_Dirty_Pressed)
StaticImage(TabClose_Dirty_Rollover)
StaticImage(TabNew)
StaticImage(TabNew_Pressed)
StaticImage(TabNew_Rollover)
StaticImage(SafariAWATFill)
StaticImage(SafariAWATLeftCap)
StaticImage(SafariAWATRightCap)
StaticImage(SafariAWBG)
StaticImage(SafariAWITLeftCap)
StaticImage(SafariAWITRightCap)
StaticImage(SafariIWATFill)
StaticImage(SafariIWATLeftCap)
StaticImage(SafariIWATRightCap)
StaticImage(SafariIWBG)
StaticImage(SafariIWITLeftCap)
StaticImage(SafariIWITRightCap)

+ (NSString *)name {
    return @"Safari";
}

- (NSString *)name {
	return [[self class] name];
}

#pragma mark -
#pragma mark Creation/Destruction

- (id) init {
	if((self = [super init])) {
		_objectCountStringAttributes = [[NSDictionary alloc] initWithObjectsAndKeys:[[NSFontManager sharedFontManager] convertFont:[NSFont fontWithName:@"Helvetica" size:11.0] toHaveTrait:NSBoldFontMask], NSFontAttributeName,
										[[NSColor whiteColor] colorWithAlphaComponent:0.85], NSForegroundColorAttributeName,
										nil, nil];
	}
	return self;
}

- (void)dealloc {
	[_objectCountStringAttributes release];

	[super dealloc];
}

#pragma mark -
#pragma mark Tab View Specific
/*
- (CGFloat)leftMarginForTabBarView:(MMTabBarView *)tabBarView {
	return 11.0f;
}

- (CGFloat)rightMarginForTabBarView:(MMTabBarView *)tabBarView {
	return 11.0f;
}
*/

#pragma mark -
#pragma mark Add Tab Button

- (NSImage *)addTabButtonImage {
	return _staticTabNewImage();
}

- (NSImage *)addTabButtonPressedImage {
	return _staticTabNew_PressedImage();
}

- (NSImage *)addTabButtonRolloverImage {
	return _staticTabNew_RolloverImage();
}

#pragma mark -
#pragma mark Drag Support

- (NSRect)draggingRectForTabButton:(MMAttachedTabBarButton *)aButton ofTabBarView:(MMTabBarView *)tabBarView {

	NSRect dragRect = [aButton stackingFrame];
	dragRect.size.width++;

	if([aButton state] == NSOnState) {
		if([tabBarView orientation] == MMTabBarHorizontalOrientation) {
			dragRect.size.height -= 2.0;
		} else {
			dragRect.size.height += 1.0;
			dragRect.origin.y -= 1.0;
			dragRect.origin.x += 2.0;
			dragRect.size.width -= 3.0;
		}
	} else if ([tabBarView orientation] == MMTabBarVerticalOrientation) {
		dragRect.origin.x--;
	}

	return dragRect;
}

#pragma mark -
#pragma mark Providing Images

- (NSImage *)closeButtonImageOfType:(MMCloseButtonImageType)type forTabCell:(MMTabBarButtonCell *)cell
{
    switch (type) {
        case MMCloseButtonImageTypeStandard:
            return _staticTabClose_FrontImage();
        case MMCloseButtonImageTypeRollover:
            return _staticTabClose_Front_RolloverImage();
        case MMCloseButtonImageTypePressed:
            return _staticTabClose_Front_PressedImage();
            
        case MMCloseButtonImageTypeDirty:
            return _staticTabClose_DirtyImage();
        case MMCloseButtonImageTypeDirtyRollover:
            return _staticTabClose_Dirty_RolloverImage();
        case MMCloseButtonImageTypeDirtyPressed:
            return _staticTabClose_Dirty_PressedImage();
            
        default:
            break;
    }
}

#pragma mark -
#pragma mark Determining Cell Size

- (NSRect)drawingRectForBounds:(NSRect)theRect ofTabCell:(MMTabBarButtonCell *)cell
{
    return NSInsetRect(theRect, 10.0, 0.0);
}

#pragma mark -
#pragma mark Drawing

- (void)_drawBackgroundAndSeparatorsOfTabCell:(MMTabBarButtonCell *)cell withFrame:(NSRect)frame inView:(NSView *)controlView activeAppearance:(BOOL)active {
/*
    MMTabBarView *tabBarView = [controlView enclosingTabBarView];
    NSUInteger selIndex = [tabBarView indexOfTabViewItem:[tabBarView selectedTabViewItem]];
    MMTabBarButton *button = [cell controlView];
    MMAttachedTabBarButton *selectedButton = [tabBarView selectedAttachedButton];

	[NSGraphicsContext saveGraphicsState];

    if (selectedButton == button) {
        frame.size.width += 5.0;
        frame.origin.x -= 5.0;
    }
    
    NSBezierPath *clippingPath = [NSBezierPath bezierPathWithRect:frame];
    [clippingPath setClip];
    
    NSImage *left = nil;
    NSImage *center = nil;
    NSImage *right = nil;

    if ([tabBarView isWindowActive]) {
        if ([cell state] == NSOnState) {
            left = _staticSafariAWATLeftCapImage();
            center = _staticSafariAWATFillImage();
            right = _staticSafariAWATRightCapImage();
        } else {
        
           // center = _staticSafariAWATFillImage();
        }
    } else {
    
        if ([cell state] == NSOnState) {
            left = _staticSafariIWATLeftCapImage();
            center = _staticSafariIWATFillImage();
            right = _staticSafariIWATRightCapImage();
        } else {
            //center = _staticSafariIWATFillImage();
        }
    }

    if (center != nil || left != nil || right != nil)
        NSDrawThreePartImage(frame, left, center, right, NO, NSCompositeSourceOver, 1, [controlView isFlipped]);
    
	[NSGraphicsContext restoreGraphicsState];
*/    
}

-(void)drawBezelOfTabCell:(MMTabBarButtonCell *)cell withFrame:(NSRect)frame inView:(NSView *)controlView {

    if ([[cell controlView] frame].size.height < 2)
        return;
    
    MMTabBarView *tabBarView = [controlView enclosingTabBarView];
    
    [self _drawBackgroundAndSeparatorsOfTabCell:cell withFrame:frame inView:controlView activeAppearance:[tabBarView isWindowActive]];
/*
    MMTabBarView *tabBarView = [controlView enclosingTabBarView];
    
    NSRect cellFrame = frame;
    
    if ([[cell controlView] frame].size.height < 2)
        return;

    NSImage *left = nil;
    NSImage *center = nil;
    NSImage *right = nil;

    if ([tabBarView isWindowActive]) {
        if ([cell state] == NSOnState) {
            left = _staticSafariAWATLeftCapImage();
            center = _staticSafariAWATFillImage();
            right = _staticSafariAWATRightCapImage();
        } else {
        
           // center = _staticSafariAWATFillImage();
        }
    } else {
    
        if ([cell state] == NSOnState) {
            left = _staticSafariIWATLeftCapImage();
            center = _staticSafariIWATFillImage();
            right = _staticSafariIWATRightCapImage();
        } else {
            //center = _staticSafariIWATFillImage();
        }
    }

    if (center != nil || left != nil || right != nil)
        NSDrawThreePartImage(cellFrame, left, center, right, NO, NSCompositeSourceOver, 1, [controlView isFlipped]);
*/    
}

- (void)_drawSelectedBezelForButton:(MMAttachedTabBarButton *)button inTabBarView:(MMTabBarView *)tabBarView atIndex:(NSUInteger)index inRect:(NSRect)rect {

    NSImage *left = nil;
    NSImage *center = nil;
    NSImage *right = nil;

    NSRect buttonFrame = [button frame];
    buttonFrame.origin.x -= 5.0f;
    buttonFrame.size.width += 5.0f;
    buttonFrame.size.width += 5.0f;
    
    if ([tabBarView isWindowActive]) {
        left = _staticSafariAWATLeftCapImage();
        center = _staticSafariAWATFillImage();
        right = _staticSafariAWATRightCapImage();
    } else {
        left = _staticSafariIWATLeftCapImage();
        center = _staticSafariIWATFillImage();
        right = _staticSafariIWATRightCapImage();
    }

    if (center != nil || left != nil || right != nil)
        NSDrawThreePartImage(buttonFrame, left, center, right, NO, NSCompositeSourceOver, 1.0, [tabBarView isFlipped]);
}

-(NSRect)_separatorFrameForLeftButton:(MMTabBarButton *)leftButton rightButton:(MMTabBarButton *)rightButton forTabBarView:(MMTabBarView *)tabBarView {

    NSRect bounds = [tabBarView bounds];
    
    if (!leftButton || !rightButton) {
        return NSZeroRect;
    }
    
    return NSMakeRect(NSMaxX([leftButton frame])-5, 0, 11, bounds.size.height);
}

- (void)_drawSeparatorOfTabBarView:(MMTabBarView *)tabBarView atIndex:(NSUInteger)index withLeftButton:(MMTabBarButton *)leftButton rightButton:(MMTabBarButton *)rightButton inRect:(NSRect)rect {

    NSRect frame = [self _separatorFrameForLeftButton:leftButton rightButton:rightButton forTabBarView:tabBarView];
    
    if (NSEqualRects(NSZeroRect, frame))
        return;
    
    NSUInteger selIndex = [tabBarView indexOfTabViewItem:[tabBarView selectedTabViewItem]];
    
    if ([tabBarView isWindowActive]) {
        if ([leftButton state] == NSOnState) {
//            [_staticSafariAWATRightCapImage() drawInRect:frame fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:YES hints:nil];
        } else if ([rightButton state] == NSOnState) {
  //          [_staticSafariAWATLeftCapImage() drawInRect:frame fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:YES hints:nil];
        } else if (index < selIndex) {
            [_staticSafariAWITRightCapImage() drawInRect:frame fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:YES hints:nil];
        } else if (index > selIndex) {
            [_staticSafariAWITLeftCapImage() drawInRect:frame fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:YES hints:nil];
        }
    } else {
        if ([leftButton state] == NSOnState) {
//            [_staticSafariIWATRightCapImage() drawInRect:frame fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:YES hints:nil];
        } else if ([rightButton state] == NSOnState) {
//            [_staticSafariIWATLeftCapImage() drawInRect:frame fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:YES hints:nil];
        } else if (index < selIndex) {
            [_staticSafariIWITRightCapImage() drawInRect:frame fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:YES hints:nil];
        } else if (index > selIndex) {
            [_staticSafariIWITLeftCapImage() drawInRect:frame fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:YES hints:nil];
        }
    }
}

- (void)_drawTabBezelsOfTabBarView:(MMTabBarView *)tabBarView inRect:(NSRect)rect {

    NSArray *buttons = [tabBarView orderedAttachedButtons];

    NSUInteger selIndex = [tabBarView indexOfTabViewItem:[tabBarView selectedTabViewItem]];
    MMAttachedTabBarButton *selButton = [tabBarView selectedAttachedButton];
    
        // draw separators
    MMAttachedTabBarButton *lastButton = nil;
    NSUInteger i = 0;
    for (MMAttachedTabBarButton *aButton in buttons) {
        
        [self _drawSeparatorOfTabBarView:tabBarView atIndex:i withLeftButton:lastButton rightButton:aButton inRect:rect];
        
        lastButton = aButton;
        i++;
    }
    
    [self _drawSeparatorOfTabBarView:tabBarView atIndex:i withLeftButton:lastButton rightButton:nil inRect:rect];
    
    if (selIndex != NSNotFound) {
        [self _drawSelectedBezelForButton:selButton inTabBarView:tabBarView atIndex:selIndex inRect:rect];
    }
    
/*
    for (MMAttachedTabBarButton *aButton in buttons) {

        NSImage *left = nil;
        NSImage *center = nil;
        NSImage *right = nil;
        
        if (i == selIndex) {
            [self _drawSelectedBezelForButton:aButton inTabBarView:tabBarView atIndex:i inRect:rect];
        } else if (i < selIndex) {
            [self _drawLeftBezelForButton:aButton inTabBarView:tabBarView atIndex:i inRect:rect];
        } else if (i > selIndex) {
            [self _drawRightBezelForButton:aButton inTabBarView:tabBarView atIndex:i inRect:rect];
        }
        

        if (center != nil || left != nil || right != nil)
            NSDrawThreePartImage(buttonFrame, left, center, right, NO, NSCompositeSourceOver, 1.0, [tabBarView isFlipped]);
        
    i++;
    }
*/
}

- (void)drawBezelOfTabBarView:(MMTabBarView *)tabBarView inRect:(NSRect)rect {

	rect = [tabBarView bounds];
	    
	[NSGraphicsContext saveGraphicsState];

    // special case of hidden control; need line across top of cell
    if (rect.size.height < 2) {
        [[NSColor darkGrayColor] set];
        NSRectFillUsingOperation(rect, NSCompositeSourceOver);
    } else {
        NSImage *bg = [tabBarView isWindowActive] ? _staticSafariAWBGImage() : _staticSafariIWBGImage();
        NSDrawThreePartImage(rect, nil, bg, nil, NO, NSCompositeCopy, 1, [tabBarView isFlipped]);
        
        [self _drawTabBezelsOfTabBarView:tabBarView inRect:rect];        
    }
    
	[NSGraphicsContext restoreGraphicsState];
}
/*
- (void)drawLeftMarginOfTabBarView:(MMTabBarView *)tabBarView inRect:(NSRect)rect {

    NSRect bounds = [tabBarView bounds];
    CGFloat leftMargin = [tabBarView leftMargin];
    
    NSRect marginRect = bounds;
    marginRect.size.width = leftMargin;

    NSUInteger selIndex = [tabBarView indexOfTabViewItem:[tabBarView selectedTabViewItem]];
    
    if ([tabBarView isWindowActive]) {
        if (selIndex == 0) {
            [_staticSafariAWATLeftCapImage() drawInRect:marginRect fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:YES hints:nil];
        } else {
            // draw nothing
        }
    } else {
        if (selIndex == 0) {
            [_staticSafariIWATLeftCapImage() drawInRect:marginRect fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:YES hints:nil];
        } else {
        }    
    }
    
//    [[NSColor redColor] set];
//    NSRectFill(marginRect);
}

- (void)drawRightMarginOfTabBarView:(MMTabBarView *)tabBarView inRect:(NSRect)rect {

    NSRect bounds = [tabBarView bounds];
    CGFloat rightMargin = [tabBarView rightMargin];
    
    NSRect marginRect = bounds;
    marginRect.origin.x = NSMaxX(marginRect)-rightMargin;
    marginRect.size.width = rightMargin;
    
    [[NSColor redColor] set];
    NSRectFill(marginRect);
}
*/
/*
-(NSRect)_separatorFrameForLeftButton:(MMTabBarButton *)leftButton rightButton:(MMTabBarButton *)rightButton forTabBarView:(MMTabBarView *)tabBarView {

    NSRect bounds = [tabBarView bounds];

    return NSMakeRect(NSMaxX([leftButton frame]), 0, NSMinX([rightButton frame])-NSMaxX([leftButton frame]), bounds.size.height);
}

- (void)drawSeparatorOfTabBarView:(MMTabBarView *)tabBarView atIndex:(NSUInteger)index withLeftButton:(MMTabBarButton *)leftButton rightButton:(MMTabBarButton *)rightButton inRect:(NSRect)rect {

    NSRect frame = [self _separatorFrameForLeftButton:leftButton rightButton:rightButton forTabBarView:tabBarView];
    
    NSUInteger selIndex = [tabBarView indexOfTabViewItem:[tabBarView selectedTabViewItem]];
    
    if ([tabBarView isWindowActive]) {
        if ([leftButton state] == NSOnState) {
            [_staticSafariAWATRightCapImage() drawInRect:frame fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:YES hints:nil];
        } else if ([rightButton state] == NSOnState) {
            [_staticSafariAWATLeftCapImage() drawInRect:frame fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:YES hints:nil];
        } else if (index < selIndex) {
            [_staticSafariAWITRightCapImage() drawInRect:frame fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:YES hints:nil];
        } else if (index > selIndex) {
            [_staticSafariAWITLeftCapImage() drawInRect:frame fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:YES hints:nil];
        }
    } else {
        if ([leftButton state] == NSOnState) {
            [_staticSafariIWATRightCapImage() drawInRect:frame fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:YES hints:nil];
        } else if ([rightButton state] == NSOnState) {
            [_staticSafariIWATLeftCapImage() drawInRect:frame fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:YES hints:nil];
        } else if (index < selIndex) {
            [_staticSafariIWITRightCapImage() drawInRect:frame fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:YES hints:nil];
        } else if (index > selIndex) {
            [_staticSafariIWITLeftCapImage() drawInRect:frame fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:YES hints:nil];
        }
    }
}
*/
@end
