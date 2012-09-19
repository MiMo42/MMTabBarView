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

- (id)init {
	if ((self = [super init])) {
		
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
