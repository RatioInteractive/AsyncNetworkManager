//
//  NSURLConnection+Async.h
//  AllRecipesVideo
//
//  Created by Amanda Shumack on 5/30/12.
//  Copyright (c) 2012 Amanda Shumack. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AsyncURLConnection : NSURLConnection

@property (nonatomic, copy) BOOL (^block)(NSURLResponse *, NSData *, NSError *);
@property (nonatomic, retain) NSURLResponse* response;
@property (nonatomic, retain) NSData* data;

-(id)initWithRequest:(NSURLRequest *)request delegate:(id)delegate startImmediately:(BOOL)startImmediately completionHandler:(BOOL (^)(NSURLResponse *, NSData *, NSError *))handler;

@end
