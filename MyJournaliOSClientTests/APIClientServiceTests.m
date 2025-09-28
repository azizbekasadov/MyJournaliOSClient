//
//  APIClientServiceTests.m
//  MyJournaliOSClientTests
//
//  Created by Azizbek Asadov on 28.09.2025.
//

#import "APIClientServiceTests.h"
#import "Mock/MockDataTask.h"
#import "Mock/MockURLSession.h"

NS_ASSUME_NONNULL_BEGIN

@interface APIClientServiceTests()
- (NSData *)jsonDataFromObject:(id)object;

@end

@implementation APIClientServiceTests

- (NSData *)jsonDataFromObject:(id)object {
    return [NSJSONSerialization dataWithJSONObject:object options:0 error:nil];
}

#pragma mark: - Tests

- (void)test_createPost_success_callsCompletionOnMainWithNilError {
    MockURLSession *session = [MockURLSession new];
    session.nextData = [@"OK" dataUsingEncoding:NSUTF8StringEncoding];
    session.nextResponse = [[NSHTTPURLResponse alloc] initWithURL:[NSURL URLWithString:@"http://localhost:1337/post"]
                                                      statusCode:200
                                                     HTTPVersion:@"HTTP/1.1"
                                                    headerFields:nil];

    APIClientService *svc = [[APIClientService alloc] initWithSession:session];

    XCTestExpectation *exp = [self expectationWithDescription:@"createPost success"];
    [svc createPost:@"Title" withPostBody:@"Body" withCompletionHandler:^(NSError * _Nullable error) {
        XCTAssertTrue(NSThread.isMainThread);
        XCTAssertNil(error);
        // Verify request
        XCTAssertEqualObjects(session.lastRequest.HTTPMethod, @"POST");
        XCTAssertEqualObjects([session.lastRequest valueForHTTPHeaderField:@"content-type"], @"application/json");
        [exp fulfill];
    }];

    [self waitForExpectationsWithTimeout:2 handler:nil];
}

- (void)test_createPost_propagatesNetworkError {
    MockURLSession *session = [MockURLSession new];
    session.nextError = [NSError errorWithDomain:NSURLErrorDomain code:-1009 userInfo:nil];

    APIClientService *svc = [[APIClientService alloc] initWithSession:session];

    XCTestExpectation *exp = [self expectationWithDescription:@"createPost network error"];
    [svc createPost:@"T" withPostBody:@"B" withCompletionHandler:^(NSError * _Nullable error) {
        XCTAssertTrue(NSThread.isMainThread);
        XCTAssertNotNil(error);
        XCTAssertEqualObjects(error.domain, NSURLErrorDomain);
        [exp fulfill];
    }];
    [self waitForExpectationsWithTimeout:2 handler:nil];
}

#pragma mark - fetchPosts

- (void)test_fetchPosts_success_decodesArray_andCallsBackOnMain {
    MockURLSession *session = [MockURLSession new];
    NSArray *payload = @[
        @{@"id": @1, @"title": @"A", @"body": @"B"},
        @{@"id": @2, @"title": @"C", @"body": @"D"}
    ];
    session.nextData = [self jsonDataFromObject:payload];
    session.nextResponse = [[NSHTTPURLResponse alloc] initWithURL:[NSURL URLWithString:@"http://localhost:1337/posts"]
                                                      statusCode:200
                                                     HTTPVersion:@"HTTP/1.1"
                                                    headerFields:nil];

    APIClientService *svc = [[APIClientService alloc] initWithSession:session];

    XCTestExpectation *exp = [self expectationWithDescription:@"fetchPosts success"];
    [svc fetchPosts:^(NSArray<Post *> * _Nullable posts, NSError * _Nullable error) {
        XCTAssertTrue(NSThread.isMainThread);
        XCTAssertNil(error);
        XCTAssertNotNil(posts);
        XCTAssertEqual(posts.count, 2);
        XCTAssertEqual(posts.firstObject.postId, 1);
        XCTAssertEqualObjects(posts.firstObject.title, @"A");
        XCTAssertEqualObjects(posts.firstObject.body, @"B");
        [exp fulfill];
    }];
    [self waitForExpectationsWithTimeout:2 handler:nil];
}

- (void)test_fetchPosts_decodingFailed_returnsAPIClientDecodingError {
    MockURLSession *session = [MockURLSession new];
    NSDictionary *invalidTopLevel = @{@"id": @1};
    
    session.nextData = [self jsonDataFromObject:invalidTopLevel];
    session.nextResponse = [[NSHTTPURLResponse alloc] initWithURL:[NSURL URLWithString:@"http://localhost:1337/posts"]
                                                      statusCode:200
                                                     HTTPVersion:@"HTTP/1.1"
                                                    headerFields:nil];

    APIClientService *svc = [[APIClientService alloc] initWithSession:session];

    XCTestExpectation *exp = [self expectationWithDescription:@"fetchPosts decoding error"];
    [svc fetchPosts:^(NSArray<Post *> * _Nullable posts, NSError * _Nullable error) {
        XCTAssertTrue(NSThread.isMainThread);
        XCTAssertNil(posts);
        XCTAssertNotNil(error);
        XCTAssertEqualObjects(error.domain, APIClientErrorDomain);
        XCTAssertEqual(error.code, APICodeDecodingFailed);
        [exp fulfill];
    }];
    [self waitForExpectationsWithTimeout:2 handler:nil];
}

- (void)test_fetchPosts_networkError_propagates {
    MockURLSession *session = [MockURLSession new];
    session.nextError = [NSError errorWithDomain:NSURLErrorDomain code:-1001 userInfo:nil];

    APIClientService *svc = [[APIClientService alloc] initWithSession:session];

    XCTestExpectation *exp = [self expectationWithDescription:@"fetchPosts network error"];
    [svc fetchPosts:^(NSArray<Post *> * _Nullable posts, NSError * _Nullable error) {
        XCTAssertTrue(NSThread.isMainThread);
        XCTAssertNil(posts);
        XCTAssertNotNil(error);
        XCTAssertEqualObjects(error.domain, NSURLErrorDomain);
        [exp fulfill];
    }];
    [self waitForExpectationsWithTimeout:2 handler:nil];
}

#pragma mark - deletePost

- (void)test_deletePost_success_whenStatus200AndDataPresent {
    MockURLSession *session = [MockURLSession new];
    session.nextData = [@"deleted" dataUsingEncoding:NSUTF8StringEncoding];
    session.nextResponse = [[NSHTTPURLResponse alloc] initWithURL:[NSURL URLWithString:@"http://localhost:1337/post/1"]
                                                      statusCode:200
                                                     HTTPVersion:@"HTTP/1.1"
                                                    headerFields:nil];

    APIClientService *svc = [[APIClientService alloc] initWithSession:session];

    XCTestExpectation *exp = [self expectationWithDescription:@"deletePost success"];
    [svc deletePostWithPostId:1 withCompletionHandler:^(NSError * _Nullable error) {
        XCTAssertTrue(NSThread.isMainThread);
        XCTAssertNil(error);
        XCTAssertEqualObjects(session.lastRequest.HTTPMethod, @"DELETE");
        [exp fulfill];
    }];
    [self waitForExpectationsWithTimeout:2 handler:nil];
}

- (void)test_deletePost_non200_returnsInvalidResponseError {
    MockURLSession *session = [MockURLSession new];
    session.nextData = [@"err" dataUsingEncoding:NSUTF8StringEncoding];
    session.nextResponse = [[NSHTTPURLResponse alloc] initWithURL:[NSURL URLWithString:@"http://localhost:1337/post/1"]
                                                      statusCode:404
                                                     HTTPVersion:@"HTTP/1.1"
                                                    headerFields:nil];

    APIClientService *svc = [[APIClientService alloc] initWithSession:session];

    XCTestExpectation *exp = [self expectationWithDescription:@"deletePost 404"];
    [svc deletePostWithPostId:1 withCompletionHandler:^(NSError * _Nullable error) {
        XCTAssertTrue(NSThread.isMainThread);
        XCTAssertNotNil(error);
        XCTAssertEqualObjects(error.domain, APIClientErrorDomain);
        XCTAssertEqual(error.code, APICodeInvalidResponse);
        [exp fulfill];
    }];
    [self waitForExpectationsWithTimeout:2 handler:nil];
}

- (void)test_deletePost_status200ButNoData_returnsCorruptDataError {
    MockURLSession *session = [MockURLSession new];
    session.nextData = nil;
    session.nextResponse = [[NSHTTPURLResponse alloc] initWithURL:[NSURL URLWithString:@"http://localhost:1337/post/2"]
                                                      statusCode:200
                                                     HTTPVersion:@"HTTP/1.1"
                                                    headerFields:nil];

    APIClientService *svc = [[APIClientService alloc] initWithSession:session];

    XCTestExpectation *exp = [self expectationWithDescription:@"deletePost 200 no data"];
    [svc deletePostWithPostId:2 withCompletionHandler:^(NSError * _Nullable error) {
        XCTAssertTrue(NSThread.isMainThread);
        XCTAssertNotNil(error);
        XCTAssertEqualObjects(error.domain, APIClientErrorDomain);
        XCTAssertEqual(error.code, APICodeCorruptDataResponse);
        [exp fulfill];
    }];
    [self waitForExpectationsWithTimeout:2 handler:nil];
}

- (void)test_deletePost_networkError_propagates {
    MockURLSession *session = [MockURLSession new];
    session.nextError = [NSError errorWithDomain:NSURLErrorDomain code:-1005 userInfo:nil];

    APIClientService *svc = [[APIClientService alloc] initWithSession:session];

    XCTestExpectation *exp = [self expectationWithDescription:@"deletePost network error"];
    [svc deletePostWithPostId:3 withCompletionHandler:^(NSError * _Nullable error) {
        XCTAssertTrue(NSThread.isMainThread);
        XCTAssertNotNil(error);
        XCTAssertEqualObjects(error.domain, NSURLErrorDomain);
        [exp fulfill];
    }];
    [self waitForExpectationsWithTimeout:2 handler:nil];
}

@end

NS_ASSUME_NONNULL_END
