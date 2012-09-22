//
//  MMCardTabStyle.m
//  MMTabBarView
//
//  Created by Michael Monscheuer on 9/3/12.
//
//

#import "MMCardTabStyle.h"

#import "MMAttachedTabBarButton.h"
#import "NSView+MMTabBarViewExtensions.h"

@interface MMTabBarView(SharedPrivates)

- (void)_drawInteriorInRect:(NSRect)rect;
- (NSRect)_addTabButtonRect;

@end

@implementation MMCardTabStyle

@synthesize horizontalInset = _horizontalInset;
@synthesize topMargin = _topMargin;

+ (NSString *)name {
    return @"Card";
}

- (NSString *)name {
	return [[self class] name];
}

#pragma mark -
#pragma mark Creation/Destruction

- (id) init {
    if ( (self = [super init]) ) {
        cardCloseButton = [[NSImage alloc] initByReferencingFile:[[MMTabBarView bundle] pathForImageResource:@"AquaTabClose_Front"]];
        cardCloseButtonDown = [[NSImage alloc] initByReferencingFile:[[MMTabBarView bundle] pathForImageResource:@"AquaTabClose_Front_Pressed"]];
        cardCloseButtonOver = [[NSImage alloc] initByReferencingFile:[[MMTabBarView bundle] pathForImageResource:@"AquaTabClose_Front_Rollover"]];
        
        cardCloseDirtyButton = [[NSImage alloc] initByReferencingFile:[[MMTabBarView bundle] pathForImageResource:@"AquaTabCloseDirty_Front"]];
        cardCloseDirtyButtonDown = [[NSImage alloc] initByReferencingFile:[[MMTabBarView bundle] pathForImageResource:@"AquaTabCloseDirty_Front_Pressed"]];
        cardCloseDirtyButtonOver = [[NSImage alloc] initByReferencingFile:[[MMTabBarView bundle] pathForImageResource:@"AquaTabCloseDirty_Front_Rollover"]];
                        
		_horizontalInset = 3.0;
	}
    return self;
}

- (void)dealloc {
    [cardCloseButton release];
    [cardCloseButtonDown release];
    [cardCloseButtonOver release];
    [cardCloseDirtyButton release];
    [cardCloseDirtyButtonDown release];
    [cardCloseDirtyButtonOver release]; 
    
    [super dealloc];
}

#pragma mark -
#pragma mark Tab View Specific

- (CGFloat)leftMarginForTabBarView:(MMTabBarView *)tabBarView {
    if ([tabBarView orientation] == MMTabBarHorizontalOrientation)
        return _horizontalInset;
    else
        return 0.0;
}

- (CGFloat)rightMarginForTabBarView:(MMTabBarView *)tabBarView {
    if ([tabBarView orientation] == MMTabBarHorizontalOrientation)
        return _horizontalInset;
    else
        return 0.0;
}

- (CGFloat)topMarginForTabBarView:(MMTabBarView *)tabBarView {
    if ([tabBarView orientation] == MMTabBarHorizontalOrientation)
        return 2.0;

    return 0.0f;
}

- (CGFloat)heightOfTabBarButtonsForTabBarView:(MMTabBarView *)tabBarView {

    return kMMTabBarViewHeight - [self topMarginForTabBarView:tabBarView];
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
#pragma mark Providing Images

- (NSImage *)closeButtonImageOfType:(MMCloseButtonImageType)type forTabCell:(MMTabBarButtonCell *)cell
{
    switch (type) {
        case MMCloseButtonImageTypeStandard:
            return cardCloseButton;
        case MMCloseButtonImageTypeRollover:
            return cardCloseButtonOver;
        case MMCloseButtonImageTypePressed:
            return cardCloseButtonDown;
            
        case MMCloseButtonImageTypeDirty:
            return cardCloseDirtyButton;
        case MMCloseButtonImageTypeDirtyRollover:
            return cardCloseDirtyButtonOver;
        case MMCloseButtonImageTypeDirtyPressed:
            return cardCloseDirtyButtonDown;
            
        default:
            break;
    }
}

#pragma mark -
#pragma mark Drawing

- (void)drawBezelOfTabBarView:(MMTabBarView *)tabBarView inRect:(NSRect)rect {
	//Draw for our whole bounds; it'll be automatically clipped to fit the appropriate drawing area
	NSRect bounds = [tabBarView bounds];
    
    bounds.size.height -= 1.0;    

    NSGradient *gradient = nil;
    
    if ([tabBarView isWindowActive]) {
        // gray bar gradient
        gradient = [[NSGradient alloc] initWithColorsAndLocations:
                        [NSColor colorWithCalibratedWhite:0.678 alpha:1.000],0.0f,
                        [NSColor colorWithCalibratedWhite:0.821 alpha:1.000],1.0f,
                        nil];
    } else {
        // light gray bar gradient
        gradient = [[NSGradient alloc] initWithColorsAndLocations:
                [NSColor colorWithCalibratedWhite:0.821 alpha:1.000],0.0f,
                [NSColor colorWithCalibratedWhite:0.956 alpha:1.000],1.0f,
                nil];
    }
    
    if (gradient) {
        [gradient drawInRect:bounds angle:270];
    
        [gradient release];
        }

    bounds = [tabBarView bounds];
        
        // draw additional separator line
    [[NSColor colorWithCalibratedWhite:0.576 alpha:1.0] set];
        
    [NSBezierPath strokeLineFromPoint:NSMakePoint(NSMinX(bounds),NSMaxY(bounds)-0.5)
                  toPoint:NSMakePoint(NSMaxX(bounds),NSMaxY(bounds)-0.5)];        
}

- (void)drawInteriorOfTabBarView:(MMTabBarView *)tabBarView inRect:(NSRect)rect {
        // perform standard drawing
    [tabBarView _drawInteriorInRect:rect];
}

- (void)drawBezelOfTabCell:(MMTabBarButtonCell *)cell withFrame:(NSRect)frame inView:(NSView *)controlView {

    MMTabBarView *tabBarView = [controlView enclosingTabBarView];
    	
    NSColor * lineColor = nil;
    NSBezierPath *bezier = [NSBezierPath bezierPath];
    lineColor = [NSColor colorWithCalibratedWhite:0.576 alpha:1.0];

    NSRect aRect = NSMakeRect(frame.origin.x+.5, frame.origin.y+0.5, frame.size.width-1.0, frame.size.height-1.0);
    
    // frame
    CGFloat radius = MIN(6.0, 0.5f * MIN(NSWidth(aRect), NSHeight(aRect)))-0.5;

    [bezier moveToPoint: NSMakePoint(NSMinX(aRect),NSMaxY(aRect)+1.0)];
    [bezier appendBezierPathWithArcFromPoint:NSMakePoint(NSMinX(aRect),NSMinY(aRect)) toPoint:NSMakePoint(NSMidX(aRect),NSMinY(aRect)) radius:radius];
    [bezier appendBezierPathWithArcFromPoint:NSMakePoint(NSMaxX(aRect),NSMinY(aRect)) toPoint:NSMakePoint(NSMaxX(aRect),NSMaxY(aRect)) radius:radius];
    [bezier lineToPoint: NSMakePoint(NSMaxX(aRect),NSMaxY(aRect)+1.0)];
    
    NSGradient *gradient = nil;

    if ([tabBarView isWindowActive]) {
        if ([cell state] == NSOnState) {
              gradient = [[NSGradient alloc] initWithStartingColor:[NSColor whiteColor] endingColor:[NSColor colorWithDeviceWhite:0.929 alpha:1.000]];
        } else if ([cell mouseHovered]) {
        
            gradient = [[NSGradient alloc] 
                initWithStartingColor: [NSColor colorWithCalibratedWhite:0.80 alpha:1.0]
                endingColor:[NSColor colorWithCalibratedWhite:0.80 alpha:1.0]];           
        } else {

            gradient = [[NSGradient alloc] 
                initWithStartingColor:[NSColor colorWithCalibratedWhite:0.835 alpha:1.0] 
                endingColor:[NSColor colorWithCalibratedWhite:0.843 alpha:1.0]];                                
        }

        if (gradient != nil) {
            [gradient drawInBezierPath:bezier angle:90.0f];
            [gradient release], gradient = nil;
            }
    } else {
        [[NSColor windowBackgroundColor] set];
        NSRectFill(aRect);
    }
    
    [lineColor set];
    [bezier stroke];

    if ([cell state] == NSOffState) {
    
            // draw additional separator line
        [[NSColor colorWithCalibratedWhite:0.576 alpha:1.0] set];
        
        [NSBezierPath strokeLineFromPoint:NSMakePoint(NSMinX(frame),NSMaxY(frame)-0.5)
                  toPoint:NSMakePoint(NSMaxX(frame),NSMaxY(frame)-0.5)];
    }    
}

#pragma mark -
#pragma mark Archiving

- (void)encodeWithCoder:(NSCoder *)aCoder {
	// ... do not encode anything
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	// ... do not read anything
	return [self init];
}

@end
