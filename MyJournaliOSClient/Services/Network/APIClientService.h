//
//  APIClientService.h
//  MyJournaliOSClient
//
//  Created by Azizbek Asadov on 28.09.2025.
//

@import Foundation;

@class Post;

NS_ASSUME_NONNULL_BEGIN

typedef void (^FetchPostsCompletionHandler)(NSArray<Post*>* _Nullable posts, NSError* _Nullable error);
typedef void (^ErrorPronePostCompletionHandler)(NSError* _Nullable error);

@interface APIClientService : NSObject

+(instancetype) sharedInstance;
-(instancetype) initWithSession:(NSURLSession *)session NS_DESIGNATED_INITIALIZER;
-(instancetype) init NS_UNAVAILABLE;
+(instancetype) new NS_UNAVAILABLE;

- (void) fetchPosts:(FetchPostsCompletionHandler) completion;
- (void) createPost:(NSString*) title withPostBody: (NSString*) body withCompletionHandler:(ErrorPronePostCompletionHandler) completion;
- (void) deletePostWithPostId:(NSInteger) postId withCompletionHandler:(ErrorPronePostCompletionHandler) completion;;

@end

NS_ASSUME_NONNULL_END
