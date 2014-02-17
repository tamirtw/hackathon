//
//  HistoryLogModel.h
//  Facedoor
//
//  Created by Twina, Tamir [ICG-IT] on 2/17/14.
//  Copyright (c) 2014 Twina, Tamir [ICG-IT]. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HistoryLogModel : NSObject

+ (instancetype)sharedInstance;
- (NSArray*)getHistoryLog;
- (void)addLogEntryWithWithEventId:(NSString*)eventId
                           message:(NSString*)message
                         timestamp:(NSString*)timestamp;
@end
