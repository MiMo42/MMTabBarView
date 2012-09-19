//
//  MMTabBarButton.h
//  MMTabBarView
//
//  Created by Michael Monscheuer on 9/5/12.
//
//

#import <Cocoa/Cocoa.h>

#import "MMTabBarView.h"
#import "MMRolloverButton.h"
#import "MMProgressIndicator.h"
#import "MMTabBarButtonCell.h"

@class MMTabBarView;

@protocol MMTabStyle;

@interface MMTabBarButton : MMRolloverButton {

        // the layouted frame rect
    NSRect _stackingFrame;
    
        // close button
    MMRolloverButton *_closeButton;
    
        // progress indicator
	MMProgressIndicator    *_indicator;
    
        // binding related
    id _isProcessingBindingObservedObject;
    NSString *_isProcessingBindingKeyPath;
    NSDictionary *_isProcessingBindingOptions;
    
    id _isEditedBindingObservedObject;
    NSString *_isEditedBindingKeyPath;
    NSDictionary *_isEditedBindingOptions;
    
    id _objectCountBindingObservedObject;
    NSString *_objectCountBindingKeyPath;
    NSDictionary *_objectCountBindingOptions;

    id _objectCountColorBindingObservedObject;
    NSString *_objectCountColorBindingKeyPath;
    NSDictionary *_objectCountColorBindingOptions;
    
    id _iconBindingObservedObject;
    NSString *_iconBindingKeyPath;
    NSDictionary *_iconBindingOptions;
    
    id _largeImageBindingObservedObject;
    NSString *_largeImageBindingKeyPath;
    NSDictionary *_largeImageBindingOptions;
    
    id _hasCloseButtonBindingObservedObject;
    NSString *_hasCloseButtonBindingKeyPath;
    NSDictionary *_hasCloseButtonBindingOptions;    
}

@property (assign) NSRect stackingFrame;
@property (retain) MMRolloverButton *closeButton;
@property (assign) SEL closeButtonAction;
@property (readonly, retain) MMProgressIndicator *indicator;

- (id)initWithFrame:(NSRect)frame;

- (MMTabBarButtonCell *)cell;
- (void)setCell:(MMTabBarButtonCell *)aCell;

- (MMTabBarView *)tabBarView;

- (void)updateCell;

#pragma mark Determine Sizes

- (CGFloat)minimumWidth;
- (CGFloat)desiredWidth;

#pragma mark Interfacing Cell

- (id <MMTabStyle>)style;
- (void)setStyle:(id <MMTabStyle>)newStyle;

- (MMTabStateMask)tabState;
- (void)setTabState:(MMTabStateMask)newState;

- (NSImage *)icon;
- (void)setIcon:(NSImage *)anIcon;
- (NSImage *)largeImage;
- (void)setLargeImage:(NSImage *)anImage;
- (BOOL)showObjectCount;
- (void)setShowObjectCount:(BOOL)newState;
- (NSInteger)objectCount;
- (void)setObjectCount:(NSInteger)newCount;
- (NSColor *)objectCountColor;
- (void)setObjectCountColor:(NSColor *)newColor;
- (BOOL)isEdited;
- (void)setIsEdited:(BOOL)newState;
- (BOOL)isProcessing;
- (void)setIsProcessing:(BOOL)newState;

#pragma Close Button Support

- (BOOL)shouldDisplayCloseButton;

- (BOOL)hasCloseButton;
- (void)setHasCloseButton:(BOOL)newState;

- (BOOL)suppressCloseButton;
- (void)setSuppressCloseButton:(BOOL)newState;

@end
