//
//  NSBezierPath+MMTabBarViewExtensions.m
//  MMTabBarView
//
//  Created by Michael Monscheuer on 9/26/12.
//  Copyright (c) 2012 Michael Monscheuer. All rights reserved.
//

#import "NSBezierPath+MMTabBarViewExtensions.h"

#import "NSAffineTransform+MMTabBarViewExtensions.h"

@implementation NSBezierPath (MMTabBarViewExtensions)

+ (NSBezierPath *)_bezierPathWithCardInRect:(NSRect)aRect radius:(CGFloat)radius borderMask:(MMBezierShapeCapMask)mask {

    NSBezierPath *bezier = [NSBezierPath bezierPath];

    if (mask & MMBezierShapeLeftCap) {
        [bezier moveToPoint: NSMakePoint(NSMinX(aRect),NSMaxY(aRect))];
        [bezier appendBezierPathWithArcFromPoint:NSMakePoint(NSMinX(aRect),NSMinY(aRect)) toPoint:NSMakePoint(NSMidX(aRect),NSMinY(aRect)) radius:radius];
    } else {
        if (mask & MMBezierShapeFillPath) {
            [bezier moveToPoint: NSMakePoint(NSMinX(aRect),NSMaxY(aRect))];
            [bezier lineToPoint:NSMakePoint(NSMinX(aRect), NSMinY(aRect))];
        } else {
            [bezier moveToPoint:NSMakePoint(NSMinX(aRect), NSMinY(aRect))];
        }
    }
    
    if (mask & MMBezierShapeRightCap) {
        [bezier appendBezierPathWithArcFromPoint:NSMakePoint(NSMaxX(aRect),NSMinY(aRect)) toPoint:NSMakePoint(NSMaxX(aRect),NSMaxY(aRect)) radius:radius];
        [bezier lineToPoint: NSMakePoint(NSMaxX(aRect),NSMaxY(aRect))];
    } else {

        [bezier lineToPoint: NSMakePoint(NSMaxX(aRect),NSMinY(aRect))];
        if (mask & MMBezierShapeFillPath)
            [bezier lineToPoint: NSMakePoint(NSMaxX(aRect),NSMaxY(aRect))];
    }
    
    return bezier;
}

+ (NSBezierPath *)bezierPathWithCardInRect:(NSRect)aRect radius:(CGFloat)radius borderMask:(MMBezierShapeCapMask)mask {

    NSBezierPath *bezier = [self _bezierPathWithCardInRect:aRect radius:radius borderMask:mask];

        // Flip the final NSBezierPath.
    if (mask & MMBezierShapeFlippedVertically)
        [bezier transformUsingAffineTransform:[[NSAffineTransform transform] mm_flipVertical:[bezier bounds]]];
    
    return bezier;
}

@end
