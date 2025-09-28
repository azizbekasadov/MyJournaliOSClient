//
//  MockDataTask.m
//  MyJournaliOSClientTests
//
//  Created by Azizbek Asadov on 28.09.2025.
//

#import "MockDataTask.h"

NS_ASSUME_NONNULL_BEGIN

@implementation MockDataTask

- (instancetype) initWithCompletion:(MockCompletion)completion
                              data:(NSData *)data
                          response:(NSURLResponse *)response
                             error:(NSError *)error {
    if ((self = [super init])) {
        _completion = [completion copy];
        _dataToReturn = data;
        _responseToReturn = response;
        _errorToReturn = error;
    }
    return self;
}
- (void)resume {
    self.resumed = YES;
    
    if (self.completion) {
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0), ^{
            self.completion(self.dataToReturn, self.responseToReturn, self.errorToReturn);
        });
    }
}
@end

NS_ASSUME_NONNULL_END
