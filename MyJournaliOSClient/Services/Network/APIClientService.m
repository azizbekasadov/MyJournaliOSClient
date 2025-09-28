//
//  APIClientService.m
//  MyJournaliOSClient
//
//  Created by Azizbek Asadov on 28.09.2025.
//

#import "Post.h"
#import "APIClientService.h"
#import "APIClientServiceErrorDomain.h"
#import "APIClientServiceError.h"
#import "JRHTTPMethod.h"
#import "LoginParameters.h"

NS_ASSUME_NONNULL_BEGIN

@interface APIClientService()
    
@property (nonatomic, strong) NSURLSession *session;

@end

@implementation APIClientService

const NSString* baseURL = @"http://localhost:1440/api/v1/";

+ (instancetype) sharedInstance {
    static APIClientService* shared;
    static dispatch_once_t onceDispatchToken;
    
    dispatch_once(&onceDispatchToken, ^{
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        shared = [[APIClientService alloc] initWithSession:[NSURLSession sessionWithConfiguration:config]];
    });
    
    return shared;
}

- (instancetype)initWithSession:(NSURLSession *)session {
    self = [super init];
    
    if (self) {
        _session = session ?: [NSURLSession sharedSession];
    }
    return self;
}


- (void) createPost:(NSString*) title
       withPostBody: (NSString*) body
        withCompletionHandler:(ErrorPronePostCompletionHandler) completion {
    NSString* urlString = [baseURL stringByAppendingString:@"post"];
    NSURL* url = [[NSURL alloc] initWithString:urlString];
    
    if (url) {
        if (_session) {
            NSMutableURLRequest* urlRequest = [[NSMutableURLRequest alloc] initWithURL:url];
            urlRequest.HTTPMethod = (JRHTTPMethod) POST;
            
            NSDictionary* dict = @{
                @"title": title,
                @"postBody": body,
            };
            
            NSError* jsonError;
            NSData* serializedData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&jsonError];
            
            if (jsonError || [jsonError isKindOfClass:[NSData class]]) {
                return dispatch_async(dispatch_get_main_queue(), ^{
                    completion(jsonError ?: [self configureErrorWithCode:APICodeDecodingFailed inDomain:APIClientErrorDomain]);
                });
            }
            
            urlRequest.HTTPBody = serializedData;
            [urlRequest setValue:@"application/json" forHTTPHeaderField:@"content-type"];
            
            NSURLSessionDataTask* task = [_session dataTaskWithRequest:urlRequest
                                                     completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                if (error) {
                    NSLog(@"@%@", error.localizedDescription);
                    
                    return dispatch_async(dispatch_get_main_queue(), ^{
                        completion(error);
                    });
                }
                
                if (data) {
                    NSLog(@"All Good - Post was created");
                    return dispatch_async(dispatch_get_main_queue(), ^{
                        completion(nil);
                    });
                } else {
                    NSError *error = [self configureErrorWithCode:APICodeCorruptDataResponse inDomain:APIClientErrorDomain];
                    return dispatch_async(dispatch_get_main_queue(), ^{
                        completion(error);
                    });
                }
            }];
            
            [task resume];
        } else {
            NSError *error = [self configureErrorWithCode:APICodeSessionIsNotConfigured inDomain:APIClientErrorDomain];
            return dispatch_async(dispatch_get_main_queue(), ^{
                completion(error);
            });
        }
    } else {
        NSError* error = [self configureErrorWithCode:APICodeInvalidURL inDomain:APIClientErrorDomain];
        return dispatch_async(dispatch_get_main_queue(), ^{
            completion(error);
        });
    }
}

- (void)fetchPosts:(FetchPostsCompletionHandler)completion {
    NSString* urlString = [baseURL stringByAppendingString:@"home"];
    NSURL* url = [[NSURL alloc] initWithString:urlString];
    
    NSMutableURLRequest* urlRequest = [[NSMutableURLRequest alloc] initWithURL:url];
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
    
    if (url) {
        if (_session) {
            NSURLSessionDataTask* task = [_session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                
                if (error) {
                    NSLog(@"@%@", error.localizedDescription);
                    
                    return dispatch_async(dispatch_get_main_queue(), ^{
                        completion(nil, error);
                    });
                }
                
                if (data) {
                    NSError *jsonError = nil;
                    id json = [NSJSONSerialization JSONObjectWithData:data
                                                              options:0
                                                                error:&jsonError];
                    if (jsonError || ![json isKindOfClass:[NSArray class]]) {
                        return dispatch_async(dispatch_get_main_queue(), ^{
                            completion(nil, jsonError ?: [self configureErrorWithCode:APICodeDecodingFailed inDomain:APIClientErrorDomain]);
                        });
                    }
                    
                    NSMutableArray<Post*>* posts = [NSMutableArray array];
                    
                    for (NSDictionary *dict in (NSArray *) json) {
                        [posts addObject:[[Post alloc] initWithDictionary:dict]];
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completion([posts copy], nil);
                    });
                } else {
                    NSError *error = [self configureErrorWithCode:APICodeCorruptDataResponse inDomain:APIClientErrorDomain];
                    return dispatch_async(dispatch_get_main_queue(), ^{
                        completion(nil, error);
                    });
                }
            }];
            
            [task resume];
        } else {
            NSError *error = [self configureErrorWithCode:APICodeSessionIsNotConfigured inDomain:APIClientErrorDomain];
            return dispatch_async(dispatch_get_main_queue(), ^{
                completion(nil, error);
            });
        }
    } else {
        NSError* error = [self configureErrorWithCode:APICodeInvalidURL inDomain:APIClientErrorDomain];
        return dispatch_async(dispatch_get_main_queue(), ^{
            completion(nil, error);
        });
    }
}

- (void)deletePostWithPostId:(NSInteger) postId withCompletionHandler:(ErrorPronePostCompletionHandler) completion; {
    NSNumber* postIdNumber = [[NSNumber alloc] initWithInteger:postId];
    NSString* postIdString = postIdNumber.stringValue;
    NSString* urlString = [[baseURL stringByAppendingString:@"post/"] stringByAppendingString:postIdString];
    
    NSURL* url = [[NSURL alloc] initWithString:urlString];
    
    if (url) {
        NSMutableURLRequest* urlRequest = [[NSMutableURLRequest alloc] initWithURL:url];
        urlRequest.HTTPMethod = (JRHTTPMethod) DELETE;
        
        NSURLSessionDataTask* task = [_session dataTaskWithRequest:urlRequest
                                      completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (error) {
                NSLog(@"@%@", error.localizedDescription);
                
                return dispatch_async(dispatch_get_main_queue(), ^{
                    completion(error);
                });
            }
            
            NSHTTPURLResponse* __response = (NSHTTPURLResponse*) response;
            
            if (__response.statusCode == 200) {
                if (data) {
                    NSString* logMessage = [@"Post with id" stringByAppendingString:postIdString];
                    NSLog(@"%@", logMessage);
                    
                    return dispatch_async(dispatch_get_main_queue(), ^{
                        completion(nil);
                    });
                } else {
                    NSError *error = [self configureErrorWithCode:APICodeCorruptDataResponse inDomain:APIClientErrorDomain];
                    return dispatch_async(dispatch_get_main_queue(), ^{
                        completion(error);
                    });
                }
            } else {
                NSError *error = [self configureErrorWithCode:APICodeInvalidResponse inDomain:APIClientErrorDomain];
                return dispatch_async(dispatch_get_main_queue(), ^{
                    completion(error);
                });
            }
        }];
        
        [task resume];
    } else {
        NSError* error = [self configureErrorWithCode:APICodeInvalidURL inDomain:APIClientErrorDomain];
        return dispatch_async(dispatch_get_main_queue(), ^{
            completion(error);
        });
    }
}

- (void)authenticateWithLoginParameters:(LoginParameters *)parameters withCompletionHandler:(ErrorPronePostCompletionHandler) completion; {
    NSString* urlString = [baseURL stringByAppendingString:@"entrance/login"];
    
    NSURL* url = [[NSURL alloc] initWithString:urlString];
    
    if (url) {
        NSMutableURLRequest* urlRequest = [[NSMutableURLRequest alloc] initWithURL:url];
        urlRequest.HTTPMethod = (JRHTTPMethod) PUT;
        NSDictionary* dict = @{
            @"emailAddress": parameters.emailAddress,
            @"password": parameters.password,
        };
        
        NSError* jsonError;
        NSData* data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingFragmentsAllowed error:&jsonError];
        
        if (jsonError || ![data isKindOfClass:[NSData class]]) {
            return dispatch_async(dispatch_get_main_queue(), ^{
                completion(jsonError ?: [self configureErrorWithCode:APICodeDecodingFailed inDomain:APIClientErrorDomain]);
            });
        }
        
        NSURLSessionDataTask* task = [_session dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (error) {
                NSLog(@"@%@", error.localizedDescription);
                
                return dispatch_async(dispatch_get_main_queue(), ^{
                    completion(error);
                });
            }
            
            NSHTTPURLResponse* __response = (NSHTTPURLResponse*) response;
            
            if (__response.statusCode == 200) {
                if (data) {
                    return dispatch_async(dispatch_get_main_queue(), ^{
                        completion(nil);
                    });
                } else {
                    NSError *error = [self configureErrorWithCode:APICodeCorruptDataResponse inDomain:APIClientErrorDomain];
                    return dispatch_async(dispatch_get_main_queue(), ^{
                        completion(error);
                    });
                }
            } else {
                NSError *error = [self configureErrorWithCode:APICodeInvalidResponse inDomain:APIClientErrorDomain];
                return dispatch_async(dispatch_get_main_queue(), ^{
                    completion(error);
                });
            }
        }];
        
        [task resume];
    } else {
        NSError* error = [self configureErrorWithCode:APICodeInvalidURL inDomain:APIClientErrorDomain];
        return dispatch_async(dispatch_get_main_queue(), ^{
            completion(error);
        });
    }
}

#pragma mark: - Helpers
- (NSError*) configureErrorWithCode: (APIClientErrorCode) code
                          inDomain:(NSErrorDomain) domain {
    NSError* error = [NSError errorWithDomain:domain
                                         code:code
                                     userInfo:nil];
    
    NSLog(@"@%@", error.localizedDescription);
    return error;
}

@end

NS_ASSUME_NONNULL_END
