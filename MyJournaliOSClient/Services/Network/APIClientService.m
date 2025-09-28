//
//  APIClientService.m
//  MyJournaliOSClient
//
//  Created by Azizbek Asadov on 28.09.2025.
//

#import "Post.h"
#import "APIClientService.h"

NS_ASSUME_NONNULL_BEGIN

@interface APIClientService()
    
@property (nonatomic, strong) NSURLSession *session;

@end

@implementation APIClientService

-(instancetype) sharedInstance {
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
    
}

@end

NS_ASSUME_NONNULL_END
