//
//  TWDraggableView.h
//  Facedoor
//
//  Created by Twina, Tamir [ICG-IT] on 2/18/14.
//  Copyright (c) 2014 Twina, Tamir [ICG-IT]. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DraggableViewDelegate <NSObject>

- (void)notifyResult:(BOOL)yesOrNo;

@end

@interface TWDraggableView : UIView

@property (nonatomic , weak) id<DraggableViewDelegate> delegate;

- (void)loadImageWithUrl:(NSString*)imgUrl;

@end
