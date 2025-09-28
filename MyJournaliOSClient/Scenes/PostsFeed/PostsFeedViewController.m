//
//  PostsFeedViewController.m
//  MyJournaliOSClient
//
//  Created by Azizbek Asadov on 27.09.2025.
//

#import "PostsFeedViewController.h"
#import "Post.h"

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
    _posts = [_posts arrayByAddingObject:sampleObj];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:self.cellid];
    
    self.navigationController.navigationBar.prefersLargeTitles = YES;
    self.navigationItem.title = @"Posts";
    
    UIBarButtonItem* createPostButton = [[UIBarButtonItem alloc] initWithTitle:@"Create" style:UIBarButtonItemStylePlain target:self action: @selector(handleCreatePostAction)];
    self.navigationItem.rightBarButtonItem = createPostButton;
    [self.tableView reloadData];
}

-(void) handleCreatePostAction {
    
}

-(void) fetchPosts {
//    [APIClientService.sharedInstance() fetchPosts];
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

