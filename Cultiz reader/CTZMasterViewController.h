//
//  CTZMasterViewController.h
//  Cultiz reader
//
//  Created by Tristan on 24/05/2014.
//  Copyright (c) 2014 Cultiz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CTZMasterViewController : UITableViewController
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingAnimation;
@property (strong, nonatomic) NSData *resultFromAPI;
@property (strong, nonatomic) NSArray *articleList;
@property (strong, nonatomic) NSString *apiStatus;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (nonatomic) int pageCount;
@property (nonatomic) int currentPage;
@end
