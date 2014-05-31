//
//  CTZMasterViewController.m
//  Cultiz reader
//
//  Created by Tristan on 24/05/2014.
//  Copyright (c) 2014 Cultiz. All rights reserved.
//

#import "CTZMasterViewController.h"
#import "CTZDetailViewController.h"
#import "AFNetworking.h"
#import "CTZArticle.h"
#import "CTZArticleBuilder.h"

#define COUNT 10

@interface CTZMasterViewController ()
@end

@implementation CTZMasterViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.currentPage = 1;
	// Do any additional setup after loading the view, typically from a nib.
    [self.loadingAnimation startAnimating];
    self.loadingAnimation.hidesWhenStopped = YES;
    self.refreshControl = [[UIRefreshControl alloc]init];
    [self.tableView addSubview:self.refreshControl];
    [self.refreshControl addTarget:self action:@selector(refreshArticleList) forControlEvents:UIControlEventValueChanged];
    [self getArticleList:self.currentPage];
}

- (void)refreshArticleList
{
    [self getArticleList:self.currentPage];
    [self.refreshControl endRefreshing];
}

-(void)getArticleList:(int)page
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://cultiz.com/api/get_posts/?count=%d&page=%d", COUNT, page]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //AFNetworking asynchronous url request
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // getting API status and total page count
        self.apiStatus = [responseObject objectForKey:@"status"];
        self.pageCount = [[responseObject objectForKey:@"count_total"] integerValue];
        
        if ([self.apiStatus  isEqual:@"ok"]) {
            NSLog(@"ArticleList received from API");
            
            if (self.articleList == nil || [self.articleList count] == 0) {
                self.articleList = [CTZArticleBuilder articleListFromJSON:[responseObject objectForKey:@"posts"]];
            } else {
                self.articleList = [self.articleList arrayByAddingObjectsFromArray:[CTZArticleBuilder articleListFromJSON:[responseObject objectForKey:@"posts"]]];
            }
            [self.tableView reloadData];
            [self.loadingAnimation stopAnimating];
        } else {
            // API status is not OK
            NSLog(@"API status is not OK");
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Request Failed: %@, %@", error, error.userInfo);
        
    }];
    
    [operation start];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.articleList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    CTZArticle *article         = self.articleList[indexPath.row];
    NSLog(@"articleList[indexPath.row]: %@",self.articleList[indexPath.row]);
    
    NSAttributedString *plainTitle = [[NSAttributedString alloc]
                                      initWithData:[article.title dataUsingEncoding:NSUTF8StringEncoding]
                                      options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                                NSCharacterEncodingDocumentAttribute:
                                                    [NSNumber numberWithInt:NSUTF8StringEncoding]
                                                }
                                      documentAttributes:nil
                                      error:nil];
    cell.textLabel.text         = [NSString stringWithFormat:@"%@", plainTitle.string];
    NSLog(@"%@", cell.textLabel.text);
    cell.detailTextLabel.text   = [NSString stringWithFormat:@"par %@", [article.author valueForKey:@"name"]];
    
    NSArray *thumbnail_cell     = [article.thumbnail_images valueForKey:@"thumbnail"];
    NSURL *thumbnail_cell_url   = [NSURL URLWithString:[thumbnail_cell valueForKey:@"url"]];
    NSData *imageData           = [[NSData alloc] initWithContentsOfURL: thumbnail_cell_url];
    cell.imageView.image        = [UIImage imageWithData: imageData];
    
    if (indexPath.row == (self.articleList.count-1)) {
        [self getNextPage];
    }
    
    return cell;
}

-   (void)getNextPage
{
    if (self.currentPage < self.pageCount) {
        [self.loadingAnimation startAnimating];
        self.loadingAnimation.hidesWhenStopped = YES;
        self.currentPage++;
        NSLog(@"Current page: %d",self.currentPage);
        [self getArticleList:self.currentPage];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        [[segue destinationViewController] getArticleFromMaster:self.articleList[indexPath.row]];
    }
}

@end
