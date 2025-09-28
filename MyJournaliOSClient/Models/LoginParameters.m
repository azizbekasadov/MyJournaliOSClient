//
//  LoginParameters.m
//  MyJournaliOSClient
//
//  Created by Azizbek Asadov on 28.09.2025.
//

#import "LoginParameters.h"

NS_ASSUME_NONNULL_BEGIN

@implementation LoginParameters

- (instancetype) initWithEmailAddress:(NSString*) email userPassword: (NSString*) password {
    self = [super init];
    
    if (self) {
        _emailAddress = email;
        _password = password;
    }
    
    return self;
}

@end

NS_ASSUME_NONNULL_END
