//
//  MMUnifiedTabStyle.m
//  --------------------
//
//  Created by Keith Blount on 30/04/2006.
//  Copyright 2006 Keith Blount. All rights reserved.
//

#import "MMUnifiedTabStyle.h"
#import "MMAttachedTabBarButton.h"
#import "MMTabBarView.h"
#import "NSView+MMTabBarViewExtensions.h"

@implementation MMUnifiedTabStyle

@synthesize leftMarginForTabBarView = _leftMargin;

+ (NSString *)name {
    return @"Unified";
}

- (NSString *)name {
	return [[self class] name];
}

#pragma mark -
#pragma mark Creation/Destruction

- (id) init {
	if ((self = [super init])) {
		unifiedCloseButton = [[NSImage alloc] initByReferencingFile:[[MMTabBarView bundle] pathForImageResource:@"AquaTabClose_Front"]];
		unifiedCloseButtonDown = [[NSImage alloc] initByReferencingFile:[[MMTabBarView bundle] pathForImageResource:@"AquaTabClose_Front_Pressed"]];
		unifiedCloseButtonOver = [[NSImage alloc] initByReferencingFile:[[MMTabBarView bundle] pathForImageResource:@"AquaTabClose_Front_Rollover"]];

		unifiedCloseDirtyButton = [[NSImage alloc] initByReferencingFile:[[MMTabBarView bundle] pathForImageResource:@"AquaTabCloseDirty_Front"]];
		unifiedCloseDirtyButtonDown = [[NSImage alloc] initByReferencingFile:[[MMTabBarView bundle] pathForImageResource:@"AquaTabCloseDirty_Front_Pressed"]];
		unifiedCloseDirtyButtonOver = [[NSImage alloc] initByReferencingFile:[[MMTabBarView bundle] pathForImageResource:@"AquaTabCloseDirty_Front_Rollover"]];

		_leftMargin = 0.0;
	}
	return self;
}

- (void)dealloc {
	[unifiedCloseButton release];
	[unifiedCloseButtonDown release];
	[unifiedCloseButtonOver release];
	[unifiedCloseDirtyButton release];
	[unifiedCloseDirtyButtonDown release];
	[unifiedCloseDirtyButtonOver release];

	[super dealloc];
}

#pragma mark -
#pragma mark Tab View Specific

- (CGFloat)leftMarginForTabBarView:(MMTabBarView *)tabBarView {
    if ([tabBarView orientation] == MMTabBarHorizontalOrientation)
        return _leftMargin;
    else
        return 0.0f;
}

- (CGFloat)rightMarginForTabBarView:(MMTabBarView *)tabBarView {
    if ([tabBarView orientation] == MMTabBarHorizontalOrientation)
        return _leftMargin;
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
#pragma mark Drag Support

- (NSRect)draggingRectForTabButton:(MMAttachedTabBarButton *)aButton ofTabBarView:(MMTabBarView *)tabBarView {

	NSRect dragRect = [aButton stackingFrame];
	dragRect.size.width++;
	return dragRect;
    
}

#pragma mark -
#pragma mark Providing Images

- (NSImage *)closeButtonImageOfType:(MMCloseButtonImageType)type forTabCell:(MMTabBarButtonCell *)cell
{
    switch (type) {
        case MMCloseButtonImageTypeStandard:
            return unifiedCloseButton;
        case MMCloseButtonImageTypeRollover:
            return unifiedCloseButtonOver;
        case MMCloseButtonImageTypePressed:
            return unifiedCloseButtonDown;
            
        case MMCloseButtonImageTypeDirty:
            return unifiedCloseDirtyButton;
        case MMCloseButtonImageTypeDirtyRollover:
            return unifiedCloseDirtyButtonOver;
        case MMCloseButtonImageTypeDirtyPressed:
            return unifiedCloseDirtyButtonDown;
            
        default:
            break;
    }
    
}

#pragma mark -
#pragma mark Drawing

-(void)drawBezelOfTabCell:(MMTabBarButtonCell *)cell withFrame:(NSRect)frame inView:(NSView *)controlView
{
    MMTabBarView *tabBarView = [controlView enclosingTabBarView];
    
    NSWindow *window = [controlView window];
    NSToolbar *toolbar = [window toolbar];
    
	NSBezierPath *bezier = [NSBezierPath bezierPath];
	NSColor *lineColor = [NSColor colorWithCalibratedWhite:0.576 alpha:1.0];
    
    if (toolbar && [toolbar isVisible]) {

        NSRect aRect = NSMakeRect(frame.origin.x+0.5, frame.origin.y - 0.5, frame.size.width-1.0, frame.size.height-1.0);
        
        if ([cell mouseHovered] && [cell state] == NSOffState)
            {
            aRect.origin.y += 1.5;
            aRect.size.height -= 1.5;
            }
        
        CGFloat radius = MIN(6.0, 0.5f * MIN(NSWidth(aRect), NSHeight(aRect)));
        NSRect rect = NSInsetRect(aRect, radius, radius);
        
        NSPoint cornerPoint = NSMakePoint(NSMaxX(aRect), NSMinY(aRect));
        [bezier appendBezierPathWithPoints:&cornerPoint count:1];

        [bezier appendBezierPathWithArcWithCenter:NSMakePoint(NSMaxX(rect), NSMaxY(rect)) radius:radius startAngle:0.0 endAngle:90.0];

        [bezier appendBezierPathWithArcWithCenter:NSMakePoint(NSMinX(rect), NSMaxY(rect)) radius:radius startAngle:90.0 endAngle:180.0];

        cornerPoint = NSMakePoint(NSMinX(aRect), NSMinY(aRect));
        [bezier appendBezierPathWithPoints:&cornerPoint count:1];    

        if ([tabBarView isWindowActive]) {
            if ([cell state] == NSOnState) {
                NSColor *startColor = [NSColor colorWithDeviceWhite:0.698 alpha:1.000];
                NSColor *endColor = [NSColor colorWithDeviceWhite:0.663 alpha:1.000];
                NSGradient *gradient = [[NSGradient alloc] initWithStartingColor:startColor endingColor:endColor];
                [gradient drawInBezierPath:bezier angle:80.0];
                [gradient release];
            } else if ([cell mouseHovered]) {
                NSColor *startColor = [NSColor colorWithDeviceWhite:0.8 alpha:1.000];
                NSColor *endColor = [NSColor colorWithDeviceWhite:0.8 alpha:1.000];
                NSGradient *gradient = [[NSGradient alloc] initWithStartingColor:startColor endingColor:endColor];
                [gradient drawInBezierPath:bezier angle:80.0];
                [gradient release];            
            }
            
        } else {
            if ([cell state] == NSOnState) {
                NSColor *startColor = [NSColor colorWithDeviceWhite:0.875 alpha:1.000];
                NSColor *endColor = [NSColor colorWithDeviceWhite:0.902 alpha:1.000];
                NSGradient *gradient = [[NSGradient alloc] initWithStartingColor:startColor endingColor:endColor];
                [[NSGraphicsContext currentContext] setShouldAntialias:NO];
                [gradient drawInBezierPath:bezier angle:90.0];
                [[NSGraphicsContext currentContext] setShouldAntialias:YES];
                [gradient release];
            }
        }        
            
        [lineColor set];
        [bezier stroke];
    } else {
    
		NSRect aRect = NSMakeRect(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
		aRect.origin.y += 0.5;
		aRect.origin.x += 1.5;
		aRect.size.width -= 1;

		aRect.origin.x -= 1;
		aRect.size.width += 1;


        if ([cell state] == NSOnState) {
			[[NSColor colorWithCalibratedWhite:0.0 alpha:0.2] set];
			NSRectFillUsingOperation(aRect, NSCompositeSourceAtop);            
        } else if ([cell mouseHovered]) {
			[[NSColor colorWithCalibratedWhite:0.0 alpha:0.1] set];
			NSRectFillUsingOperation(aRect, NSCompositeSourceAtop);
		}

		// frame
		[lineColor set];
		[bezier moveToPoint:NSMakePoint(aRect.origin.x + aRect.size.width, aRect.origin.y - 0.5)];
		if (!([cell tabState] & MMTab_RightIsSelectedMask)) {
			[bezier lineToPoint:NSMakePoint(NSMaxX(aRect), NSMaxY(aRect))];
		}

		[bezier stroke];

		// Create a thin lighter line next to the dividing line for a bezel effect
		if (!([cell tabState] & MMTab_RightIsSelectedMask)) {
			[[[NSColor whiteColor] colorWithAlphaComponent:0.5] set];
			[NSBezierPath strokeLineFromPoint:NSMakePoint(NSMaxX(aRect) + 1.0, aRect.origin.y - 0.5)
			 toPoint:NSMakePoint(NSMaxX(aRect) + 1.0, NSMaxY(aRect) - 2.5)];
		}

		// If this is the leftmost tab, we want to draw a line on the left, too
		if ([cell tabState] & MMTab_PositionLeftMask) {
			[lineColor set];
			[NSBezierPath strokeLineFromPoint:NSMakePoint(aRect.origin.x, aRect.origin.y - 0.5)
			 toPoint:NSMakePoint(aRect.origin.x, NSMaxY(aRect) - 2.5)];
			[[[NSColor whiteColor] colorWithAlphaComponent:0.5] set];
			[NSBezierPath strokeLineFromPoint:NSMakePoint(aRect.origin.x + 1.0, aRect.origin.y - 0.5)
			 toPoint:NSMakePoint(aRect.origin.x + 1.0, NSMaxY(aRect) - 2.5)];
		}    
    }
}

- (void)drawBezelOfTabBarView:(MMTabBarView *)tabBarView inRect:(NSRect)rect {
	//Draw for our whole bounds; it'll be automatically clipped to fit the appropriate drawing area
	rect = [tabBarView bounds];

	NSRect gradientRect = rect;
	gradientRect.size.height -= 1.0;

	if (![tabBarView isWindowActive]) {
		[[NSColor windowBackgroundColor] set];
		NSRectFill(gradientRect);
	} else {
        NSGradient *gradient = [[NSGradient alloc] initWithStartingColor:[NSColor colorWithCalibratedWhite:0.835 alpha:1.0] endingColor:[NSColor colorWithCalibratedWhite:0.843 alpha:1.0]];
        [gradient drawInRect:gradientRect angle:90.0];
        [gradient release];
    }

	[[NSColor colorWithCalibratedWhite:0.576 alpha:1.0] set];
	[NSBezierPath strokeLineFromPoint:NSMakePoint(rect.origin.x, NSMinY(rect) + 0.5)
	 toPoint:NSMakePoint(NSMaxX(rect), NSMinY(rect) + 0.5)];
}

#pragma mark -
#pragma mark Archiving

- (void)encodeWithCoder:(NSCoder *)aCoder {
	//[super encodeWithCoder:aCoder];
	if ([aCoder allowsKeyedCoding]) {
		[aCoder encodeObject:unifiedCloseButton forKey:@"unifiedCloseButton"];
		[aCoder encodeObject:unifiedCloseButtonDown forKey:@"unifiedCloseButtonDown"];
		[aCoder encodeObject:unifiedCloseButtonOver forKey:@"unifiedCloseButtonOver"];
		[aCoder encodeObject:unifiedCloseDirtyButton forKey:@"unifiedCloseDirtyButton"];
		[aCoder encodeObject:unifiedCloseDirtyButtonDown forKey:@"unifiedCloseDirtyButtonDown"];
		[aCoder encodeObject:unifiedCloseDirtyButtonOver forKey:@"unifiedCloseDirtyButtonOver"];
	}
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	// self = [super initWithCoder:aDecoder];
	//if (self) {
	if ([aDecoder allowsKeyedCoding]) {
		unifiedCloseButton = [[aDecoder decodeObjectForKey:@"unifiedCloseButton"] retain];
		unifiedCloseButtonDown = [[aDecoder decodeObjectForKey:@"unifiedCloseButtonDown"] retain];
		unifiedCloseButtonOver = [[aDecoder decodeObjectForKey:@"unifiedCloseButtonOver"] retain];
		unifiedCloseDirtyButton = [[aDecoder decodeObjectForKey:@"unifiedCloseDirtyButton"] retain];
		unifiedCloseDirtyButtonDown = [[aDecoder decodeObjectForKey:@"unifiedCloseDirtyButtonDown"] retain];
		unifiedCloseDirtyButtonOver = [[aDecoder decodeObjectForKey:@"unifiedCloseDirtyButtonOver"] retain];
	}
	//}
	return self;
}

@end
