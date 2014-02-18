//
//  FacedoorModel.h
//  Facedoor
//
//  Created by Twina, Tamir [ICG-IT] on 2/16/14.
//  Copyright (c) 2014 Twina, Tamir [ICG-IT]. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperation.h"



@interface FacedoorModel : NSObject

@property (nonatomic, strong) NSString *systemId;
@property (nonatomic, strong) NSString *eventId;
@property (nonatomic, strong) NSDate *eventTimestamp;
@property (nonatomic, strong) NSString *message;
@property (nonatomic) BOOL isAuthorized;

+ (instancetype)sharedInstance;
- (NSString*)imageUrlForPerson;
- (NSString*)imageUrlForPersonWithEventId:(NSString*)eventId;
- (void)respondToDoorAccessRequestApproved:(BOOL)approved
                               compilition:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                   failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


@end
