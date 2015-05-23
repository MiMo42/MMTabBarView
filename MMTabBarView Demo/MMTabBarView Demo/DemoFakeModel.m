//
//  FakeModel.m
//  MMTabBarView Demo
//
//  Created by John Pannell on 12/19/05.
//  Copyright 2005 Positive Spin Media. All rights reserved.
//

#import "DemoFakeModel.h"

@implementation DemoFakeModel

@synthesize title = _title;
@synthesize largeImage = _largeImage;
@synthesize icon = _icon;
@synthesize iconName = _iconName;

@synthesize isProcessing = _isProcessing;
@synthesize objectCount = _objectCount;
@synthesize objectCountColor = _objectCountColor;
@synthesize showObjectCount = _showObjectCount;
@synthesize isEdited = _isEdited;
@synthesize hasCloseButton = _hasCloseButton;

- (instancetype)init {
	if (self = [super init]) {
		_isProcessing = NO;
		_icon = nil;
		_iconName = nil;
        _largeImage = nil;
		_objectCount = 2;
		_isEdited = NO;
        _hasCloseButton = YES;
        _title = @"Untitled";
        _objectCountColor = nil;
        _showObjectCount = YES;
	}
	return self;
}

-(void)dealloc {
    
    _title = nil;
    _icon = nil;
    _iconName = nil;
    _largeImage = nil;
    _objectCountColor = nil;

}

@end
