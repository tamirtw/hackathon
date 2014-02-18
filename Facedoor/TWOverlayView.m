//
//  TWOverlayView.m
//  Facedoor
//
//  Created by Twina, Tamir [ICG-IT] on 2/18/14.
//  Copyright (c) 2014 Twina, Tamir [ICG-IT]. All rights reserved.
//

#import "TWOverlayView.h"
#import "TWDraggableView.h"

@interface TWOverlayView ()
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation TWOverlayView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return nil;
    
    self.backgroundColor = [UIColor clearColor];
    self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rejected"]];
    [self addSubview:self.imageView];
    
    return self;
}

- (void)setMode:(TWOverlayViewMode)mode
{
    if (_mode == mode) return;
    
    _mode = mode;
    if (mode == TWOverlayViewModeLeft) {
        self.imageView.image = [UIImage imageNamed:@"rejected"];
    } else {
        self.imageView.image = [UIImage imageNamed:@"approved"];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(50, 50, 100, 100);
}


@end
