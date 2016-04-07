//
//  MMTabPasteboardItem.h
//  MMTabBarView
//
//  Created by Michael Monscheuer on 9/11/12.
//
//

#import <Cocoa/Cocoa.h>

@class MMAttachedTabBarButton;
@class MMTabBarView;

@interface MMTabPasteboardItem : NSPasteboardItem 

@property (assign) NSUInteger sourceIndex;

@end
