//
//  MMAquaTabStyle.m
//  MMTabBarView
//
//  Created by John Pannell on 2/17/06.
//  Copyright 2006 Positive Spin Media. All rights reserved.
//

#import "MMAquaTabStyle.h"
#import "MMAttachedTabBarButtonCell.h"
#import "MMTabBarView.h"
#import "NSView+MMTabBarViewExtensions.h"

@implementation MMAquaTabStyle

+ (NSString *)name {
    return @"Aqua";
}

- (NSString *)name {
	return [[self class] name];
}

#pragma mark -
#pragma mark Creation/Destruction

- (id) init {
	if ((self = [super init])) {
		[self loadImages];
	}
	return self;
}

- (void) loadImages {
	// Aqua Tabs Images
	aquaTabBg = [[NSImage alloc] initByReferencingFile:[[MMTabBarView bundle] pathForImageResource:@"AquaTabsBackground"]];
	[aquaTabBg setFlipped:YES];

	aquaTabBgDown = [[NSImage alloc] initByReferencingFile:[[MMTabBarView bundle] pathForImageResource:@"AquaTabsDown"]];
	[aquaTabBgDown setFlipped:YES];

	aquaTabBgDownGraphite = [[NSImage alloc] initByReferencingFile:[[MMTabBarView bundle] pathForImageResource:@"AquaTabsDownGraphite"]];
	[aquaTabBgDown setFlipped:YES];

	aquaTabBgDownNonKey = [[NSImage alloc] initByReferencingFile:[[MMTabBarView bundle] pathForImageResource:@"AquaTabsDownNonKey"]];
	[aquaTabBgDown setFlipped:YES];

	aquaDividerDown = [[NSImage alloc] initByReferencingFile:[[MMTabBarView bundle] pathForImageResource:@"AquaTabsSeparatorDown"]];
	[aquaDivider setFlipped:NO];

	aquaDivider = [[NSImage alloc] initByReferencingFile:[[MMTabBarView bundle] pathForImageResource:@"AquaTabsSeparator"]];
	[aquaDivider setFlipped:NO];

	aquaCloseButton = [[NSImage alloc] initByReferencingFile:[[MMTabBarView bundle] pathForImageResource:@"AquaTabClose_Front"]];
	aquaCloseButtonDown = [[NSImage alloc] initByReferencingFile:[[MMTabBarView bundle] pathForImageResource:@"AquaTabClose_Front_Pressed"]];
	aquaCloseButtonOver = [[NSImage alloc] initByReferencingFile:[[MMTabBarView bundle] pathForImageResource:@"AquaTabClose_Front_Rollover"]];

	aquaCloseDirtyButton = [[NSImage alloc] initByReferencingFile:[[MMTabBarView bundle] pathForImageResource:@"AquaTabCloseDirty_Front"]];
	aquaCloseDirtyButtonDown = [[NSImage alloc] initByReferencingFile:[[MMTabBarView bundle] pathForImageResource:@"AquaTabCloseDirty_Front_Pressed"]];
	aquaCloseDirtyButtonOver = [[NSImage alloc] initByReferencingFile:[[MMTabBarView bundle] pathForImageResource:@"AquaTabCloseDirty_Front_Rollover"]];
}

- (void)dealloc {
	[aquaTabBg release];
	[aquaTabBgDown release];
	[aquaDividerDown release];
	[aquaDivider release];
	[aquaCloseButton release];
	[aquaCloseButtonDown release];
	[aquaCloseButtonOver release];
	[aquaCloseDirtyButton release];
	[aquaCloseDirtyButtonDown release];
	[aquaCloseDirtyButtonOver release];

	[super dealloc];
}

#pragma mark -
#pragma mark Tab View Specifics

- (CGFloat)leftMarginForTabBarView:(MMTabBarView *)tabBarView {
	return 0.0f;
}

- (CGFloat)rightMarginForTabBarView:(MMTabBarView *)tabBarView {
	return 0.0f;
}

- (CGFloat)topMarginForTabBarView:(MMTabBarView *)tabBarView {
	return 0.0f;
}

#pragma mark -
#pragma mark Providing Images

- (NSImage *)closeButtonImageOfType:(MMCloseButtonImageType)type forTabCell:(MMTabBarButtonCell *)cell
{
    switch (type) {
        case MMCloseButtonImageTypeStandard:
            return aquaCloseButton;
        case MMCloseButtonImageTypeRollover:
            return aquaCloseButtonOver;
        case MMCloseButtonImageTypePressed:
            return aquaCloseButtonDown;
            
        case MMCloseButtonImageTypeDirty:
            return aquaCloseDirtyButton;
        case MMCloseButtonImageTypeDirtyRollover:
            return aquaCloseDirtyButtonOver;
        case MMCloseButtonImageTypeDirtyPressed:
            return aquaCloseDirtyButtonDown;
            
        default:
            break;
    }
    
}

#pragma mark -
#pragma mark Drawing

- (void)drawBezelOfTabCell:(MMTabBarButtonCell *)cell withFrame:(NSRect)frame inView:(NSView *)controlView {

    MMTabBarView *tabBarView = [controlView enclosingTabBarView];

	NSRect cellFrame = frame;

	// Selected Tab
	if ([cell state] == NSOnState) {
		NSRect aRect = NSMakeRect(cellFrame.origin.x, cellFrame.origin.y, cellFrame.size.width, cellFrame.size.height - 2.5);
		aRect.size.height -= 0.5;

		// proper tint
		NSControlTint currentTint;
		if ([cell controlTint] == NSDefaultControlTint) {
			currentTint = [NSColor currentControlTint];
		} else{
			currentTint = [cell controlTint];
		}

		if (![tabBarView isWindowActive]) {
			currentTint = NSClearControlTint;
		}

		NSImage *bgImage;
		switch(currentTint) {
		case NSGraphiteControlTint:
			bgImage = aquaTabBgDownGraphite;
			break;
		case NSClearControlTint:
			bgImage = aquaTabBgDownNonKey;
			break;
		case NSBlueControlTint:
		default:
			bgImage = aquaTabBgDown;
			break;
		}

		[bgImage drawInRect:cellFrame fromRect:NSMakeRect(0.0, 0.0, 1.0, 22.0) operation:NSCompositeSourceOver fraction:1.0 respectFlipped:NO hints:nil];
        [aquaDivider drawAtPoint:NSMakePoint(cellFrame.origin.x + cellFrame.size.width - 1.0, cellFrame.origin.y) fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0];

		aRect.size.height += 0.5;
	} else { // Unselected Tab
		NSRect aRect = NSMakeRect(cellFrame.origin.x, cellFrame.origin.y, cellFrame.size.width, cellFrame.size.height);
		aRect.origin.y += 0.5;
		aRect.origin.x += 1.5;
		aRect.size.width -= 1;

		aRect.origin.x -= 1;
		aRect.size.width += 1;

		// Rollover
		if ([cell mouseHovered]) {
			[[NSColor colorWithCalibratedWhite:0.0 alpha:0.1] set];
			NSRectFillUsingOperation(aRect, NSCompositeSourceAtop);
		}

        [aquaDivider drawAtPoint:NSMakePoint(cellFrame.origin.x + cellFrame.size.width - 1.0, cellFrame.origin.y) fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0];
	}
}

- (void)drawBezelOfTabBarView:(MMTabBarView *)tabBarView inRect:(NSRect)rect {
	if (rect.size.height <= 22.0) {
		//Draw for our whole bounds; it'll be automatically clipped to fit the appropriate drawing area
		rect = [tabBarView bounds];

		[aquaTabBg drawInRect:rect fromRect:NSMakeRect(0.0, 0.0, 1.0, 22.0) operation:NSCompositeSourceOver fraction:1.0 respectFlipped:NO hints:nil];
	}
}

#pragma mark -
#pragma mark Archiving

- (void)encodeWithCoder:(NSCoder *)aCoder {
	//[super encodeWithCoder:aCoder];
	if ([aCoder allowsKeyedCoding]) {
		[aCoder encodeObject:aquaTabBg forKey:@"aquaTabBg"];
		[aCoder encodeObject:aquaTabBgDown forKey:@"aquaTabBgDown"];
		[aCoder encodeObject:aquaTabBgDownGraphite forKey:@"aquaTabBgDownGraphite"];
		[aCoder encodeObject:aquaTabBgDownNonKey forKey:@"aquaTabBgDownNonKey"];
		[aCoder encodeObject:aquaDividerDown forKey:@"aquaDividerDown"];
		[aCoder encodeObject:aquaDivider forKey:@"aquaDivider"];
		[aCoder encodeObject:aquaCloseButton forKey:@"aquaCloseButton"];
		[aCoder encodeObject:aquaCloseButtonDown forKey:@"aquaCloseButtonDown"];
		[aCoder encodeObject:aquaCloseButtonOver forKey:@"aquaCloseButtonOver"];
		[aCoder encodeObject:aquaCloseDirtyButton forKey:@"aquaCloseDirtyButton"];
		[aCoder encodeObject:aquaCloseDirtyButtonDown forKey:@"aquaCloseDirtyButtonDown"];
		[aCoder encodeObject:aquaCloseDirtyButtonOver forKey:@"aquaCloseDirtyButtonOver"];
	}
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	//self = [super initWithCoder:aDecoder];
	//if (self) {
	if ([aDecoder allowsKeyedCoding]) {
		aquaTabBg = [[aDecoder decodeObjectForKey:@"aquaTabBg"] retain];
		aquaTabBgDown = [[aDecoder decodeObjectForKey:@"aquaTabBgDown"] retain];
		aquaTabBgDownGraphite = [[aDecoder decodeObjectForKey:@"aquaTabBgDownGraphite"] retain];
		aquaTabBgDownNonKey = [[aDecoder decodeObjectForKey:@"aquaTabBgDownNonKey"] retain];
		aquaDividerDown = [[aDecoder decodeObjectForKey:@"aquaDividerDown"] retain];
		aquaDivider = [[aDecoder decodeObjectForKey:@"aquaDivider"] retain];
		aquaCloseButton = [[aDecoder decodeObjectForKey:@"aquaCloseButton"] retain];
		aquaCloseButtonDown = [[aDecoder decodeObjectForKey:@"aquaCloseButtonDown"] retain];
		aquaCloseButtonOver = [[aDecoder decodeObjectForKey:@"aquaCloseButtonOver"] retain];
		aquaCloseDirtyButton = [[aDecoder decodeObjectForKey:@"aquaCloseDirtyButton"] retain];
		aquaCloseDirtyButtonDown = [[aDecoder decodeObjectForKey:@"aquaCloseDirtyButtonDown"] retain];
		aquaCloseDirtyButtonOver = [[aDecoder decodeObjectForKey:@"aquaCloseDirtyButtonOver"] retain];
	}
	//}
	return self;
}

@end
