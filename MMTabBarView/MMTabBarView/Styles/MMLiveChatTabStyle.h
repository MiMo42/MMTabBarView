//
//  MMLiveChatTabStyle.h
//  --------------------
//
//  Created by Keith Blount on 30/04/2006.
//  Copyright 2006 Keith Blount. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MMTabStyle.h"

@interface MMLiveChatTabStyle : NSObject <MMTabStyle> {
	NSImage				*liveChatCloseButton;
	NSImage				*liveChatCloseButtonDown;
	NSImage				*liveChatCloseButtonOver;
	NSImage				*liveChatCloseDirtyButton;
	NSImage				*liveChatCloseDirtyButtonDown;
	NSImage				*liveChatCloseDirtyButtonOver;

	NSDictionary		*_objectCountStringAttributes;

	CGFloat				_leftMargin;
}

@property (assign) CGFloat leftMarginForTabBarView;

@end
