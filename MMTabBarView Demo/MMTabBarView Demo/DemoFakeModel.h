//
//  FakeModel.h
//  MMTabBarView Demo
//
//  Created by John Pannell on 12/19/05.
//  Copyright 2005 Positive Spin Media. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface DemoFakeModel : NSObject {
	BOOL        _isProcessing;
	NSImage     *_icon;
    NSImage     *_largeImage;
	NSString    *_iconName;
	NSInteger   _objectCount;
	BOOL        _isEdited;
    BOOL        _hasCloseButton;
}

@property (retain) NSImage *largeImage;
@property (retain) NSImage *icon;
@property (retain) NSString *iconName;

@property (assign) BOOL isProcessing;
@property (assign) NSInteger objectCount;
@property (assign) BOOL isEdited;
@property (assign) BOOL hasCloseButton;

// designated initializer
- (id)init;

@end
