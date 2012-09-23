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

@implementation MMSafariTabStyle

StaticImage(TabClose_Front)
StaticImage(TabClose_Front_Pressed)
StaticImage(TabClose_Front_Rollover)
StaticImage(TabClose_Dirty)
StaticImage(TabClose_Dirty_Pressed)
StaticImage(TabClose_Dirty_Rollover)
StaticImage(SafariAWAddTabButton)
StaticImage(SafariAWAddTabButtonPushed)
StaticImage(SafariAWAddTabButtonRolloverPlus)
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

- (CGFloat)leftMarginForTabBarView:(MMTabBarView *)tabBarView {
	return 6.0f;
}

- (CGFloat)rightMarginForTabBarView:(MMTabBarView *)tabBarView {
	return 6.0f;
}

- (BOOL)supportsOrientation:(MMTabBarOrientation)orientation forTabBarView:(MMTabBarView *)tabBarView {

    if (orientation != MMTabBarHorizontalOrientation)
        return NO;
    
    return YES;
}

#pragma mark -
#pragma mark Add Tab Button

-(void)updateAddButton:(MMRolloverButton *)aButton ofTabBarView:(MMTabBarView *)tabBarView {

    [aButton setImage:_staticSafariAWAddTabButtonImage()];
    [aButton setAlternateImage:_staticSafariAWAddTabButtonPushedImage()];
    [aButton setRolloverImage:_staticSafariAWAddTabButtonRolloverPlusImage()];
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
        
        [self _drawButtonBezelsOfTabBarView:tabBarView inRect:rect];
    }
    
	[NSGraphicsContext restoreGraphicsState];
}

-(void)drawBezelOfTabCell:(MMTabBarButtonCell *)cell withFrame:(NSRect)frame inView:(NSView *)controlView {

    if ([[cell controlView] frame].size.height < 2)
        return;
    
    MMTabBarView *tabBarView = [controlView enclosingTabBarView];
        
    NSRect cellFrame = frame;
    
    cellFrame = NSInsetRect(cellFrame, -5.0, 0);
    
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
        }
    } else {
    
        if ([cell state] == NSOnState) {
            left = _staticSafariIWATLeftCapImage();
            center = _staticSafariIWATFillImage();
            right = _staticSafariIWATRightCapImage();
        }
    }

    if (center != nil || left != nil || right != nil)
        NSDrawThreePartImage(cellFrame, left, center, right, NO, NSCompositeSourceOver, 1, [controlView isFlipped]);    
}

#pragma mark -
#pragma Private Methods

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

- (void)_drawBezelOfButton:(MMAttachedTabBarButton *)button atIndex:(NSUInteger)index inButtons:(NSArray *)sortedButtons indexOfSelectedButton:(NSUInteger)selIndex tabBarView:(MMTabBarView *)tabBarView inRect:(NSRect)rect {

    BOOL isWindowActive = [tabBarView isWindowActive];
    NSUInteger numberOfButtons = [sortedButtons count];

    MMAttachedTabBarButton *prevButton = nil,
                           *nextButton = nil;
    
    if (index > 0)
        prevButton = [sortedButtons objectAtIndex:index-1];
    if (index+1 < numberOfButtons)
        nextButton = [sortedButtons objectAtIndex:index+1];

    NSImage *left = nil,
            *right = nil;
    NSRect buttonFrame = [button frame];
    
    if ([button state] == NSOnState) {
    
        [self _drawSelectedBezelForButton:button inTabBarView:tabBarView atIndex:index inRect:rect];
        return;
    
    }

    buttonFrame = NSInsetRect(buttonFrame,-5.0,0);
    
        // standard drawing while animated slide is going on
    if ([button animatedSlide] == YES) {
        
        left = _staticSafariAWITLeftCapImage();
        right = _staticSafariAWITRightCapImage();
        
        NSDrawThreePartImage(buttonFrame, left, nil, right, NO, NSCompositeSourceOver, 1.0, [tabBarView isFlipped]);
        
        return;
        }
    
        // draw first button
    if (prevButton == nil) {
    
        if (selIndex == NSNotFound || index < selIndex) {
            if (([nextButton state] == NSOnState && [tabBarView isSliding]) ||
                [nextButton animatedSlide])
                right = isWindowActive?_staticSafariAWITRightCapImage():_staticSafariIWITRightCapImage();
        }
        // draw last button
    } else if (nextButton == nil) {

        if (selIndex == NSNotFound || index > selIndex) {
            if (selIndex == NSNotFound || ([prevButton state] == NSOnState && [tabBarView isSliding]) || [prevButton animatedSlide])
                left = isWindowActive?_staticSafariAWITLeftCapImage():_staticSafariIWITLeftCapImage();
        }
        
        if ([tabBarView showAddTabButton])
            right = isWindowActive?_staticSafariAWITRightCapImage():_staticSafariIWITRightCapImage();
    
        // draw mid button
    } else {
    
        if (selIndex == NSNotFound || index < selIndex) {
            left = isWindowActive?_staticSafariAWITLeftCapImage():_staticSafariIWITLeftCapImage();
            if (([nextButton state] == NSOnState && [tabBarView isSliding]) || [nextButton animatedSlide])
                right = isWindowActive?_staticSafariAWITRightCapImage():_staticSafariIWITRightCapImage();
        } else if (index > selIndex) {
            if (([prevButton state] == NSOnState && [tabBarView isSliding]) || [prevButton animatedSlide])
                left = isWindowActive?_staticSafariAWITLeftCapImage():_staticSafariIWITLeftCapImage();
            right = isWindowActive?_staticSafariAWITRightCapImage():_staticSafariIWITRightCapImage();
        }
    }

    NSDrawThreePartImage(buttonFrame, left, nil, right, NO, NSCompositeSourceOver, 1.0, [tabBarView isFlipped]);
}

- (void)_drawButtonBezelsOfTabBarView:(MMTabBarView *)tabBarView inRect:(NSRect)rect {

    NSArray *sortedButtons = [tabBarView sortedAttachedButtonsUsingComparator:
        ^NSComparisonResult(MMAttachedTabBarButton *but1, MMAttachedTabBarButton *but2) {
        
            NSRect stackingFrame1 = [but1 stackingFrame];
            NSRect stackingFrame2 = [but2 stackingFrame];
                        
            if ([tabBarView orientation] == MMTabBarHorizontalOrientation) {
                
                if (stackingFrame1.origin.x > stackingFrame2.origin.x)
                    return NSOrderedDescending;
                else if (stackingFrame1.origin.x < stackingFrame2.origin.x)
                    return NSOrderedAscending;
                else
                    return NSOrderedSame;
            } else {
                if (stackingFrame1.origin.y > stackingFrame2.origin.y)
                    return NSOrderedDescending;
                else if (stackingFrame1.origin.y < stackingFrame2.origin.y)
                    return NSOrderedAscending;
                else
                    return NSOrderedSame;
            }
        }];
        
        // find selected button
    NSUInteger selIndex = NSNotFound;
    NSUInteger i = 0;
    for (MMAttachedTabBarButton *aButton in sortedButtons) {
        if ([aButton state] == NSOnState) {
            selIndex = i;
            break;
        }
        
        i++;
    }
    
        // draw a bezel for each button
    i = 0;
    for (MMAttachedTabBarButton *aButton in sortedButtons) {
        
        [self _drawBezelOfButton:aButton atIndex:i inButtons:sortedButtons indexOfSelectedButton:selIndex tabBarView:tabBarView inRect:rect];
        
        i++;
    }
}

@end
