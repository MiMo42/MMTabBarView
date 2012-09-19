//
//  MMCardTabStyle.h
//  MMTabBarView
//
//  Created by Michael Monscheuer on 9/3/12.
//
//

#import <Cocoa/Cocoa.h>
#import "MMTabStyle.h"

@interface MMCardTabStyle : NSObject <MMTabStyle>
{
    NSImage *cardCloseButton;
    NSImage *cardCloseButtonDown;
    NSImage *cardCloseButtonOver;
    NSImage *cardCloseDirtyButton;
    NSImage *cardCloseDirtyButtonDown;
    NSImage *cardCloseDirtyButtonOver;
    NSImage *_addTabButtonImage;
    NSImage *_addTabButtonPressedImage;
    NSImage *_addTabButtonRolloverImage;
	    
    CGFloat _horizontalInset;
    CGFloat _topMargin;
}

@property (assign) CGFloat horizontalInset;
@property (assign) CGFloat topMargin;

@end
