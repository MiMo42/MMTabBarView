//
//  MMOverflowPopUpButton.h
//  MMTabBarView
//
//  Created by John Pannell on 11/4/05.
//  Copyright 2005 Positive Spin Media. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>

typedef void (^MMCellBezelDrawingBlock)(NSCell *cell, NSRect frame, NSView *controlView);

@interface MMOverflowPopUpButton : NSPopUpButton {
}

@property (strong) NSImage *secondImage;

// bezel drawing
- (MMCellBezelDrawingBlock)bezelDrawingBlock;
- (void)setBezelDrawingBlock:(MMCellBezelDrawingBlock)aBlock;

@end
