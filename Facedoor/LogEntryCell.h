//
//  LogEntryCell.h
//  Facedoor
//
//  Created by Twina, Tamir [ICG-IT] on 2/17/14.
//  Copyright (c) 2014 Twina, Tamir [ICG-IT]. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MNMRemoteImageView.h"


@interface LogEntryCell : UITableViewCell

@property (nonatomic, weak) IBOutlet MNMRemoteImageView *eventImg;
@property (nonatomic, weak) IBOutlet UILabel *message;
@property (nonatomic, weak) IBOutlet UILabel *eventTitle;
@property (nonatomic, weak) IBOutlet UILabel *timeAgo;

@end
