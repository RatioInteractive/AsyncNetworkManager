//
//  AsyncNetworkManager.h
//  AsyncNetworkManager
//
//  Created by Amanda Shumack on 5/31/12.
//  Copyright (c) 2012 Amanda Shumack. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UploadStatusDelegate <NSObject>

-(void) updateStatus:(float)percentComplete;

@end

@interface AsyncNetworkManager : NSObject

@property (nonatomic, assign) id<UploadStatusDelegate> statusDelegate;

-(void) sendAsyncRequest:(NSURLRequest *)request completionHandler:(BOOL (^)(NSURLResponse *, NSData *, NSError *))handler;

+ (AsyncNetworkManager *)sharedInstance;

@end
