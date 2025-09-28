//
//  PostsFeedViewController.h
//  MyJournaliOSClient
//
//  Created by Azizbek Asadov on 27.09.2025.
//

@import Foundation;
@import UIKit;

@class Post;
@class APIClientService;
@class AppCoordinator;

@interface PostsFeedViewController : UITableViewController

@property (nonatomic, weak) AppCoordinator* coordinator;

- (instancetype) initWithCoordinator: (AppCoordinator*) coordinator;

@end
