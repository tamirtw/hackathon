//
//  NSData+Base64_Data.h
//  Facedoor
//
//  Created by Twina, Tamir [ICG-IT] on 2/16/14.
//  Copyright (c) 2014 Twina, Tamir [ICG-IT]. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (Base64_Data)
+ (NSData *) base64DataFromString:(NSString *)string;
@end

