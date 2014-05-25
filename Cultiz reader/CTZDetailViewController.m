//
//  CTZDetailViewController.m
//  Cultiz reader
//
//  Created by Tristan on 24/05/2014.
//  Copyright (c) 2014 Cultiz. All rights reserved.
//

#import "CTZDetailViewController.h"
#import "CTZArticle.h"

@interface CTZDetailViewController ()
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIImageView *coverImage;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *authorLabel;
@property (strong, nonatomic) IBOutlet UIWebView *contentWebView;
@property (strong, nonatomic) IBOutlet UINavigationItem *navBar;
@end

@implementation CTZDetailViewController

#pragma mark - Managing the detail item

- (void)getArticleFromMaster:(NSDictionary *)article
{
    //self._article = article;
    //NSLog(@"%@", self._article);
    CTZArticle *tempArticle         = [[CTZArticle alloc] init];
    //NSLog(@"self.resultFromAPI[indexPath.row]: %@",self.resultFromAPI[indexPath.row]);
    [tempArticle articleBuilder:article];
    //[self.articleList addObject:article];
    //NSLog(@"article: %@",self.resultFromAPI[indexPath.row]);
    // Update the view.
    [self displayArticle:tempArticle];
}

- (void)displayArticle:(CTZArticle *)article
{
    // Update the user interface for the detail item.

    if (article) { // user comes from the menu (MasterView)
        NSLog(@"%@",article);
        // set coverImage
        NSArray *thumbnail          = [article.thumbnail_images valueForKey:@"post"];
        NSURL *thumbnail_url        = [NSURL URLWithString:[thumbnail valueForKey:@"url"]];
        NSData *imageData           = [[NSData alloc] initWithContentsOfURL: thumbnail_url];
        UIImage *image              = [UIImage imageWithData: imageData];
        self.coverImage.image       = image;
        
        // set titleLabel
        NSLog(@"%@",article.title);
        self.titleLabel.numberOfLines   = 0;
        self.titleLabel.text            = article.title;
        [self.titleLabel sizeToFit];
        // and view title
        self.navBar.title = article.title;
        
        // set authorLabel
        self.authorLabel.numberOfLines  = 0;
        self.authorLabel.text           = [NSString stringWithFormat:@"par %@", article.author];
        [self.titleLabel sizeToFit];
    } else {
        NSLog(@"Something went wrong, _article is null");
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    //[self displayArticle];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
