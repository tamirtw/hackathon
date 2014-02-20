//
//  TWDraggableView.m
//  Facedoor
//
//  Created by Twina, Tamir [ICG-IT] on 2/18/14.
//  Copyright (c) 2014 Twina, Tamir [ICG-IT]. All rights reserved.
//

#import "TWDraggableView.h"
#import "MNMRemoteImageView.h"
#import "TWOverlayView.h"
#import <QuartzCore/QuartzCore.h>
#import "FacedoorModel.h"

#define xDistanceThreshold 100

@interface TWDraggableView ()
@property(nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;
@property(nonatomic) CGPoint originalPoint;
@property(nonatomic, strong) TWOverlayView *overlayView;
@property(nonatomic, strong) UIImageView *baseImageView;
@property(nonatomic, strong) MNMRemoteImageView *imageView;
@end

@implementation TWDraggableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return nil;
    
    [self commonInit];
    
    return self;
}

- (id)initWithCoder:(NSCoder*)aCoder
{
    self = [super initWithCoder:aCoder];
    if (!self) return nil;
    
    [self commonInit];
    
    return self;
}

- (void)commonInit
{
    self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                        action:@selector(dragged:)];
    [self addGestureRecognizer:self.panGestureRecognizer];
    
    // Base view 
    self.baseImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"eventBase"]];
    [self.baseImageView setFrame:self.bounds];
   
    NSLog(@"%@",NSStringFromCGRect(self.bounds));
    
    // Person image 
    [self addSubview:self.baseImageView];
    self.imageView = [[MNMRemoteImageView alloc] init];
    [self.imageView setFrame:(CGRect){17,18,195,158}];
    [self.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [self.imageView setClipsToBounds:YES];
    [self addSubview:self.imageView];
    
    // Overlay
    self.overlayView = [[TWOverlayView alloc] initWithFrame:self.bounds];
    self.overlayView.alpha = 0;
    [self addSubview:self.overlayView];

}

- (void)loadImageWithUrl:(NSString*)imgUrl
{
    @try{
        [self.imageView displayImageFromURL:imgUrl
                          completionHandler:^(NSError *error)
         {
             if(error)
             {
                 self.baseImageView.image = [UIImage imageNamed:@"noEvent"];
                 self.userInteractionEnabled = NO;
             }
             else
             {
                 self.baseImageView.image = [UIImage imageNamed:@"eventBase"];
                 self.userInteractionEnabled = ![[FacedoorModel sharedInstance] isAuthorized];
             }
         }];
    }
    @catch (NSException* e) {
        DDLogCError(@"%@",e);
        self.baseImageView.image = [UIImage imageNamed:@"noEvent"];
        self.userInteractionEnabled = NO;
    }
    
}

- (void)dragged:(UIPanGestureRecognizer *)gestureRecognizer
{
    CGFloat xDistance = [gestureRecognizer translationInView:self].x;
    CGFloat yDistance = [gestureRecognizer translationInView:self].y;
    
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:{
            self.originalPoint = self.center;
            break;
        };
        case UIGestureRecognizerStateChanged:{
            CGFloat rotationStrength = MIN(xDistance / 320, 1);
            CGFloat rotationAngel = (CGFloat) (2*M_PI/16 * rotationStrength);
            CGFloat scaleStrength = 1 - fabsf(rotationStrength) / 4;
            CGFloat scale = MAX(scaleStrength, 0.93);
            CGAffineTransform transform = CGAffineTransformMakeRotation(rotationAngel);
            CGAffineTransform scaleTransform = CGAffineTransformScale(transform, scale, scale);
            self.transform = scaleTransform;
            self.center = CGPointMake(self.originalPoint.x + xDistance, self.originalPoint.y + yDistance);
            
            [self updateOverlay:xDistance];
            
            break;
        };
        case UIGestureRecognizerStateEnded: {
            if(fabs(xDistance) > xDistanceThreshold)
            {
                [self finishTransformationWithDirection:xDistance > 0 ? 1 : -1];
                [self notifyEventWithResult:xDistance > 0 ? YES : NO];
            }
            else
            {
                [self resetViewPositionAndTransformations];
            }
            break;
        };
        case UIGestureRecognizerStatePossible:break;
        case UIGestureRecognizerStateCancelled:break;
        case UIGestureRecognizerStateFailed:break;
    }
}

- (void)updateOverlay:(CGFloat)distance
{
    if (distance > 0) {
        self.overlayView.mode = TWOverlayViewModeRight;
    } else if (distance <= 0) {
        self.overlayView.mode = TWOverlayViewModeLeft;
    }
    CGFloat overlayStrength = MIN(fabsf(distance) / xDistanceThreshold, 0.6);
    self.overlayView.alpha = overlayStrength;
}

- (void)resetViewPositionAndTransformations
{
    [UIView animateWithDuration:0.2
                     animations:^{
                         self.center = self.originalPoint;
                         self.transform = CGAffineTransformMakeRotation(0);
                         self.overlayView.alpha = 0;
                     }];
}

- (void)finishTransformationWithDirection:(int)direction
{
    [UIView animateWithDuration:0.2
                     animations:^{
                         CGFloat xOffset = [[UIScreen mainScreen] bounds].size.width * direction;
                         self.center = CGPointMake(self.center.x + xOffset, self.center.y);
                         self.overlayView.alpha = 0;
                     }];
}

- (void)notifyEventWithResult:(BOOL)yesOrNo
{
    DDLogVerbose(@"you have been %@",yesOrNo ? @"approved" : @"rejected");
    
    [self.delegate notifyResult:yesOrNo];
}

- (void)dealloc
{
    [self removeGestureRecognizer:self.panGestureRecognizer];
}

@end