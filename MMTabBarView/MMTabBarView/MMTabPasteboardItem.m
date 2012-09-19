//
//  MMTabPasteboardItem.m
//  MMTabBarView
//
//  Created by Michael Monscheuer on 9/11/12.
//
//

#import "MMTabPasteboardItem.h"

@implementation MMTabPasteboardItem

@synthesize sourceTabBar = _sourceTabBar;
@synthesize attachedTabBarButton = _attachedTabBarButton;
@synthesize sourceIndex = _sourceIndex;

- (id)init {
    self = [super init];
    if (self) {
        _sourceTabBar = nil;
        _attachedTabBarButton = nil;
        _sourceIndex = NSNotFound;
    }
    return self;
}

- (void)dealloc
{
    [_sourceTabBar release], _sourceTabBar = nil;
    [_attachedTabBarButton release], _attachedTabBarButton = nil;
    
    [super dealloc];
}

@end
