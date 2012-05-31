//
//  NSURLConnection+Async.m
//  AllRecipesVideo
//
//  Created by Amanda Shumack on 5/30/12.
//  Copyright (c) 2012 Amanda Shumack. All rights reserved.
//

#import "AsyncURLConnection.h"

@implementation AsyncURLConnection
@synthesize block;
@synthesize data;
@synthesize response;

-(id)initWithRequest:(NSURLRequest *)request delegate:(id)delegate startImmediately:(BOOL)startImmediately completionHandler:(BOOL (^)(NSURLResponse *, NSData *, NSError *))handler
{
    self = [self initWithRequest:request delegate:delegate startImmediately:startImmediately];
    if (self) {
        self.block = handler;
    }
    
    return self;
}

-(void) dealloc
{
    [block release];
    [data release];
    [response release];
    [super dealloc];
}

@end
