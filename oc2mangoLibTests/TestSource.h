//
//  TestSource.h
//  oc2mangoLibTests
//
//  Created by Jiang on 2019/5/12.
//  Copyright © 2019年 SilverFruity. All rights reserved.

#import <Foundation/Foundation.h>
@interface TestSource : NSObject
@property (nonatomic,readonly) NSURL *baseUrl;
- (instancetype)initWithBaseUrl:(NSURL *)baseUrl;

- (NSURLSessionDataTask *)requestWithMethod:(SFNHTTPMethod)method
                                        uri:(NSString *)uri
                                 parameters:(NSDictionary *)param
                                     plugin:(id <SFPlugin>)plugin
                                 completion:(HTTPHandler)completion;

- (NSMutableURLRequest *)createRequestWithMethod:(SFNHTTPMethod)method
                                             uri:(NSString *)URLString
                                      parameters:(nullble NSDictionary *)param;

- (NSMutableURLRequest *)createEncryptedRequestWithMethod:(SFNHTTPMethod)method
                                                      uri:(NSString *)URLString
                                               parameters:(NSDictionary *)param;


- (NSURLSessionDataTask *)request:(NSURLRequest *)request
                           plugin:(id <SFPlugin>)plugin
                       completion:(HTTPHandler)completion;
@end
