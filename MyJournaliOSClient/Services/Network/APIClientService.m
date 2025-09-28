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

NS_ASSUME_NONNULL_BEGIN

@interface APIClientService()
    
@property (nonatomic, strong) NSURLSession *session;

@end

@implementation APIClientService

+(instancetype) sharedInstance {
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

-(void)fetchPosts:(FetchPostsCompletionHandler)completion {
    NSURL* url = [[NSURL alloc] initWithString:@"http://localhost:1337/posts"];
    
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

#pragma MARK: - Helpers
-(NSError*) configureErrorWithCode: (APIClientErrorCode) code
                          inDomain:(NSErrorDomain) domain {
    NSError* error = [NSError errorWithDomain:domain
                                         code:code
                                     userInfo:nil];
    
    NSLog(@"@%@", error.localizedDescription);
    return error;
}

@end

NS_ASSUME_NONNULL_END
