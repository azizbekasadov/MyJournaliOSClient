//
//  MockURLSession.h
//  MyJournaliOSClientTests
//
//  Created by Azizbek Asadov on 28.09.2025.
//

@import Foundation;

NS_ASSUME_NONNULL_BEGIN

@class MockDataTask;

@interface MockURLSession : NSURLSession
@property (nonatomic, strong) NSURLRequest *lastRequest;
@property (nonatomic, strong) NSURL *lastURL;

// Values to return
@property (nonatomic, strong) NSData *nextData;
@property (nonatomic, strong) NSURLResponse *nextResponse;
@property (nonatomic, strong) NSError *nextError;
@end


NS_ASSUME_NONNULL_END
