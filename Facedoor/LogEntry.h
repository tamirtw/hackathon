//
//  LogEntry.h
//  Facedoor
//
//  Created by Twina, Tamir [ICG-IT] on 2/17/14.
//  Copyright (c) 2014 Twina, Tamir [ICG-IT]. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LogEntry : NSObject

@property (nonatomic,readonly) NSString *message;
@property (nonatomic,readonly) NSDate *timestamp;
@property (nonatomic,readonly) NSString *eventId;


- (id)initWithMessage:(NSString*)message
            timestamp:(NSDate*)timestamp
              eventId:(NSString*)eventId;
@end
