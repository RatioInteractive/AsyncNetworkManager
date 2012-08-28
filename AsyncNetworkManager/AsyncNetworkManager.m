//
//  AsyncNetworkManager.m
//  AsyncNetworkManager
//
//  Created by Amanda Shumack on 5/31/12.
//  Copyright (c) 2012 Amanda Shumack. All rights reserved.
//

#import "AsyncNetworkManager.h"
#import "AsyncURLConnection.h"


@interface AsyncNetworkManager ()

@property (nonatomic, retain) NSMutableSet * urlConnections;

@end

@implementation AsyncNetworkManager
@synthesize urlConnections;
@synthesize statusDelegate;

static AsyncNetworkManager* singleton = nil;

+ (AsyncNetworkManager *)sharedInstance {
    if (nil != singleton) {
        return singleton;
    }
    
    static dispatch_once_t pred;        // Lock
    dispatch_once(&pred, ^{             // This code is called at most once per app
        singleton = [[AsyncNetworkManager alloc] init];
    });
    
    return singleton;
}

-(id) init
{
    self = [super init];
    if (self) {
        self.urlConnections = [NSMutableSet set];
    }
    
    return self;
}

-(void) sendAsyncRequest:(NSURLRequest *)request completionHandler:(BOOL (^)(NSURLResponse *, NSData *, NSError *))handler
{
    AsyncURLConnection* conn = [[AsyncURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES completionHandler:handler];
    
    if (conn) {
        // We need to save this connection so that we can call the completion handler when complete
        [self.urlConnections addObject:conn];
        conn.data = [[[NSMutableData alloc] init] autorelease];
        [conn release];
    }
}

#define NSURLConnectionDelegate


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    DLog(@"Network conn failed %@", error);
    AsyncURLConnection* asyncConn = (AsyncURLConnection*)connection;
    if(asyncConn.block)
    {
        asyncConn.block(asyncConn.response, asyncConn.data, error);
    }
    [self.urlConnections removeObject:connection];
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    DLog(@"Receiving conn %@ response %@", connection, response);
    AsyncURLConnection* asyncConn = (AsyncURLConnection*)connection;
    asyncConn.response = response;
    
    // Incoming response means we need to reset our data object
    asyncConn.data = [[[NSMutableData alloc] init] autorelease];
}

- (void)connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite
{
    float progress = [[NSNumber numberWithInteger:totalBytesWritten] floatValue];
    float total = [[NSNumber numberWithInteger: totalBytesExpectedToWrite] floatValue];
    
    DLog(@"Sending data percent complete %.2f", progress/total);
    
    [self.statusDelegate updateStatus:progress/total];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    DLog(@"Receiving data conn %@", connection);
    AsyncURLConnection* asyncConn = (AsyncURLConnection*)connection;
    [asyncConn.data appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    DLog(@"Finished loading conn %@", connection);
    AsyncURLConnection* asyncConn = (AsyncURLConnection*)connection;
    if(asyncConn.block)
    {
        asyncConn.block(asyncConn.response, asyncConn.data, nil);
    }
    
    [self.urlConnections removeObject:connection];
}


@end
