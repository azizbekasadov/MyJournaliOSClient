//
//  LoginParameters.h
//  MyJournaliOSClient
//
//  Created by Azizbek Asadov on 28.09.2025.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LoginParameters : NSObject

@property(nonatomic, copy) NSString* emailAddress;
@property(nonatomic, copy) NSString* password;

- (instancetype) initWithEmailAddress:(NSString*) email userPassword: (NSString*) password;
- (instancetype) init NS_UNAVAILABLE;
+ (instancetype) new NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
