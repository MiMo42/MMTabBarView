//
//  MMTabBarView.Private.h
//  MMTabBarView
//
//  Created by Michael Monscheuer on 23/05/15.
//  Copyright (c) 2015 Michael Monscheuer. All rights reserved.
//

@interface MMTabBarView (PrivateDrawing)

- (void)_drawInteriorInRect:(NSRect)rect;
- (NSRect)_addTabButtonRect;
- (NSRect)_overflowButtonRect;

@end
