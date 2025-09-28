//
//  MockURLSession.m
//  MyJournaliOSClientTests
//
//  Created by Azizbek Asadov on 28.09.2025.
//

#import "MockURLSession.h"
#import "MockDataTask.h"

NS_ASSUME_NONNULL_BEGIN

NS_ASSUME_NONNULL_END

@implementation MockURLSession

- (NSURLSessionDataTask *)dataTaskWithRequest:(NSURLRequest *)request
                            completionHandler:(void (^)(NSData * _Nullable, NSURLResponse * _Nullable, NSError * _Nullable))completionHandler {
    self.lastRequest = request;
    MockDataTask *task = [[MockDataTask alloc] initWithCompletion:completionHandler
                                                             data:self.nextData
                                                         response:self.nextResponse
                                                            error:self.nextError];
    return task;
}

- (NSURLSessionDataTask *)dataTaskWithURL:(NSURL *)url
                        completionHandler:(void (^)(NSData * _Nullable, NSURLResponse * _Nullable, NSError * _Nullable))completionHandler {
    self.lastURL = url;
    MockDataTask *task = [[MockDataTask alloc] initWithCompletion:completionHandler
                                                             data:self.nextData
                                                         response:self.nextResponse
                                                            error:self.nextError];
    return task;
}
@end
