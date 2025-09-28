//
//  Post.m
//  MyJournaliOSClient
//
//  Created by Azizbek Asadov on 27.09.2025.
//

#import "Post.h"

NS_ASSUME_NONNULL_BEGIN

@implementation Post

- (instancetype) initWithDictionary:(NSDictionary *) dict {
    self = [super init];
    
    if (self) {
        _postId = [dict[@"id"] isKindOfClass:[NSNumber class]] ? [dict[@"id"] integerValue] : 0;
        _title = [dict[@"title"] isKindOfClass:[NSString class]] ? dict[@"title"] : @"";
        _body = [dict[@"body"] isKindOfClass:[NSString class]] ? dict[@"body"] : @"";
    }
    
    return self;
}

@end

NS_ASSUME_NONNULL_END
