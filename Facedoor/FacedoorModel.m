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
    return [NSString stringWithFormat:@"%@&eventId=%@",[self apiUrl],eventId];
}


- (void)respondToDoorAccessRequestApproved:(BOOL)approved
                               compilition:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, id JSON))success
                                   failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON))failure
{
    NSString *perosnImgUrl = [self apiUrl];
    NSURL *url = [NSURL URLWithString:perosnImgUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFJSONRequestOperation *operation =
    [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                    success:success
                                                    failure:failure];
    
    [operation start];
}

- (void)testApiForStatus
{
    NSString *urlString = [NSString stringWithFormat:@"http://facedoor.cloudapp.net/api/Status?id=%@&eventId=%@",self.systemId,self.eventId];
    NSURL *url = [NSURL URLWithString:urlString];
//    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
//    
//    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
//                            @"YXNkYXNkYQ==", @" ",
//                            nil];
//    [httpClient postPath:@"" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
//        NSLog(@"Request Successful, response '%@'", responseStr);
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"[HTTPClient Error]: %@", error.localizedDescription);
//    }];
    // Make a request...
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    // Generate an NSData from your NSString (see below for link to more info)
    NSData *postBody = [NSData base64DataFromString:@"1"];
    
    // Add Content-Length header if your server needs it
    unsigned long long postLength = postBody.length;
    NSString *contentLength = [NSString stringWithFormat:@"%llu", postLength];
    [request addValue:contentLength forHTTPHeaderField:@"Content-Length"];
    
    // This should all look familiar...
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postBody];
    
//    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:success failure:failure];
//    [client enqueueHTTPRequestOperation:operation];
}

- (NSString*)baseUrl
{
//    return @"http://www.quizz.biz/uploads/quizz/152064/3_8yQNI.jpg";
    return @"http://facedoor.cloudapp.net/api/Image?id=1&eventId=3efd1487654f4167b90ea4b00099f5a1";
}

- (NSString*)systemId
{
    return _systemId ? _systemId : @"1";
}

- (NSString*)apiUrl
{
    return [NSString stringWithFormat:@"http://facedoor.cloudapp.net/api/Image?id=%@",self.systemId];
}


@end
