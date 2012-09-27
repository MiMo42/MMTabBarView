//
//  MMMetalTabStyle.m
//  MMTabBarView
//
//  Created by John Pannell on 2/17/06.
//  Copyright 2006 Positive Spin Media. All rights reserved.
//

#import "MMMetalTabStyle.h"
#import "MMAttachedTabBarButton.h"
#import "MMTabBarView.h"
#import "NSView+MMTabBarViewExtensions.h"
#import "NSBezierPath+MMTabBarViewExtensions.h"

@interface MMMetalTabStyle (/*Private*/)

- (BOOL)_shouldDrawHorizontalTopBorderLineInView:(id)controlView;

@end

@implementation MMMetalTabStyle

StaticImage(TabNewMetal)
StaticImage(TabNewMetalPressed)
StaticImage(TabNewMetalRollover)

+ (NSString *)name {
    return @"Metal";
}

- (NSString *)name {
	return [[self class] name];
}

#pragma mark -
#pragma mark Creation/Destruction

- (id) init {
	if ((self = [super init])) {
		metalCloseButton = [[NSImage alloc] initByReferencingFile:[[MMTabBarView bundle] pathForImageResource:@"TabClose_Front"]];
		metalCloseButtonDown = [[NSImage alloc] initByReferencingFile:[[MMTabBarView bundle] pathForImageResource:@"TabClose_Front_Pressed"]];
		metalCloseButtonOver = [[NSImage alloc] initByReferencingFile:[[MMTabBarView bundle] pathForImageResource:@"TabClose_Front_Rollover"]];

		metalCloseDirtyButton = [[NSImage alloc] initByReferencingFile:[[MMTabBarView bundle] pathForImageResource:@"TabClose_Dirty"]];
		metalCloseDirtyButtonDown = [[NSImage alloc] initByReferencingFile:[[MMTabBarView bundle] pathForImageResource:@"TabClose_Dirty_Pressed"]];
		metalCloseDirtyButtonOver = [[NSImage alloc] initByReferencingFile:[[MMTabBarView bundle] pathForImageResource:@"TabClose_Dirty_Rollover"]];

		_objectCountStringAttributes = [[NSDictionary alloc] initWithObjectsAndKeys:[[NSFontManager sharedFontManager] convertFont:[NSFont fontWithName:@"Helvetica" size:11.0] toHaveTrait:NSBoldFontMask], NSFontAttributeName,
										[[NSColor whiteColor] colorWithAlphaComponent:0.85], NSForegroundColorAttributeName,
										nil, nil];
	}
	return self;
}

- (void)dealloc {
	[metalCloseButton release];
	[metalCloseButtonDown release];
	[metalCloseButtonOver release];
	[metalCloseDirtyButton release];
	[metalCloseDirtyButtonDown release];
	[metalCloseDirtyButtonOver release];

	[_objectCountStringAttributes release];

	[super dealloc];
}

#pragma mark -
#pragma mark Tab View Specific

- (CGFloat)leftMarginForTabBarView:(MMTabBarView *)tabBarView {
    if ([tabBarView orientation] == MMTabBarHorizontalOrientation)
        return 10.0f;
    else
        return 0.0f;
}

- (CGFloat)rightMarginForTabBarView:(MMTabBarView *)tabBarView {
    if ([tabBarView orientation] == MMTabBarHorizontalOrientation)
        return 10.0f;
    else
        return 0.0f;
}

- (CGFloat)topMarginForTabBarView:(MMTabBarView *)tabBarView {
    if ([tabBarView orientation] == MMTabBarHorizontalOrientation)
        return 0.0f;
    else
        return 10.0f;
}

#pragma mark -
#pragma mark Add Tab Button

- (void)updateAddButton:(MMRolloverButton *)aButton ofTabBarView:(MMTabBarView *)tabBarView {

    [aButton setImage:_staticTabNewMetalImage()];
    [aButton setAlternateImage:_staticTabNewMetalPressedImage()];
    [aButton setRolloverImage:_staticTabNewMetalRolloverImage()];
}

#pragma mark -
#pragma mark Drag Support

- (NSRect)draggingRectForTabButton:(MMAttachedTabBarButton *)aButton ofTabBarView:(MMTabBarView *)tabBarView {

	NSRect dragRect = [aButton stackingFrame];
	dragRect.size.width++;

    MMTabBarOrientation orientation = [tabBarView orientation];

	if ([aButton state] == NSOnState) {
		if (orientation == MMTabBarHorizontalOrientation) {
			dragRect.size.height -= 2.0;
		} else {
			dragRect.size.height += 1.0;
			dragRect.origin.y -= 1.0;
			dragRect.origin.x += 2.0;
			dragRect.size.width -= 3.0;
		}
	} else if (orientation == MMTabBarVerticalOrientation) {
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
            return metalCloseButton;
        case MMCloseButtonImageTypeRollover:
            return metalCloseButtonOver;
        case MMCloseButtonImageTypePressed:
            return metalCloseButtonDown;
            
        case MMCloseButtonImageTypeDirty:
            return metalCloseDirtyButton;
        case MMCloseButtonImageTypeDirtyRollover:
            return metalCloseDirtyButtonOver;
        case MMCloseButtonImageTypeDirtyPressed:
            return metalCloseDirtyButtonDown;
            
        default:
            break;
    }
    
}

#pragma mark -
#pragma mark Cell Values

- (NSAttributedString *)attributedObjectCountStringValueForTabCell:(MMTabBarButtonCell *)cell {
	NSString *contents = [NSString stringWithFormat:@"%lu", (unsigned long)[cell objectCount]];
	return [[[NSMutableAttributedString alloc] initWithString:contents attributes:_objectCountStringAttributes] autorelease];
}

- (NSAttributedString *)attributedStringValueForTabCell:(MMTabBarButtonCell *)cell {
	NSMutableAttributedString *attrStr;
	NSString *contents = [cell title];
	attrStr = [[[NSMutableAttributedString alloc] initWithString:contents] autorelease];
	NSRange range = NSMakeRange(0, [contents length]);

	// Add font attribute
	[attrStr addAttribute:NSFontAttributeName value:[NSFont boldSystemFontOfSize:11.0] range:range];
	[attrStr addAttribute:NSForegroundColorAttributeName value:[[NSColor textColor] colorWithAlphaComponent:0.75] range:range];

	// Add shadow attribute
	NSShadow* shadow;
	shadow = [[[NSShadow alloc] init] autorelease];
	CGFloat shadowAlpha;
	if (([cell state] == NSOnState) || [cell mouseHovered]) {
		shadowAlpha = 0.8;
	} else {
		shadowAlpha = 0.5;
	}
	[shadow setShadowColor:[NSColor colorWithCalibratedWhite:1.0 alpha:shadowAlpha]];
	[shadow setShadowOffset:NSMakeSize(0, -1)];
	[shadow setShadowBlurRadius:1.0];
	[attrStr addAttribute:NSShadowAttributeName value:shadow range:range];

	// Paragraph Style for Truncating Long Text
	static NSMutableParagraphStyle *TruncatingTailParagraphStyle = nil;
	if (!TruncatingTailParagraphStyle) {
		TruncatingTailParagraphStyle = [[[NSParagraphStyle defaultParagraphStyle] mutableCopy] retain];
		[TruncatingTailParagraphStyle setLineBreakMode:NSLineBreakByTruncatingTail];
		[TruncatingTailParagraphStyle setAlignment:NSCenterTextAlignment];
	}
	[attrStr addAttribute:NSParagraphStyleAttributeName value:TruncatingTailParagraphStyle range:range];

	return attrStr;
}

#pragma mark -
#pragma mark Determining Cell Size

- (NSRect)drawingRectForBounds:(NSRect)theRect ofTabCell:(MMTabBarButtonCell *)cell
{
    NSRect resultRect;

    MMTabBarView *tabBarView = [cell tabBarView];

    if ([tabBarView orientation] == MMTabBarHorizontalOrientation && [cell state] == NSOnState) {
        resultRect = NSInsetRect(theRect,MARGIN_X,0.0);
        resultRect.origin.y += 1;
        resultRect.size.height -= MARGIN_Y + 2;
    } else {
        resultRect = NSInsetRect(theRect, MARGIN_X, MARGIN_Y);
        resultRect.size.height -= 1;
    }
    
    return resultRect;
}

#pragma mark -
#pragma mark Drawing

- (void)drawBezelOfTabBarView:(MMTabBarView *)tabBarView inRect:(NSRect)rect {

	//Draw for our whole bounds; it'll be automatically clipped to fit the appropriate drawing area
	rect = [tabBarView bounds];
    
    MMTabBarOrientation orientation = [tabBarView orientation];

	if (orientation == MMTabBarVerticalOrientation && [tabBarView frame].size.width < 2) {
		return;
	}

	[NSGraphicsContext saveGraphicsState];
	[[NSGraphicsContext currentContext] setShouldAntialias:NO];

	[[NSColor colorWithCalibratedWhite:0.0 alpha:0.2] set];
	NSRectFillUsingOperation(rect, NSCompositeSourceAtop);
	[[NSColor darkGrayColor] set];

	if (orientation == MMTabBarHorizontalOrientation) {
    
        if ([self _shouldDrawHorizontalTopBorderLineInView:tabBarView]) {
            [NSBezierPath strokeLineFromPoint:NSMakePoint(rect.origin.x, rect.origin.y + 0.5) toPoint:NSMakePoint(rect.origin.x + rect.size.width, rect.origin.y + 0.5)];
        }
        
		[NSBezierPath strokeLineFromPoint:NSMakePoint(rect.origin.x, rect.origin.y + rect.size.height - 0.5) toPoint:NSMakePoint(rect.origin.x + rect.size.width, rect.origin.y + rect.size.height - 0.5)];
	} else {
		[NSBezierPath strokeLineFromPoint:NSMakePoint(rect.origin.x, rect.origin.y + 0.5) toPoint:NSMakePoint(rect.origin.x, rect.origin.y + rect.size.height + 0.5)];
		[NSBezierPath strokeLineFromPoint:NSMakePoint(rect.origin.x + rect.size.width, rect.origin.y + 0.5) toPoint:NSMakePoint(rect.origin.x + rect.size.width, rect.origin.y + rect.size.height + 0.5)];
	}

	[NSGraphicsContext restoreGraphicsState];
}

- (void)drawBezelOfTabCell:(MMTabBarButtonCell *)cell withFrame:(NSRect)frame inView:(NSView *)controlView {

    MMTabBarView *tabBarView = [controlView enclosingTabBarView];
    MMAttachedTabBarButton *button = (MMAttachedTabBarButton *)controlView;
    MMTabBarOrientation orientation = [tabBarView orientation];

	NSBezierPath *bezier = nil; 
	NSColor *lineColor = [NSColor darkGrayColor];
    
	NSRect cellFrame = frame;
    
    BOOL overflowMode = [button isOverflowButton];
    if ([button isSliding])
        overflowMode = NO;
    
	//disable antialiasing of bezier paths
	[NSGraphicsContext saveGraphicsState];
	[[NSGraphicsContext currentContext] setShouldAntialias:NO];

	if ([cell state] == NSOnState) {
		// selected tab
		if (orientation == MMTabBarHorizontalOrientation) {
			NSRect aRect = NSMakeRect(cellFrame.origin.x+0.5, cellFrame.origin.y, cellFrame.size.width-1.0, cellFrame.size.height - 2.5);

            NSRect fillRect = NSInsetRect(aRect,0.5f,0.0f);
            fillRect.size.height -= 0.5;

            if (overflowMode) {
                fillRect.size.width += 0.5;
                bezier = [NSBezierPath bezierPathWithCardInRect:fillRect radius:3.0 capMask:MMBezierShapeLeftCap|MMBezierShapeFillPath|MMBezierShapeFlippedVertically];            
            } else {
                bezier = [NSBezierPath bezierPathWithCardInRect:fillRect radius:3.0 capMask:MMBezierShapeAllCaps|MMBezierShapeFillPath|MMBezierShapeFlippedVertically];
            }
            
            [bezier setLineWidth:1.0];
            
            [[NSColor windowBackgroundColor] set];
            [bezier fill];

			[lineColor set];
            
            if (overflowMode) {
                bezier = [NSBezierPath bezierPathWithCardInRect:aRect radius:3.0 capMask:MMBezierShapeLeftCap|MMBezierShapeFlippedVertically];
            } else {
                bezier = [NSBezierPath bezierPathWithCardInRect:aRect radius:3.0 capMask:MMBezierShapeAllCaps|MMBezierShapeFlippedVertically];            
            }
            
            [bezier setLineWidth:1.0];
            
		} else {
			NSRect aRect = NSMakeRect(cellFrame.origin.x + 2, cellFrame.origin.y, cellFrame.size.width - 2, cellFrame.size.height);

			// background
			aRect.origin.x++;
			aRect.size.height--;
            
            [[NSColor windowBackgroundColor] set];
            NSRectFill(aRect);
            
			aRect.origin.x--;
			aRect.size.height++;

			// frame
			[lineColor set];
            bezier = [NSBezierPath bezierPath];
			[bezier setLineWidth:1.0];
			[bezier moveToPoint:NSMakePoint(aRect.origin.x + aRect.size.width, aRect.origin.y)];
			[bezier lineToPoint:NSMakePoint(aRect.origin.x + 2, aRect.origin.y)];
			[bezier lineToPoint:NSMakePoint(aRect.origin.x + 0.5, aRect.origin.y + 2)];
			[bezier lineToPoint:NSMakePoint(aRect.origin.x + 0.5, aRect.origin.y + aRect.size.height - 3)];
			[bezier lineToPoint:NSMakePoint(aRect.origin.x + 3, aRect.origin.y + aRect.size.height)];
			[bezier lineToPoint:NSMakePoint(aRect.origin.x + aRect.size.width, aRect.origin.y + aRect.size.height)];
		}

        [bezier stroke];
        
	} else {
		// unselected tab
		NSRect aRect = NSMakeRect(cellFrame.origin.x+0.5f, cellFrame.origin.y+0.5, cellFrame.size.width-1.0f, cellFrame.size.height-1.0f);
/*
		aRect.origin.y += 0.5;
		aRect.origin.x += 1.5;
		aRect.size.width -= 1;
*/
		// rollover
		if ([cell mouseHovered]) {
			[[NSColor colorWithCalibratedWhite:0.0 alpha:0.1] set];
			NSRectFillUsingOperation(aRect, NSCompositeSourceAtop);
		}

		[lineColor set];

        bezier = [NSBezierPath bezierPath];

		if (orientation == MMTabBarHorizontalOrientation) {
//			aRect.origin.x -= 1;
//			aRect.size.width += 1;

			// frame
            if ([self _shouldDrawHorizontalTopBorderLineInView:controlView]) {
                [bezier moveToPoint:NSMakePoint(aRect.origin.x, aRect.origin.y)];
                [bezier lineToPoint:NSMakePoint(aRect.origin.x + aRect.size.width, aRect.origin.y)];
            }
            
            BOOL shouldDisplayRightDivider = [button shouldDisplayRightDivider];
            if ([cell tabState] & MMTab_RightIsSelectedMask) {
                if (([cell tabState] & (MMTab_PlaceholderOnRight | MMTab_RightIsSliding)) == 0)
                    shouldDisplayRightDivider = NO;
            }
            
            if (shouldDisplayRightDivider) {
                [bezier moveToPoint:NSMakePoint(NSMaxX(aRect), NSMinY(aRect))];
				[bezier lineToPoint:NSMakePoint(NSMaxX(aRect), NSMaxY(aRect))];
            }
            if ([button shouldDisplayLeftDivider]) {
                [bezier moveToPoint:NSMakePoint(NSMinX(aRect), NSMinY(aRect))];
                [bezier lineToPoint:NSMakePoint(NSMinX(aRect), NSMaxY(aRect))];
			}
		} else {
			if (!([cell tabState] & MMTab_LeftIsSelectedMask)) {
				[bezier moveToPoint:NSMakePoint(aRect.origin.x, aRect.origin.y)];
				[bezier lineToPoint:NSMakePoint(aRect.origin.x + aRect.size.width, aRect.origin.y)];
			}

			if (!([cell tabState] & MMTab_RightIsSelectedMask)) {
				[bezier moveToPoint:NSMakePoint(aRect.origin.x, aRect.origin.y + aRect.size.height)];
				[bezier lineToPoint:NSMakePoint(aRect.origin.x + aRect.size.width, aRect.origin.y + aRect.size.height)];
			}
		}
        
		[bezier stroke];        
	}

	[NSGraphicsContext restoreGraphicsState];
}

- (void)drawBezelOfOverflowButton:(MMOverflowPopUpButton *)overflowButton ofTabBarView:(MMTabBarView *)tabBarView inRect:(NSRect)rect {

    MMTabBarOrientation orientation = [tabBarView orientation];
    MMAttachedTabBarButton *lastAttachedButton = [tabBarView lastAttachedButton];
    MMAttachedTabBarButtonCell *lastAttachedButtonCell = [lastAttachedButton cell];

    if ([lastAttachedButton isSliding])
        return;
    
	NSRect cellFrame = [overflowButton frame];

	NSColor *lineColor = [NSColor darkGrayColor];
    
    if (orientation == MMTabBarHorizontalOrientation) {
            // Draw selected
        if ([lastAttachedButtonCell state] == NSOnState) {
            NSRect aRect = NSMakeRect(cellFrame.origin.x, cellFrame.origin.y, cellFrame.size.width, cellFrame.size.height-2.5);
            aRect.size.width += 5.0f;
            
            NSRect fillRect = aRect;
            fillRect.size.width -= 0.5;
            fillRect.size.height -= 0.5;
        
            NSBezierPath *fillPath = [NSBezierPath bezierPathWithCardInRect:fillRect radius:3.0 capMask:MMBezierShapeRightCap|MMBezierShapeFillPath|MMBezierShapeFlippedVertically];
            [fillPath setLineWidth:1.0];
            [[NSColor windowBackgroundColor] set];
            [fillPath fill];
            
            NSBezierPath *strokePath = [NSBezierPath bezierPathWithCardInRect:aRect radius:3.0 capMask:MMBezierShapeRightCap|MMBezierShapeFlippedVertically];
            [strokePath setLineWidth:1.0];
            [lineColor set];
            [strokePath stroke];
        }
    }
}

#pragma mark -
#pragma mark Archiving

- (void)encodeWithCoder:(NSCoder *)aCoder {
	//[super encodeWithCoder:aCoder];
	if ([aCoder allowsKeyedCoding]) {
		[aCoder encodeObject:metalCloseButton forKey:@"metalCloseButton"];
		[aCoder encodeObject:metalCloseButtonDown forKey:@"metalCloseButtonDown"];
		[aCoder encodeObject:metalCloseButtonOver forKey:@"metalCloseButtonOver"];
		[aCoder encodeObject:metalCloseDirtyButton forKey:@"metalCloseDirtyButton"];
		[aCoder encodeObject:metalCloseDirtyButtonDown forKey:@"metalCloseDirtyButtonDown"];
		[aCoder encodeObject:metalCloseDirtyButtonOver forKey:@"metalCloseDirtyButtonOver"];
	}
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	// self = [super initWithCoder:aDecoder];
	//if (self) {
	if ([aDecoder allowsKeyedCoding]) {
		metalCloseButton = [[aDecoder decodeObjectForKey:@"metalCloseButton"] retain];
		metalCloseButtonDown = [[aDecoder decodeObjectForKey:@"metalCloseButtonDown"] retain];
		metalCloseButtonOver = [[aDecoder decodeObjectForKey:@"metalCloseButtonOver"] retain];
		metalCloseDirtyButton = [[aDecoder decodeObjectForKey:@"metalCloseDirtyButton"] retain];
		metalCloseDirtyButtonDown = [[aDecoder decodeObjectForKey:@"metalCloseDirtyButtonDown"] retain];
		metalCloseDirtyButtonOver = [[aDecoder decodeObjectForKey:@"metalCloseDirtyButtonOver"] retain];
	}
	//}
	return self;
}

#pragma mark -
#pragma mark Private Methods

- (BOOL)_shouldDrawHorizontalTopBorderLineInView:(id)controlView
{
    NSWindow *window = [controlView window];
    NSToolbar *toolbar = [window toolbar];
    if (!toolbar || ![toolbar isVisible] || ([toolbar isVisible] && [toolbar showsBaselineSeparator]))
        return NO;
    
    return YES;
}

@end
