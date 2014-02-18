//
//  FacedoorModel.m
//  Facedoor
//
//  Created by Twina, Tamir [ICG-IT] on 2/16/14.
//  Copyright (c) 2014 Twina, Tamir [ICG-IT]. All rights reserved.
//

#import "FacedoorModel.h"
#import "AFNetworking.h"
#import "NSData+Base64_Data.h"

typedef enum APIRequestType {
    APIRequestTypeStatus ,
    APIRequestTypeImage
}APIRequestType;


@implementation FacedoorModel


+ (instancetype)sharedInstance
{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (NSString*)imageUrlForPerson
{
    return [self imageUrlForPersonWithEventId:self.eventId];
}

- (NSString*)imageUrlForPersonWithEventId:(NSString*)eventId
{
    return [NSString stringWithFormat:@"%@&eventId=%@",[self apiUrlWithRequestType:APIRequestTypeImage],eventId];
}


- (void)respondToDoorAccessRequestApproved:(BOOL)approved
                               compilition:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                   failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *updateStatusUrl = [self apiUrlWithRequestType:APIRequestTypeStatus];
    //TODO
    NSURL *url = [NSURL URLWithString:[updateStatusUrl stringByAppendingFormat:@"&eventId=%@&status=%d",self.eventId,approved? 1:2]];
    
    DDLogCVerbose(@"update status : %@",url);
    // Create client
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:url];
    // Make a request...
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request setHTTPMethod:@"POST"];
    
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request
                                                                        success:success
                                                                        failure:failure];
    
    [operation start];
}

- (NSString*)systemId
{
    return _systemId ? _systemId : @"1";
}

- (NSString*)apiUrlWithRequestType:(APIRequestType)requestType
{
    return [NSString stringWithFormat:@"http://facedoor.cloudapp.net/api/%@?id=%@", [self pathForRequestType:requestType],self.systemId];
}

- (NSString*)pathForRequestType:(APIRequestType)requestType
{
    NSString *path = nil;
    switch (requestType) {
        case APIRequestTypeImage:
            path = @"Image";
            break;
        case APIRequestTypeStatus:
            path = @"Status";
            break;
        default:
            DDLogError(@"Error: Missing request type");
            break;
    }
    
    return path;
}


@end
