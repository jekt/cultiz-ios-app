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
	// Do any additional setup after loading the view, typically from a nib.
    [self getArticleList:1];
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
        //self.pageCount = [[responseObject objectForKey:@"count_total"] integerValue];
        
        if ([self.apiStatus  isEqual:@"ok"]) {
            self.resultFromAPI = [responseObject objectForKey:@"posts"];
            NSLog(@"ArticleList received from API");
            [self.tableView reloadData];
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
    return self.resultFromAPI.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    CTZArticle *article         = [[CTZArticle alloc] init];
    NSLog(@"self.resultFromAPI[indexPath.row]: %@",self.resultFromAPI[indexPath.row]);
    [article articleBuilder:self.resultFromAPI[indexPath.row]];
    //[self.articleList addObject:article];
    //NSLog(@"article: %@",self.resultFromAPI[indexPath.row]);
    
    cell.textLabel.text         = article.title;
    cell.detailTextLabel.text   = [NSString stringWithFormat:@"par %@", [article.author valueForKey:@"name"]];
    
    NSArray *thumbnail_cell = [article.thumbnail_images valueForKey:@"thumbnail"];
    NSURL *thumbnail_cell_url = [NSURL URLWithString:[thumbnail_cell valueForKey:@"url"]];
    
    NSData * imageData = [[NSData alloc] initWithContentsOfURL: thumbnail_cell_url];
    cell.imageView.image = [UIImage imageWithData: imageData];
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        [[segue destinationViewController] getArticleFromMaster:self.resultFromAPI[indexPath.row]];
    }
}

@end
