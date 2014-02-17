//
//  HistoryLogModel.m
//  Facedoor
//
//  Created by Twina, Tamir [ICG-IT] on 2/17/14.
//  Copyright (c) 2014 Twina, Tamir [ICG-IT]. All rights reserved.
//

#import "HistoryLogModel.h"
#import "FMDatabase.h"
#import "LogEntry.h"

@interface HistoryLogModel ()

@property (nonatomic, strong) FMDatabase *database;

@end

@implementation HistoryLogModel


+ (instancetype)sharedInstance
{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
        [sharedInstance createDBIfNeeded];
    });
    return sharedInstance;
}


- (void)createDBIfNeeded
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath = [paths objectAtIndex:0];
    NSString *path = [docsPath stringByAppendingPathComponent:@"database.sqlite"];
    
    self.database = [FMDatabase databaseWithPath:path];
    
    
    [self.database open];
    [self.database executeUpdate:@"create table log(timestamp text, message text, event_id text)"];
    
    [self.database close];
}


- (void)addLogEntryWithWithEventId:(NSString*)eventId
                              message:(NSString*)message
                         timestamp:(NSString*)timestamp
{
    [self.database open];
    
    [self.database executeUpdate:@"insert into log(timestamp, message, event_id) values(?,?,?)",timestamp, message, eventId,nil];
    
    [self.database close];
}

- (NSArray*)getHistoryLog
{
    [self.database open];
    NSMutableArray *historyLog = [NSMutableArray new];
    
    FMResultSet *results = [self.database executeQuery:@"select * from log order by timestamp desc"];
    while([results next]) {
        NSString *message = [results stringForColumn:@"message"];
        NSDate *timestamp  = [NSDate dateWithTimeIntervalSince1970:[[results stringForColumn:@"timestamp"] doubleValue]];
        NSString *eventId = [results stringForColumn:@"event_id"];
        LogEntry *logEntry = [[LogEntry alloc] initWithMessage:message
                                                     timestamp:timestamp
                                                       eventId:eventId];
        [historyLog addObject:logEntry];
    }
    
    return historyLog;

}

@end
