//
//  LogEntry.m
//  Facedoor
//
//  Created by Twina, Tamir [ICG-IT] on 2/17/14.
//  Copyright (c) 2014 Twina, Tamir [ICG-IT]. All rights reserved.
//

#import "LogEntry.h"

@interface LogEntry()

@property (nonatomic,strong) NSString *message;
@property (nonatomic,strong) NSDate *timestamp;
@property (nonatomic,strong) NSString *eventId;

@end

@implementation LogEntry

- (id)initWithMessage:(NSString*)message
            timestamp:(NSDate*)timestamp
              eventId:(NSString*)eventId
{
    self = [super init];
    if(self)
    {
        _message = message;
        _timestamp = timestamp;
        _eventId = eventId;
    }
    
    return self;
}

- (NSString*)description
{
    return [NSString stringWithFormat:@"{message = %@, timestamp = %@, eventId = %@",self.message,self.timestamp,self.eventId];
}

@end
