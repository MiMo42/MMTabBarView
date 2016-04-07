//
//  MMOverflowPopUpButtonCell.h
//  MMTabBarView
//
//  Created by Michael Monscheuer on 9/24/12.
//  Copyright (c) 2016 Michael Monscheuer. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "MMOverflowPopUpButton.h"

@class MMImageTransitionAnimation;

@interface MMOverflowPopUpButtonCell : NSPopUpButtonCell <NSAnimationDelegate>

@property (copy) MMCellBezelDrawingBlock bezelDrawingBlock;
@property (strong) NSImage *image;
@property (strong) NSImage *secondImage;
@property (assign) CGFloat secondImageAlpha;

- (void)drawImage:(NSImage *)image withFrame:(NSRect)frame inView:(NSView *)controlView alpha:(CGFloat)alpha;

@end
