//
//  APIClientServiceError.h
//  MyJournaliOSClient
//
//  Created by Azizbek Asadov on 28.09.2025.
//

#ifndef APIClientServiceError_h
#define APIClientServiceError_h

@import Foundation;

typedef NS_ENUM(NSInteger, APIClientErrorCode) {
    APICodeInvalidURL = 1001,
    APICodeInvalidResponse = 1002,
    APICodeDecodingFailed = 1003,
    APICodeSessionIsNotConfigured = 1004,
    APICodeCorruptDataResponse = 1005,
};

FOUNDATION_EXPORT NSErrorDomain const APIClientErrorDomain;


#endif
