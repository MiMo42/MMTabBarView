//
//  MMYosemiteTabStyle.h
//  --------------------
//
//  Based on MMUnifiedTabStyle.h by Keith Blount
//  Created by Ajin Man Tuladhar on 04/11/2014.
//  Copyright 2014 Ajin Man Tuladhar. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MMTabStyle.h"

@interface MMYosemiteTabStyle : NSObject <MMTabStyle> {
    
    NSImage				*YosemiteCloseButton;
    NSImage				*YosemiteCloseButtonDown;
    NSImage				*YosemiteCloseButtonOver;
    NSImage				*YosemiteCloseDirtyButton;
    NSImage				*YosemiteCloseDirtyButtonDown;
    NSImage				*YosemiteCloseDirtyButtonOver;
    NSImage             *TabNewYosemite;
    
    CGFloat				_leftMargin;
}

@property (assign) CGFloat leftMarginForTabBarView;

@end