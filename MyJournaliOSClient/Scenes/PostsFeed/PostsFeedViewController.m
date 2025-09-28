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

-(void) handleCreatePostAction;
-(void) fetchPosts;

@end

@implementation PostsFeedViewController

- (void)viewDidLoad {
    _cellid = @"cellid";
    _posts = [[NSArray alloc] init];
    
    NSDictionary* sampleDict = @{
        @"id": @1,
        @"title": @"Hello World!",
        @"body": @"Sample body"
    };
    
    Post* sampleObj = [[Post alloc] initWithDictionary:sampleDict];
    
//    Used for initial setup
//    _posts = [_posts arrayByAddingObject:sampleObj];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:self.cellid];
    
    self.navigationController.navigationBar.prefersLargeTitles = YES;
    self.navigationItem.title = @"Posts";
    
    UIBarButtonItem* createPostButton = [[UIBarButtonItem alloc] initWithTitle:@"Create" style:UIBarButtonItemStylePlain target:self action: @selector(handleCreatePostAction)];
    self.navigationItem.rightBarButtonItem = createPostButton;
    [self.tableView reloadData];
}

- (void)viewIsAppearing:(BOOL)animated {
    [super viewIsAppearing: animated];
    
    [self fetchPosts];
}

-(void) handleCreatePostAction {
    
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:self.cellid];
    Post* post = self.posts[indexPath.row];
    cell.textLabel.text = post.title;
    cell.detailTextLabel.text = post.body;
    cell.tag = post.postId;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.posts.count;
}

@end

