//
//  MockDataTask.h
//  MyJournaliOSClientTests
//
//  Created by Azizbek Asadov on 28.09.2025.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MockDataTask : NSURLSessionDataTask

typedef void (^MockCompletion)(NSData * _Nullable, NSURLResponse * _Nullable, NSError * _Nullable);

@property (nonatomic, copy) MockCompletion completion;
@property (nonatomic, assign) BOOL resumed;
@property (nonatomic, strong) NSData *dataToReturn;
@property (nonatomic, strong) NSURLResponse *responseToReturn;
@property (nonatomic, strong) NSError *errorToReturn;

- (instancetype) initWithCompletion:(MockCompletion)completion
                 data:(NSData *)data
                 response:(NSURLResponse *)response
                 error:(NSError *)error;

@end

NS_ASSUME_NONNULL_END
