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

@implementation MMMetalTabStyle

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

		_addTabButtonImage = [[NSImage alloc] initByReferencingFile:[[MMTabBarView bundle] pathForImageResource:@"TabNewMetal"]];
		_addTabButtonPressedImage = [[NSImage alloc] initByReferencingFile:[[MMTabBarView bundle] pathForImageResource:@"TabNewMetalPressed"]];
		_addTabButtonRolloverImage = [[NSImage alloc] initByReferencingFile:[[MMTabBarView bundle] pathForImageResource:@"TabNewMetalRollover"]];

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
	[_addTabButtonImage release];
	[_addTabButtonPressedImage release];
	[_addTabButtonRolloverImage release];

	[_objectCountStringAttributes release];

	[super dealloc];
}

#pragma mark -
#pragma mark Control Specific

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

- (NSImage *)addTabButtonImage {
	return _addTabButtonImage;
}

- (NSImage *)addTabButtonPressedImage {
	return _addTabButtonPressedImage;
}

- (NSImage *)addTabButtonRolloverImage {
	return _addTabButtonRolloverImage;
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
#pragma mark Drawing

- (BOOL)_shouldDrawHorizontalTopBorderLineInView:(id)controlView
{
    NSWindow *window = [controlView window];
    NSToolbar *toolbar = [window toolbar];
    if (!toolbar || ![toolbar isVisible] || ([toolbar isVisible] && [toolbar showsBaselineSeparator]))
        return NO;
    
    return YES;
}

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

- (void)drawBezelOfTabCell:(MMTabBarButtonCell *)cell withFrame:(NSRect)frame inView:(NSView *)controlView {

	NSRect cellFrame = frame;
	NSColor *lineColor = nil;
	NSBezierPath *bezier = [NSBezierPath bezierPath];
	lineColor = [NSColor darkGrayColor];
    
    MMTabBarView *tabBarView = [controlView enclosingTabBarView];
    MMTabBarOrientation orientation = [tabBarView orientation];

	//disable antialiasing of bezier paths
	[NSGraphicsContext saveGraphicsState];
	[[NSGraphicsContext currentContext] setShouldAntialias:NO];

	if ([cell state] == NSOnState) {
		// selected tab
		if (orientation == MMTabBarHorizontalOrientation) {
			NSRect aRect = NSMakeRect(cellFrame.origin.x, cellFrame.origin.y, cellFrame.size.width, cellFrame.size.height - 2.5);

			// background
			aRect.origin.x += 1.0;
			aRect.size.width--;
			aRect.size.height -= 0.5;
            
            [[NSColor windowBackgroundColor] set];
            NSRectFill(aRect);

			aRect.size.width++;
			aRect.size.height += 0.5;

			// frame
			aRect.origin.x -= 0.5;
			[lineColor set];
			[bezier setLineWidth:1.0];
			[bezier moveToPoint:NSMakePoint(aRect.origin.x, aRect.origin.y)];
			[bezier lineToPoint:NSMakePoint(aRect.origin.x, aRect.origin.y + aRect.size.height - 1.5)];
			[bezier lineToPoint:NSMakePoint(aRect.origin.x + 1.5, aRect.origin.y + aRect.size.height)];
			[bezier lineToPoint:NSMakePoint(aRect.origin.x + aRect.size.width - 2.5, aRect.origin.y + aRect.size.height)];
			[bezier lineToPoint:NSMakePoint(aRect.origin.x + aRect.size.width, aRect.origin.y + aRect.size.height - 1.5)];
			[bezier lineToPoint:NSMakePoint(aRect.origin.x + aRect.size.width, aRect.origin.y)];
			if ([[cell controlView] frame].size.height < 2) {
				// special case of hidden control; need line across top of cell
				[bezier moveToPoint:NSMakePoint(aRect.origin.x, aRect.origin.y + 0.5)];
				[bezier lineToPoint:NSMakePoint(aRect.origin.x + aRect.size.width, aRect.origin.y + 0.5)];
			}
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
		NSRect aRect = NSMakeRect(cellFrame.origin.x, cellFrame.origin.y, cellFrame.size.width, cellFrame.size.height);
		aRect.origin.y += 0.5;
		aRect.origin.x += 1.5;
		aRect.size.width -= 1;

		// rollover
		if ([cell mouseHovered]) {
			[[NSColor colorWithCalibratedWhite:0.0 alpha:0.1] set];
			NSRectFillUsingOperation(aRect, NSCompositeSourceAtop);
		}

		[lineColor set];

		if (orientation == MMTabBarHorizontalOrientation) {
			aRect.origin.x -= 1;
			aRect.size.width += 1;

			// frame
            if ([self _shouldDrawHorizontalTopBorderLineInView:controlView]) {
                [bezier moveToPoint:NSMakePoint(aRect.origin.x, aRect.origin.y)];
                [bezier lineToPoint:NSMakePoint(aRect.origin.x + aRect.size.width, aRect.origin.y)];
            } else {
                [bezier moveToPoint:NSMakePoint(aRect.origin.x + aRect.size.width, aRect.origin.y)];
            }
            
			if (!([cell tabState] & MMTab_RightIsSelectedMask)) {
				[bezier lineToPoint:NSMakePoint(aRect.origin.x + aRect.size.width, aRect.origin.y + aRect.size.height)];
                
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
		[aCoder encodeObject:_addTabButtonImage forKey:@"addTabButtonImage"];
		[aCoder encodeObject:_addTabButtonPressedImage forKey:@"addTabButtonPressedImage"];
		[aCoder encodeObject:_addTabButtonRolloverImage forKey:@"addTabButtonRolloverImage"];
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
		_addTabButtonImage = [[aDecoder decodeObjectForKey:@"addTabButtonImage"] retain];
		_addTabButtonPressedImage = [[aDecoder decodeObjectForKey:@"addTabButtonPressedImage"] retain];
		_addTabButtonRolloverImage = [[aDecoder decodeObjectForKey:@"addTabButtonRolloverImage"] retain];
	}
	//}
	return self;
}

@end
