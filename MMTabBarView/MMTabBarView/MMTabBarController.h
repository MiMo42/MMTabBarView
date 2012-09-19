//
//  MMTabBarViewler.h
//  MMTabBarView
//
//  Created by Kent Sutherland on 11/24/06.
//  Copyright 2006 Kent Sutherland. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class MMTabBarView, MMAttachedTabBarButton;

@interface MMTabBarController : NSObject <NSMenuDelegate>
{
	MMTabBarView	*_control;
	NSMenu				*_overflowMenu;
}

- (id)initWithTabBarView:(MMTabBarView *)control;

- (NSMenu *)overflowMenu;

- (void)layoutButtons;

@end
