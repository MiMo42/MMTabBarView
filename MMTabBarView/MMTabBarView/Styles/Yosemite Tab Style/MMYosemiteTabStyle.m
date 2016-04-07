//
//  MMYosemiteTabStyle.m
//  --------------------
//
//  Based on MMUnifiedTabStyle.m by Keith Blount
//  Created by Ajin Man Tuladhar on 04/11/2014.
//  Copyright 2014 Ajin Man Tuladhar. All rights reserved.
//

#import "MMYosemiteTabStyle.h"
#import "MMAttachedTabBarButton.h"
#import "MMTabBarView.h"
#import "NSView+MMTabBarViewExtensions.h"
#import "NSBezierPath+MMTabBarViewExtensions.h"

@implementation MMYosemiteTabStyle

StaticImage(YosemiteTabClose_Front)
StaticImage(YosemiteTabClose_Front_Pressed)
StaticImage(YosemiteTabClose_Front_Rollover)
StaticImageWithFilename(YosemiteTabCloseDirty_Front, AquaTabCloseDirty_Front)
StaticImageWithFilename(YosemiteTabCloseDirty_Front_Pressed, AquaTabCloseDirty_Front_Pressed)
StaticImageWithFilename(YosemiteTabCloseDirty_Front_Rollover, AquaTabCloseDirty_Front_Rollover)
StaticImage(YosemiteTabNew)
StaticImage(YosemiteTabNewPressed)

+ (NSString *)name {
    return @"Yosemite";
}

- (NSString *)name {
	return [[self class] name];
}

#pragma mark -
#pragma mark Creation/Destruction

- (id) init {
	if ((self = [super init])) {
		_leftMarginForTabBarView = -1.0f;
	}
    
	return self;
}

#pragma mark -
#pragma mark Tab View Specific

- (NSSize)intrinsicContentSizeOfTabBarView:(MMTabBarView *)tabBarView
{
    return NSMakeSize(NSViewNoInstrinsicMetric, 25);
}

- (CGFloat)leftMarginForTabBarView:(MMTabBarView *)tabBarView {
    if ([tabBarView orientation] == MMTabBarHorizontalOrientation)
        return -1.0f;
    else
        return 0.0f;
}

- (CGFloat)rightMarginForTabBarView:(MMTabBarView *)tabBarView {
    if ([tabBarView orientation] == MMTabBarHorizontalOrientation)
        return -1.0f;
    else
        return 0.0f;
}

- (CGFloat)topMarginForTabBarView:(MMTabBarView *)tabBarView {
    if ([tabBarView orientation] == MMTabBarHorizontalOrientation)
        return 0.0f;

    return 0.0f;
}

- (CGFloat)heightOfTabBarButtonsForTabBarView:(MMTabBarView *)tabBarView {
    return 25;
}


- (NSRect)addTabButtonRectForTabBarView:(MMTabBarView *)tabBarView {
    NSRect window = [tabBarView frame];
    NSSize buttonSize = [tabBarView addTabButtonSize];
    NSRect rect = NSMakeRect(NSMaxX(window) - buttonSize.width - 5, 1, buttonSize.width, buttonSize.height);
    return rect;
}

- (NSSize)addTabButtonSizeForTabBarView:(MMTabBarView *)tabBarView {
    return NSMakeSize(18,[tabBarView frame].size.height);
}

- (BOOL)supportsOrientation:(MMTabBarOrientation)orientation forTabBarView:(MMTabBarView *)tabBarView {

    if (orientation != MMTabBarHorizontalOrientation)
        return NO;
    
    return YES;
}

#pragma mark -
#pragma mark Drag Support

- (NSRect)draggingRectForTabButton:(MMAttachedTabBarButton *)aButton ofTabBarView:(MMTabBarView *)tabBarView {

	NSRect dragRect = [aButton stackingFrame];
	dragRect.size.width++;
	return dragRect;
    
}

#pragma mark -
#pragma mark Add Tab Button

- (void)updateAddButton:(MMRolloverButton *)aButton ofTabBarView:(MMTabBarView *)tabBarView {
    
    [aButton setImage:_staticYosemiteTabNewImage()];
    [aButton setAlternateImage:_staticYosemiteTabNewPressedImage()];
    [aButton setRolloverImage:_staticYosemiteTabNewImage()];
}

#pragma mark -
#pragma mark Providing Images

- (NSImage *)closeButtonImageOfType:(MMCloseButtonImageType)type forTabCell:(MMTabBarButtonCell *)cell
{
    switch (type) {
        case MMCloseButtonImageTypeStandard:
            return _staticYosemiteTabClose_FrontImage();
        case MMCloseButtonImageTypeRollover:
            return _staticYosemiteTabClose_Front_RolloverImage();
        case MMCloseButtonImageTypePressed:
            return _staticYosemiteTabClose_Front_PressedImage();
            
        case MMCloseButtonImageTypeDirty:
            return _staticYosemiteTabCloseDirty_FrontImage();
        case MMCloseButtonImageTypeDirtyRollover:
            return _staticYosemiteTabCloseDirty_Front_RolloverImage();
        case MMCloseButtonImageTypeDirtyPressed:
            return _staticYosemiteTabCloseDirty_Front_PressedImage();
            
        default:
            break;
    }
    
}

#pragma mark -
#pragma mark Drawing

- (void)drawBezelOfTabBarView:(MMTabBarView *)tabBarView inRect:(NSRect)rect {
	//Draw for our whole bounds; it'll be automatically clipped to fit the appropriate drawing area
	rect = [tabBarView bounds];
    tabBarView.resizeTabsToFitTotalWidth= YES;

	NSRect gradientRect = rect;

	if (![tabBarView isWindowActive]) {
		[[NSColor windowBackgroundColor] set];
	} else {
        NSColor *startColor = [NSColor colorWithDeviceWhite:0.8 alpha:1.000];
        NSGradient *gradient = [[NSGradient alloc] initWithStartingColor:startColor endingColor:startColor];
        [gradient drawInRect:gradientRect angle:90.0];
    }

    [[NSColor colorWithCalibratedRed:0.642 green:0.633 blue:0.642 alpha:1.000] set];
    [NSBezierPath strokeLineFromPoint:NSMakePoint(NSMinX(rect), NSMinY(rect) + 0.5)
                              toPoint:NSMakePoint(NSMaxX(rect), NSMinY(rect) + 0.5)];
    
    [NSBezierPath strokeLineFromPoint:NSMakePoint(NSMinX(rect), NSMaxY(rect) - 0.5)
                              toPoint:NSMakePoint(NSMaxX(rect), NSMaxY(rect) - 0.5)];
}


-(void)drawBezelOfTabCell:(MMTabBarButtonCell *)cell withFrame:(NSRect)frame inView:(NSView *)controlView
{
    MMTabBarView *tabBarView = [controlView enclosingTabBarView];
    MMAttachedTabBarButton *button = (MMAttachedTabBarButton *)controlView;
    
    BOOL overflowMode = [button isOverflowButton];
    if ([button isSliding])
        overflowMode = NO;
    
    NSRect aRect = NSZeroRect;
    if (overflowMode) {
        aRect = NSMakeRect(frame.origin.x, frame.origin.y, frame.size.width +1, frame.size.height);
    } else {
        aRect = NSMakeRect(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
    }
    
    aRect.origin.y += 1;
    aRect.size.height -= 2;
    
    if (overflowMode) {
        [self _drawCardBezelInRect:aRect withCapMask:MMBezierShapeLeftCap|MMBezierShapeFlippedVertically usingStatesOfAttachedButton:button ofTabBarView:tabBarView];
    } else {
        [self _drawCardBezelInRect:aRect withCapMask:MMBezierShapeAllCaps|MMBezierShapeFlippedVertically usingStatesOfAttachedButton:button ofTabBarView:tabBarView];
    }
}

-(void)drawBezelOfOverflowButton:(MMOverflowPopUpButton *)overflowButton ofTabBarView:(MMTabBarView *)tabBarView inRect:(NSRect)rect {

    MMAttachedTabBarButton *lastAttachedButton = [tabBarView lastAttachedButton];
    if ([lastAttachedButton isSliding])
        return;
    
    NSWindow *window = [tabBarView window];
    NSToolbar *toolbar = [window toolbar];
    
    NSRect frame = [overflowButton frame];
    
    if (toolbar && [toolbar isVisible]) {
        
        NSRect aRect = NSMakeRect(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
        aRect.size.width += 5.0;
        aRect.origin.y += 1;
        aRect.size.height -= 2;
        
        [self _drawCardBezelInRect:aRect withCapMask:MMBezierShapeRightCap|MMBezierShapeFlippedVertically usingStatesOfAttachedButton:lastAttachedButton ofTabBarView:tabBarView];
        
    } else {
        NSRect aRect = NSMakeRect(frame.origin.x, frame.origin.y+0.5, frame.size.width-0.5f, frame.size.height-1.0);
        aRect.size.width += 5.0;
        
        [self _drawBoxBezelInRect:aRect withCapMask:MMBezierShapeRightCap|MMBezierShapeFlippedVertically usingStatesOfAttachedButton:lastAttachedButton ofTabBarView:tabBarView];
        
        if ([tabBarView showAddTabButton]) {
            
            NSColor *lineColor = [NSColor colorWithCalibratedWhite:0.576 alpha:1.0];
            [lineColor set];
            [NSBezierPath strokeLineFromPoint:NSMakePoint(NSMaxX(aRect)+.5, NSMinY(aRect)) toPoint:NSMakePoint(NSMaxX(aRect)+0.5, NSMaxY(aRect))];
            
            [[[NSColor whiteColor] colorWithAlphaComponent:0.5] set];
            [NSBezierPath strokeLineFromPoint:NSMakePoint(NSMaxX(aRect)+1.5f, NSMinY(aRect)+1.0) toPoint:NSMakePoint(NSMaxX(aRect)+1.5f, NSMaxY(aRect)-1.0)];
        }        
    }
}

#pragma mark -
#pragma mark Private Methods

- (void)_drawCardBezelInRect:(NSRect)aRect withCapMask:(MMBezierShapeCapMask)capMask usingStatesOfAttachedButton:(MMAttachedTabBarButton *)button ofTabBarView:(MMTabBarView *)tabBarView {

    NSColor *lineColor = [NSColor colorWithCalibratedWhite:0.576 alpha:1.0];
    CGFloat radius = 0.0f;
        
    NSBezierPath *fillPath = [NSBezierPath bezierPathWithCardInRect:aRect radius:radius capMask:capMask|MMBezierShapeFillPath];

    if ([tabBarView isWindowActive]) {
        if ([button state] == NSOnState) {
            NSColor *startColor = [NSColor colorWithDeviceWhite:0.875 alpha:1.000];
            NSColor *endColor = [NSColor colorWithDeviceWhite:0.902 alpha:1.000];
            NSGradient *gradient = [[NSGradient alloc] initWithStartingColor:startColor endingColor:endColor];
            [[NSGraphicsContext currentContext] setShouldAntialias:NO];
            [gradient drawInBezierPath:fillPath angle:90.0];
            [[NSGraphicsContext currentContext] setShouldAntialias:YES];
        } else {
            NSColor *startColor = [NSColor colorWithDeviceWhite:0.8 alpha:1.000];
            NSGradient *gradient = [[NSGradient alloc] initWithStartingColor:startColor endingColor:startColor];
            [gradient drawInBezierPath:fillPath angle:80.0];
        }
    } else {
        
        if ([button state] == NSOnState) {
            NSColor *startColor = [NSColor colorWithDeviceWhite:0.875 alpha:1.000];
            NSColor *endColor = [NSColor colorWithDeviceWhite:0.902 alpha:1.000];
            NSGradient *gradient = [[NSGradient alloc] initWithStartingColor:startColor endingColor:endColor];
            [[NSGraphicsContext currentContext] setShouldAntialias:NO];
            [gradient drawInBezierPath:fillPath angle:90.0];
            [[NSGraphicsContext currentContext] setShouldAntialias:YES];
        }
    }        
    
    NSBezierPath *bezier = [NSBezierPath bezierPath];
    [lineColor set];
    
    BOOL shouldDisplayLeftDivider = [button shouldDisplayLeftDivider];
    if (shouldDisplayLeftDivider) {
        //draw the tab divider
        [bezier moveToPoint:NSMakePoint(NSMinX(aRect), NSMinY(aRect))];
        [bezier lineToPoint:NSMakePoint(NSMinX(aRect), NSMaxY(aRect))];
    }
    
    [bezier moveToPoint:NSMakePoint(NSMaxX(aRect), NSMinY(aRect))];
    [bezier lineToPoint:NSMakePoint(NSMaxX(aRect), NSMaxY(aRect))];
    [bezier stroke];
}

- (void)_drawBoxBezelInRect:(NSRect)aRect withCapMask:(MMBezierShapeCapMask)capMask usingStatesOfAttachedButton:(MMAttachedTabBarButton *)button ofTabBarView:(MMTabBarView *)tabBarView {

    capMask &= ~MMBezierShapeFillPath;
    
        // fill
    if ([button state] == NSOnState) {
        [[NSColor colorWithCalibratedWhite:0.0 alpha:0.2] set];
        NSRectFillUsingOperation(aRect, NSCompositeSourceAtop);            
    } else if ([button mouseHovered]) {
        [[NSColor colorWithCalibratedWhite:0.0 alpha:0.1] set];
        NSRectFillUsingOperation(aRect, NSCompositeSourceAtop);
    }
}

@end
