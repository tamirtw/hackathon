//
//  TWOverlayView.h
//  Facedoor
//
//  Created by Twina, Tamir [ICG-IT] on 2/18/14.
//  Copyright (c) 2014 Twina, Tamir [ICG-IT]. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger , TWOverlayViewMode) {
    TWOverlayViewModeLeft,
    TWOverlayViewModeRight
};

@class TWDraggableView;

@interface TWOverlayView : UIView
@property (nonatomic) TWOverlayViewMode mode;
@end
