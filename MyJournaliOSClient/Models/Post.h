//
//  Post.h
//  MyJournaliOSClient
//
//  Created by Azizbek Asadov on 27.09.2025.
//

@import Foundation;

NS_ASSUME_NONNULL_BEGIN

@interface Post : NSObject

@property (nonatomic, assign, readonly) int postId;
@property (nonatomic, copy, readonly) NSString* title;
@property (nonatomic, copy, readonly) NSString* body;

-(instancetype)initWithDictionary:(NSDictionary *) dict;

@end

NS_ASSUME_NONNULL_END
