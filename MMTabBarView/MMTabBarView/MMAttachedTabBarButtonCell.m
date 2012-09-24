//
//  MMAttachedTabBarButtonCell.m
//  MMTabBarView
//
//  Created by Michael Monscheuer on 9/5/12.
//
//

#import "MMAttachedTabBarButtonCell.h"

#import "MMAttachedTabBarButton.h"

@implementation MMAttachedTabBarButtonCell

@synthesize isOverflowButton = _isOverflowButton;

- (id)init {
	if ((self = [super init])) {
        _isOverflowButton = NO;		
	}
	return self;
}

- (void)dealloc {
    [super dealloc];
}

- (MMAttachedTabBarButton *)controlView {
    return (MMAttachedTabBarButton *)[super controlView];
}

- (void)setControlView:(MMAttachedTabBarButton *)aView {
    [super setControlView:aView];
}

@end
