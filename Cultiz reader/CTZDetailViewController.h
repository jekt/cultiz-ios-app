//
//  CTZDetailViewController.h
//  Cultiz reader
//
//  Created by Tristan on 24/05/2014.
//  Copyright (c) 2014 Cultiz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CTZArticle.h"

@interface CTZDetailViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIImageView *coverImage;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *authorLabel;
@property (strong, nonatomic) IBOutlet UIWebView *contentWebView;
@property (strong, nonatomic) IBOutlet UINavigationItem *navBar;

@property (strong, nonatomic) CTZArticle *article;

- (void)getArticleFromMaster:(CTZArticle *)article;
- (void)displayArticle;
@end
