//
//  PostsFeedViewController.m
//  MyJournaliOSClient
//
//  Created by Azizbek Asadov on 27.09.2025.
//

#import "Post.h"
#import "APIClientService.h"
#import "PostsFeedViewController.h"

@interface PostsFeedViewController()

@property (nonatomic, copy) NSString* cellid;
@property (nonatomic, copy) NSArray<Post*>* posts;

-(void) handleCreatePostActionWithTitle:(NSString*) title withPostBody: (NSString*) postBody;
-(void) presentPostAlert;
-(void) fetchPosts;

@end

@implementation PostsFeedViewController

- (void)viewDidLoad {
    _cellid = @"cellid";
    _posts = [[NSArray alloc] init];
    
    
//    Used for initial setup
//    NSDictionary* sampleDict = @{
//        @"id": @1,
//        @"title": @"Hello World!",
//        @"body": @"Sample body"
//    };
//    Post* sampleObj = [[Post alloc] initWithDictionary:sampleDict];
//    _posts = [_posts arrayByAddingObject:sampleObj];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:self.cellid];
    
    self.navigationController.navigationBar.prefersLargeTitles = YES;
    self.navigationItem.title = @"Posts";
    
    UIBarButtonItem* createPostButton = [[UIBarButtonItem alloc] initWithTitle:@"Create" style:UIBarButtonItemStylePlain target:self action: @selector(presentPostAlert)];
    self.navigationItem.rightBarButtonItem = createPostButton;
    [self.tableView reloadData];
}

- (void)viewIsAppearing:(BOOL)animated {
    [super viewIsAppearing: animated];
    
    [self fetchPosts];
}

-(void) handleCreatePostActionWithTitle:(NSString*) title withPostBody: (NSString*) postBody {
    __weak typeof(self) weakSelf = self;
    
    [APIClientService.sharedInstance createPost:title
                      withPostBody:postBody
                      withCompletionHandler:^(NSError * _Nullable error) {
        __strong typeof(self) strongSelf = weakSelf;
        
        if (strongSelf) {
            if (error) {
                NSLog(@"%@", error.localizedDescription);
                [self showErrorAlert];
                return;
            } else {
                [strongSelf fetchPosts];
                return;
            }
            
        } else {
            NSLog(@"Unable to retain reference to self");
            [self showErrorAlert];
        }
    }];
}

- (void)presentPostAlert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"New Post"
                                message:@"Enter title and body"
                                preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Title";
    }];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Post Body";
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel"
                             style:UIAlertActionStyleCancel
                             handler:nil];
    
    __weak typeof(self) weakSelf = self;
    UIAlertAction *submit = [UIAlertAction actionWithTitle:@"Submit"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * _Nonnull action) {
        
        __strong typeof(self) strongSelf = weakSelf;
        
        if (!strongSelf) {
            return;
        }
        
        UITextField *titleField = alert.textFields.firstObject;
        UITextField *bodyField = alert.textFields.lastObject;
        
        NSString *title = titleField.text ?: @"";
        NSString *body  = bodyField.text ?: @"";
        
        [strongSelf handleCreatePostActionWithTitle:title withPostBody:body];
    }];
    
    [alert addAction:cancel];
    [alert addAction:submit];
    
    [self presentViewController:alert animated:YES completion:nil];
}

-(void) showErrorAlert {
    UIAlertController * alertController = [[UIAlertController alloc] init];
    alertController.title = @"Oops! Something went wrong";
    
    UIAlertAction* dismissAction = [UIAlertAction actionWithTitle:@"Something went wrong!" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        // DO nothing
    }];
    
    [alertController addAction:dismissAction];
    [self presentViewController:alertController animated:YES completion:NULL];
}

-(void) fetchPosts {
    __weak typeof(self) weakSelf = self;
    
    [APIClientService.sharedInstance fetchPosts:^(NSArray<Post *> * _Nullable posts, NSError * _Nullable error) {
        __strong typeof(self) strongSelf = weakSelf;
        
        if (!strongSelf) {
            NSLog(@"Strong Self Does not Exist");
            [self showErrorAlert];
            return;
        }
        
        if (error) {
            [self showErrorAlert];
            return;
        }
        
        if (posts) {
            NSLog(@"@%@", posts);
            weakSelf.posts = posts;
            [weakSelf.tableView reloadData];
            return;
        }
    }];
}

- (void) deletePostWithPostIdOnIndexPath: (NSIndexPath*) indexPath {
    NSInteger postId = self.posts[indexPath.row].postId;
    
    __weak typeof(self) weakSelf = self;

    [APIClientService.sharedInstance deletePostWithPostId:postId withCompletionHandler:^(NSError * _Nullable error) {
        
        __strong typeof(self) strongSelf = weakSelf;
        
        if (!strongSelf) {
            NSLog(@"Unable to retain strong reference to self");
            [strongSelf showErrorAlert];
            return;
        }
        
        if (error) {
            NSLog(@"%@", error.localizedDescription);
            [strongSelf showErrorAlert];
            return;
        }
        
        [strongSelf fetchPosts];
    }];
}

#pragma MARK: - UITableView methods

- (void)tableView:(UITableView *)tableView
        didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell* cell = [[UITableViewCell alloc]
                             initWithStyle:UITableViewCellStyleSubtitle
                             reuseIdentifier:_cellid];
    
    Post* post = self.posts[indexPath.row];
    cell.textLabel.text = post.title;
    cell.detailTextLabel.text = post.body;
    cell.tag = post.postId;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.posts.count;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
    forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self deletePostWithPostIdOnIndexPath:indexPath];
    }
}
@end

