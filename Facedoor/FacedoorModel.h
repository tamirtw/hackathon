//
//  FacedoorModel.h
//  Facedoor
//
//  Created by Twina, Tamir [ICG-IT] on 2/16/14.
//  Copyright (c) 2014 Twina, Tamir [ICG-IT]. All rights reserved.
//

#import <Foundation/Foundation.h>




@interface FacedoorModel : NSObject

@property (nonatomic, strong) NSString *eventId;
@property (nonatomic, strong) NSDate *eventTimestamp;

+ (instancetype)sharedInstance;
- (NSString*)imageUrlForPerson;
- (NSString*)imageUrlForPersonWithEventId:(NSString*)eventId;
- (void)respondToDoorAccessRequestApproved:(BOOL)approved
                               compilition:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, id JSON))success
                                   failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON))failure;
- (void)testApiForStatus;


@end
