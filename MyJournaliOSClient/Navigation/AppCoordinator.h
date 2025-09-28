//
//  AppCoordinator.h
//  MyJournaliOSClient
//
//  Created by Azizbek Asadov on 28.09.2025.
//

@import Foundation;
@import UIKit;

#import "Coordinator.h"

NS_ASSUME_NONNULL_BEGIN

@class PostsFeedViewController;

@interface AppCoordinator : NSObject

@property (strong, nonatomic) UIWindow* window;
@property (strong, nullable) UINavigationController* navigationController;

- (instancetype) initWithWindowScene: (UIWindowScene*) windowScene;
- (instancetype) init NS_UNAVAILABLE;
+ (instancetype) new NS_UNAVAILABLE;

- (void) start;

@end

NS_ASSUME_NONNULL_END
