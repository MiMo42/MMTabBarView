//
//  MMTabBarView.Private.h
//  MMTabBarView
//
//  Created by Michael Monscheuer on 23/05/15.
//  Copyright (c) 2016 Michael Monscheuer. All rights reserved.
//

@interface MMTabBarView (PrivateDrawing)

- (void)_drawInteriorInRect:(NSRect)rect;

@property (readonly) NSRect _addTabButtonRect;
@property (readonly) NSRect _overflowButtonRect;

@property (assign) BOOL isReorderingTabViewItems;

@end
