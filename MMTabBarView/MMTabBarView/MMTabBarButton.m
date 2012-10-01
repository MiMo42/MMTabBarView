//
//  MMTabBarButton.m
//  MMTabBarView
//
//  Created by Michael Monscheuer on 9/5/12.
//
//

#import "MMTabBarButton.h"
#import "MMRolloverButton.h"
#import "MMTabBarButtonCell.h"
#import "MMTabBarView.h"
#import "MMTabDragAssistant.h"
#import "NSView+MMTabBarViewExtensions.h"

// Pointer value that we use as the binding context
NSString *kMMTabBarButtonOberserverContext = @"MMTabBarView.MMTabBarButton.ObserverContext";

@interface MMTabBarButton (/*Private*/)

- (void)_commonInit;
- (NSRect)_closeButtonRectForBounds:(NSRect)bounds;
- (NSRect)_indicatorRectForBounds:(NSRect)bounds;

@end

@implementation MMTabBarButton

@synthesize stackingFrame = _stackingFrame;
@synthesize closeButton = _closeButton;
@dynamic closeButtonAction;
@synthesize indicator = _indicator;

+ (void)initialize {
    [super initialize];
    
    [self exposeBinding:@"isProcessing"];
    [self exposeBinding:@"isEdited"];    
    [self exposeBinding:@"objectCount"];
    [self exposeBinding:@"objectCountColor"];
    [self exposeBinding:@"icon"];
    [self exposeBinding:@"largeImage"];
    [self exposeBinding:@"hasCloseButton"];
}

+ (Class)cellClass {
    return [MMTabBarButtonCell class];
}

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self _commonInit];
    }
    
    return self;
}

- (void)dealloc
{
    [_closeButton release], _closeButton = nil;
    [_indicator release], _indicator = nil;    
    [super dealloc];
}

- (MMTabBarButtonCell *)cell {
    return (MMTabBarButtonCell *)[super cell];
}

- (void)setCell:(MMTabBarButtonCell *)aCell {
    [super setCell:aCell];
}

- (MMTabBarView *)tabBarView {
    return [self enclosingTabBarView];
}
    
- (void)resizeSubviewsWithOldSize:(NSSize)oldSize {

    [super resizeSubviewsWithOldSize:oldSize];
    
        // We do not call -calcSize before drawing (as documented).
        // We only need to calculate size when resizing.
    [self calcSize];
}

- (void)calcSize {

        // Let cell update (invokes -calcDrawInfo:)
        // Cell will update control's sub buttons too.
    [[self cell] calcDrawInfo:[self bounds]];
}

- (NSMenu *)menuForEvent:(NSEvent *)event {

    MMTabBarView *tabBarView = [self tabBarView];
    
    return [tabBarView menuForTabBarButton:self withEvent:event];
}

- (void)updateCell {    
    [self updateCell:[self cell]];
}

#pragma mark -
#pragma mark Accessors

- (SEL)closeButtonAction {

    @synchronized(self) {
        return [_closeButton action];
    }
}

- (void)setCloseButtonAction:(SEL)closeButtonAction {

    @synchronized(self) {
        [_closeButton setAction:closeButtonAction];
    }
}

#pragma mark -
#pragma mark Dividers

- (BOOL)shouldDisplayLeftDivider {

    MMTabStateMask tabStateMask = [self tabState];
    
    BOOL retVal = NO;
    if (tabStateMask & MMTab_LeftIsSliding)
        retVal = YES;

    return retVal;
}

- (BOOL)shouldDisplayRightDivider {

    MMTabStateMask tabStateMask = [self tabState];
    
    BOOL retVal = NO;
    if (tabStateMask & MMTab_RightIsSliding)
        retVal = YES;

    return retVal;
}

#pragma mark -
#pragma mark Determine Sizes

- (CGFloat)minimumWidth {
    return [[self cell] minimumWidthOfCell];
}

- (CGFloat)desiredWidth {
    return [[self cell] desiredWidthOfCell];
}

#pragma mark -
#pragma mark Interfacing Cell

- (id <MMTabStyle>)style {
    return [[self cell] style];
}

- (void)setStyle:(id <MMTabStyle>)newStyle {
    [[self cell] setStyle:newStyle];
    [self updateCell];
}

- (MMTabStateMask)tabState {
    return [[self cell] tabState];
}

- (void)setTabState:(MMTabStateMask)newState {

    [[self cell] setTabState:newState];
    [self updateCell];
}

- (BOOL)shouldDisplayCloseButton {
    return [[self cell] shouldDisplayCloseButton];
}

- (BOOL)hasCloseButton {
    return [[self cell] hasCloseButton];
}

- (void)setHasCloseButton:(BOOL)newState {
    [[self cell] setHasCloseButton:newState];
    [self updateCell];
}

- (BOOL)suppressCloseButton {
    return [[self cell] suppressCloseButton];
}

- (void)setSuppressCloseButton:(BOOL)newState {
    [[self cell] setSuppressCloseButton:newState];
    [self updateCell];
}

- (NSImage *)icon {
    return [[self cell] icon];
}

- (void)setIcon:(NSImage *)anIcon {
    [[self cell] setIcon:anIcon];
    [self updateCell];
}

- (NSImage *)largeImage {
    return [[self cell] largeImage];
}

- (void)setLargeImage:(NSImage *)anImage {
    [[self cell] setLargeImage:anImage];
    [self updateCell];
}

- (BOOL)showObjectCount {
    return [[self cell] showObjectCount];
}

- (void)setShowObjectCount:(BOOL)newState {
    [[self cell] setShowObjectCount:newState];
    [self updateCell];
}

- (NSInteger)objectCount {
    return [[self cell] objectCount];
}

- (void)setObjectCount:(NSInteger)newCount {
    [[self cell] setObjectCount:newCount];
    [self updateCell];
}

- (NSColor *)objectCountColor {
    return [[self cell] objectCountColor];
}

- (void)setObjectCountColor:(NSColor *)newColor {
    [[self cell] setObjectCountColor:newColor];
    [self updateCell];
}

- (BOOL)isEdited {
    return [[self cell] isEdited];
}

- (void)setIsEdited:(BOOL)newState {
    [[self cell] setIsEdited:newState];
    [self updateCell];
}

- (BOOL)isProcessing {
    return [[self cell] isProcessing];
}

- (void)setIsProcessing:(BOOL)newState {
    [[self cell] setIsProcessing:newState];
    [self updateCell];
}

- (void)updateImages {
    [[self cell] updateImages];
}

#pragma mark -
#pragma mark Bindings

- (void)bind:(NSString *)binding toObject:(id)observable withKeyPath:(NSString *)keyPath options:(NSDictionary *)options 
{
    if ([binding isEqualToString:@"objectCount"])
        {
        _objectCountBindingObservedObject = [observable retain];
        _objectCountBindingKeyPath = [keyPath copy];
        _objectCountBindingOptions = [options copy];
        
        [_objectCountBindingObservedObject addObserver:self forKeyPath:_objectCountBindingKeyPath options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew context:kMMTabBarButtonOberserverContext];
        }
    else if ([binding isEqualToString:@"objectCountColor"])
        {
        _objectCountColorBindingObservedObject = [observable retain];
        _objectCountColorBindingKeyPath = [keyPath copy];
        _objectCountColorBindingOptions = [options copy];
        
        [_objectCountColorBindingObservedObject addObserver:self forKeyPath:_objectCountColorBindingKeyPath options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew context:kMMTabBarButtonOberserverContext];
        }         
    else if ([binding isEqualToString:@"isProcessing"])
        {
        _isProcessingBindingObservedObject = [observable retain];
        _isProcessingBindingKeyPath = [keyPath copy];
        _isProcessingBindingOptions = [options copy];        
        
        [_isProcessingBindingObservedObject addObserver:self forKeyPath:_isProcessingBindingKeyPath options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew context:kMMTabBarButtonOberserverContext];
        }
    else if ([binding isEqualToString:@"isEdited"])
        {
        _isEditedBindingObservedObject = [observable retain];
        _isEditedBindingKeyPath = [keyPath copy];
        _isEditedBindingOptions = [options copy];
        
        [_isEditedBindingObservedObject addObserver:self forKeyPath:_isEditedBindingKeyPath options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew context:kMMTabBarButtonOberserverContext];
        }        
    else if ([binding isEqualToString:@"icon"])
        {
        _iconBindingObservedObject = [observable retain];
        _iconBindingKeyPath = [keyPath copy];
        _iconBindingOptions = [options copy];
        
        [_iconBindingObservedObject addObserver:self forKeyPath:_iconBindingKeyPath options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew context:kMMTabBarButtonOberserverContext];
        }
    else if ([binding isEqualToString:@"largeImage"])
        {
        _largeImageBindingObservedObject = [observable retain];
        _largeImageBindingKeyPath = [keyPath copy];
        _largeImageBindingOptions = [options copy];
        
        [_largeImageBindingObservedObject addObserver:self forKeyPath:_largeImageBindingKeyPath options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew context:kMMTabBarButtonOberserverContext];
        }
    else if ([binding isEqualToString:@"hasCloseButton"])
        {
        _hasCloseButtonBindingObservedObject = [observable retain];
        _hasCloseButtonBindingKeyPath = [keyPath copy];
        _hasCloseButtonBindingOptions = [options copy];
        
        [_hasCloseButtonBindingObservedObject addObserver:self forKeyPath:_hasCloseButtonBindingKeyPath options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew context:kMMTabBarButtonOberserverContext];
        }                 
    else 
        [super bind:binding toObject:observable withKeyPath:keyPath options:options];

}  // -bind:toObject:withKeyPath:options:

- (void)unbind:(NSString *)binding 
{
    if ([binding isEqualToString:@"objectCount"]) 
        {
        [_objectCountBindingObservedObject removeObserver:self forKeyPath:_objectCountBindingKeyPath];
        [_objectCountBindingObservedObject release], _objectCountBindingObservedObject = nil;
        [_objectCountBindingKeyPath release], _objectCountBindingKeyPath = nil;
        [_objectCountBindingOptions release], _objectCountBindingOptions = nil;
        }
    if ([binding isEqualToString:@"objectCountColor"]) 
        {
        [_objectCountColorBindingObservedObject removeObserver:self forKeyPath:_objectCountColorBindingKeyPath];
        [_objectCountColorBindingObservedObject release], _objectCountColorBindingObservedObject = nil;
        [_objectCountColorBindingKeyPath release], _objectCountColorBindingKeyPath = nil;
        [_objectCountColorBindingOptions release], _objectCountColorBindingOptions = nil;
        }        
    else if ([binding isEqualToString:@"isProcessing"])
        {
        [_isProcessingBindingObservedObject removeObserver:self forKeyPath:_isProcessingBindingKeyPath];
        [_isProcessingBindingObservedObject release], _isProcessingBindingObservedObject = nil;
        [_isProcessingBindingKeyPath release], _isProcessingBindingKeyPath = nil;
        [_isProcessingBindingOptions release], _isProcessingBindingOptions = nil;
        }
    else if ([binding isEqualToString:@"isEdited"])
        {
        [_isEditedBindingObservedObject removeObserver:self forKeyPath:_isEditedBindingKeyPath];
        [_isEditedBindingObservedObject release], _isEditedBindingObservedObject = nil;
        [_isEditedBindingKeyPath release], _isEditedBindingKeyPath = nil;
        [_isEditedBindingOptions release], _isEditedBindingOptions = nil;
        }        
    else if ([binding isEqualToString:@"icon"])
        {
        [_iconBindingObservedObject removeObserver:self forKeyPath:_iconBindingKeyPath];
        [_iconBindingObservedObject release], _iconBindingObservedObject = nil;
        [_iconBindingKeyPath release], _iconBindingKeyPath = nil;
        [_iconBindingOptions release], _iconBindingOptions = nil;
        }
    else if ([binding isEqualToString:@"largeImage"])
        {
        [_largeImageBindingObservedObject removeObserver:self forKeyPath:_largeImageBindingKeyPath];
        [_largeImageBindingObservedObject release], _largeImageBindingObservedObject = nil;
        [_largeImageBindingKeyPath release], _largeImageBindingKeyPath = nil;
        [_largeImageBindingOptions release], _largeImageBindingOptions = nil;
        }
    else if ([binding isEqualToString:@"hasCloseButton"])
        {
        [_hasCloseButtonBindingObservedObject removeObserver:self forKeyPath:_hasCloseButtonBindingKeyPath];
        [_hasCloseButtonBindingObservedObject release], _hasCloseButtonBindingObservedObject = nil;
        [_hasCloseButtonBindingKeyPath release], _hasCloseButtonBindingKeyPath = nil;
        [_hasCloseButtonBindingOptions release], _hasCloseButtonBindingOptions = nil;
        }           
    else
        [super unbind:binding];

}  // -unbind:

-(NSDictionary *)infoForBinding:(NSString *)binding
{
    if ([binding isEqualToString:@"objectCount"])
        {
        return [NSDictionary dictionaryWithObjectsAndKeys:
                _objectCountBindingObservedObject, NSObservedObjectKey,
                _objectCountBindingKeyPath, NSObservedKeyPathKey,
                _objectCountBindingOptions, NSOptionsKey,
                nil];
        }
    if ([binding isEqualToString:@"objectCountColor"])
        {
        return [NSDictionary dictionaryWithObjectsAndKeys:
                _objectCountColorBindingObservedObject, NSObservedObjectKey,
                _objectCountColorBindingKeyPath, NSObservedKeyPathKey,
                _objectCountColorBindingOptions, NSOptionsKey,
                nil];
        }        
    else if ([binding isEqualToString:@"isProcessing"]) 
        {
        return [NSDictionary dictionaryWithObjectsAndKeys:
                _isProcessingBindingObservedObject, NSObservedObjectKey,
                _isProcessingBindingKeyPath, NSObservedKeyPathKey,
                _isProcessingBindingOptions, NSOptionsKey,
                nil];
        }
    else if ([binding isEqualToString:@"isEdited"]) 
        {
        return [NSDictionary dictionaryWithObjectsAndKeys:
                _isEditedBindingObservedObject, NSObservedObjectKey,
                _isEditedBindingKeyPath, NSObservedKeyPathKey,
                _isEditedBindingOptions, NSOptionsKey,
                nil];
        }        
    else if ([binding isEqualToString:@"icon"])
        {
        return [NSDictionary dictionaryWithObjectsAndKeys:
                _iconBindingObservedObject, NSObservedObjectKey,
                _iconBindingKeyPath, NSObservedKeyPathKey,
                _iconBindingOptions, NSOptionsKey,
                nil];
        }
    else if ([binding isEqualToString:@"largeImage"])
        {
        return [NSDictionary dictionaryWithObjectsAndKeys:
                _largeImageBindingObservedObject, NSObservedObjectKey,
                _largeImageBindingKeyPath, NSObservedKeyPathKey,
                _largeImageBindingOptions, NSOptionsKey,
                nil];
        }
    else if ([binding isEqualToString:@"hasCloseButton"]) 
        {
        return [NSDictionary dictionaryWithObjectsAndKeys:
                _hasCloseButtonBindingObservedObject, NSObservedObjectKey,
                _hasCloseButtonBindingKeyPath, NSObservedKeyPathKey,
                _hasCloseButtonBindingOptions, NSOptionsKey,
                nil];
        }            
    else
        return [super infoForBinding:binding];
}  // -infoForBinding:

#pragma mark -
#pragma mark NSKeyValueObserving

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context 
{
    if ([keyPath isEqualTo:_objectCountBindingKeyPath] && context == kMMTabBarButtonOberserverContext) {
    
        id objectCountValue = nil;
    
        switch([[change objectForKey:NSKeyValueChangeKindKey] integerValue]) {
            case NSKeyValueChangeSetting:
            
                objectCountValue = [object valueForKeyPath:_objectCountBindingKeyPath];
                if (objectCountValue == NSNoSelectionMarker) {
                    [self setObjectCount:0.f];
                } else if ([objectCountValue isKindOfClass:[NSNumber class]]) {
                    NSValueTransformer *valueTransformer = nil;                
                    NSString *valueTransformerName = [_objectCountBindingOptions objectForKey:NSValueTransformerNameBindingOption];
                    if (valueTransformerName != nil)
                        valueTransformer = [NSValueTransformer valueTransformerForName:valueTransformerName];

                    if (valueTransformer == nil)
                        valueTransformer = [_objectCountBindingOptions objectForKey:NSValueTransformerBindingOption];
                        
                    if (valueTransformer != nil)
                        objectCountValue = [valueTransformer transformedValue:objectCountValue];
                                        
                    [self setObjectCount:[objectCountValue integerValue]];
                } else {
                    [self setObjectCount:0];
                }

                id autoHideValue = [_objectCountBindingOptions objectForKey:NSConditionallySetsHiddenBindingOption];
                if (autoHideValue != nil)
                    {
                    if ([autoHideValue boolValue] == YES)
                        {
                        if (objectCountValue == NSNoSelectionMarker || objectCountValue == nil || [objectCountValue integerValue] == 0)
                            [self setShowObjectCount:NO];
                        else
                            [self setShowObjectCount:YES];
                        }
                    }
                else
                    [self setShowObjectCount:YES];
                break;
            
            default:
                break;

        }
    } else if ([keyPath isEqualTo:_objectCountColorBindingKeyPath] && context == kMMTabBarButtonOberserverContext) {

        NSColor *color = nil;
    
        switch([[change objectForKey:NSKeyValueChangeKindKey] integerValue]) {
            case NSKeyValueChangeSetting:
                
                color = [object valueForKeyPath:_objectCountColorBindingKeyPath];
                if (color == NSNoSelectionMarker) {
                    [self setObjectCountColor:nil];
                    }
                else if ([color isKindOfClass:[NSColor class]]) {
                    [self setObjectCountColor:color];
                    }
                else
                    [self setObjectCountColor:nil];
                break;
            
            default:
                break;

        }        
    } else if ([keyPath isEqualTo:_isProcessingBindingKeyPath] && context == kMMTabBarButtonOberserverContext) {

        id isProcessingValue = nil;
    
        switch([[change objectForKey:NSKeyValueChangeKindKey] integerValue]) {
            case NSKeyValueChangeSetting:
                
                isProcessingValue = [object valueForKeyPath:_isProcessingBindingKeyPath];
                if (isProcessingValue == NSNoSelectionMarker) {
                    [self setIsProcessing:NO];
                    }
                else if ([isProcessingValue isKindOfClass:[NSNumber class]]) {

                    NSValueTransformer *valueTransformer = nil;                
                    NSString *valueTransformerName = [_isProcessingBindingOptions objectForKey:NSValueTransformerNameBindingOption];
                    if (valueTransformerName != nil)
                        valueTransformer = [NSValueTransformer valueTransformerForName:valueTransformerName];

                    if (valueTransformer == nil)
                        valueTransformer = [_isProcessingBindingOptions objectForKey:NSValueTransformerBindingOption];
                        
                    if (valueTransformer != nil)
                        isProcessingValue = [valueTransformer transformedValue:isProcessingValue];

                    BOOL newIsProcessingState = NO;
                    if (isProcessingValue != nil)
                        newIsProcessingState = [isProcessingValue boolValue];
                    else
                        newIsProcessingState = NO;
                                        
                    [self setIsProcessing:newIsProcessingState];
                    }
                else
                    [self setIsProcessing:NO];
                break;
            
            default:
                break;

        }
    } else if ([keyPath isEqualTo:_isEditedBindingKeyPath] && context == kMMTabBarButtonOberserverContext) {

        id isEditedValue = nil;
    
        switch([[change objectForKey:NSKeyValueChangeKindKey] integerValue]) {
            case NSKeyValueChangeSetting:
                
                isEditedValue = [object valueForKeyPath:_isEditedBindingKeyPath];
                if (isEditedValue == NSNoSelectionMarker) {
                    [self setIsEdited:NO];
                    }
                else if ([isEditedValue isKindOfClass:[NSNumber class]]) {

                    NSValueTransformer *valueTransformer = nil;                
                    NSString *valueTransformerName = [_isEditedBindingOptions objectForKey:NSValueTransformerNameBindingOption];
                    if (valueTransformerName != nil)
                        valueTransformer = [NSValueTransformer valueTransformerForName:valueTransformerName];

                    if (valueTransformer == nil)
                        valueTransformer = [_isEditedBindingOptions objectForKey:NSValueTransformerBindingOption];
                        
                    if (valueTransformer != nil)
                        isEditedValue = [valueTransformer transformedValue:isEditedValue];

                    BOOL newIsEditedState = NO;
                    if (isEditedValue != nil)
                        newIsEditedState = [isEditedValue boolValue];
                    else
                        newIsEditedState = NO;
                                        
                    [self setIsEdited:newIsEditedState];
                    }
                else
                    [self setIsEdited:NO];
                break;
            
            default:
                break;

        }        
    } else if ([keyPath isEqualTo:_iconBindingKeyPath] && context == kMMTabBarButtonOberserverContext) {

        NSImage *icon = nil;
    
        switch([[change objectForKey:NSKeyValueChangeKindKey] integerValue]) {
            case NSKeyValueChangeSetting:
                
                icon = [object valueForKeyPath:_iconBindingKeyPath];
                if (icon == NSNoSelectionMarker) {
                    [self setIcon:nil];
                    }
                else if ([icon isKindOfClass:[NSImage class]]) {
                    [self setIcon:icon];
                    }
                else
                    [self setIcon:nil];
                break;
            
            default:
                break;

        }
    } else if ([keyPath isEqualTo:_largeImageBindingKeyPath] && context == kMMTabBarButtonOberserverContext) {

        NSImage *largeImage = nil;
    
        switch([[change objectForKey:NSKeyValueChangeKindKey] integerValue]) {
            case NSKeyValueChangeSetting:
                
                largeImage = [object valueForKeyPath:_largeImageBindingKeyPath];
                if (largeImage == NSNoSelectionMarker) {
                    [self setLargeImage:nil];
                    }
                else if ([largeImage isKindOfClass:[NSImage class]]) {
                    [self setLargeImage:largeImage];
                    }
                else
                    [self setLargeImage:nil];
                break;
            
            default:
                break;

        }
    } else if ([keyPath isEqualTo:_hasCloseButtonBindingKeyPath] && context == kMMTabBarButtonOberserverContext) {

        id hasCloseButtonValue = nil;
    
        switch([[change objectForKey:NSKeyValueChangeKindKey] integerValue]) {
            case NSKeyValueChangeSetting:
                
                hasCloseButtonValue = [object valueForKeyPath:_hasCloseButtonBindingKeyPath];
                if (hasCloseButtonValue == NSNoSelectionMarker) {
                    [self setHasCloseButton:NO];
                    }
                else if ([hasCloseButtonValue isKindOfClass:[NSNumber class]]) {

                    NSValueTransformer *valueTransformer = nil;                
                    NSString *valueTransformerName = [_hasCloseButtonBindingOptions objectForKey:NSValueTransformerNameBindingOption];
                    if (valueTransformerName != nil)
                        valueTransformer = [NSValueTransformer valueTransformerForName:valueTransformerName];

                    if (valueTransformer == nil)
                        valueTransformer = [_hasCloseButtonBindingOptions objectForKey:NSValueTransformerBindingOption];
                        
                    if (valueTransformer != nil)
                        hasCloseButtonValue = [valueTransformer transformedValue:hasCloseButtonValue];

                    BOOL newState = NO;
                    if (hasCloseButtonValue != nil)
                        newState = [hasCloseButtonValue boolValue];
                    else
                        newState = NO;
                                        
                    [self setHasCloseButton:newState];
                    }
                else
                    [self setHasCloseButton:NO];
                break;
            
            default:
                break;

        }                
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}  // -observeValueForKeyPath:ofObject:change:context:

#pragma mark -
#pragma mark Private Methods

- (void)_commonInit {

    NSRect closeButtonRect = [self _closeButtonRectForBounds:[self bounds]];
    _closeButton = [[MMRolloverButton alloc] initWithFrame:closeButtonRect];
    
    [_closeButton setTitle:@""];
    [_closeButton setImagePosition:NSImageOnly];
    [_closeButton setRolloverButtonType:MMRolloverActionButton];
    [_closeButton setBordered:NO];
    [_closeButton setBezelStyle:NSShadowlessSquareBezelStyle];
    [self addSubview:_closeButton];

    _indicator = [[MMProgressIndicator alloc] initWithFrame:NSMakeRect(0.0, 0.0, kMMTabBarIndicatorWidth, kMMTabBarIndicatorWidth)];
    [_indicator setStyle:NSProgressIndicatorSpinningStyle];
    [_indicator setAutoresizingMask:NSViewMinYMargin];
    [_indicator setControlSize: NSSmallControlSize];
    NSRect indicatorRect = [self _indicatorRectForBounds:[self bounds]];
    [_indicator setFrame:indicatorRect];
    [self addSubview:_indicator];
}

- (NSRect)_closeButtonRectForBounds:(NSRect)bounds {
    return [[self cell] closeButtonRectForBounds:bounds];
}

- (NSRect)_indicatorRectForBounds:(NSRect)bounds {
    return [[self cell] indicatorRectForBounds:bounds];
}

@end