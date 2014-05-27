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
@end

@implementation CTZDetailViewController

#pragma mark - Managing the detail item

- (void)getArticleFromMaster:(CTZArticle *)article
{
    self.article = article;
    NSLog(@"%@", article);
    //CTZArticle *tempArticle         = [[CTZArticle alloc] init];
    //NSLog(@"self.resultFromAPI[indexPath.row]: %@",self.resultFromAPI[indexPath.row]);
    //[tempArticle articleBuilder:article];
    //[self.articleList addObject:article];
    //NSLog(@"article: %@",self.resultFromAPI[indexPath.row]);
    // Update the view.
    //[self displayArticle];
}

- (void)displayArticle
{
    // Update the user interface for the detail item.

    if (self.article) { // user comes from the menu (MasterView)
        NSLog(@"%@",self.article);
        // set coverImage
        NSLog(@"%@",self.article.thumbnail_images);
        NSArray *thumbnail          = [self.article.thumbnail_images valueForKey:@"post"];
        NSURL   *thumbnail_url      = [NSURL URLWithString:[thumbnail valueForKey:@"url"]];
        /*NSData  *imageData          = [[NSData alloc] initWithContentsOfURL: thumbnail_url];
        UIImage *image              = [UIImage imageWithData: imageData];
        self.coverImage.image       = image;
        NSLog(@"coverImage: %@ | image: %@",self.coverImage,image);*/
        
        // set titleLabel
        /*NSLog(@"%@",self.article.title);
        self.titleLabel.numberOfLines   = 0;
        self.titleLabel.text            = self.article.title;
        [self.titleLabel sizeToFit];*/
        // and view title
        self.navBar.title               = self.article.title;
        
        // set authorLabel
        NSLog(@"%@",self.article.author);
        self.authorLabel.numberOfLines  = 0;
        //self.authorLabel.text           = [NSString stringWithFormat:@"par %@", [self.article.author valueForKey:@"name"]];
        NSString *author           = [NSString stringWithFormat:@"par %@", [self.article.author valueForKey:@"name"]];
        //[self.titleLabel sizeToFit];
        
        // set contentWebView
        //NSLog(@"%@",self.article.content);
        NSString *htmlContent = [NSString stringWithFormat:@"<html> \n"
                                 "<head> \n"
                                    "<style type=\"text/css\"> \n"
                                        "body { \n"
                                            "font-family:\"HelveticaNeue-Light\", \"Helvetica Neue Light\", \"Helvetica Neue\", Helvetica; \n"
                                            "font-size:14px; \n"
                                            "line-height:20px; \n"
                                            "width:320px; \n"
                                            "overflow:hidden; \n"
                                            "margin:0; \n"
                                        "}\n"
                                        "#title, #author, #content { \n"
                                            "padding:0 10px 0 10px; \n"
                                        "}\n"
                                        "#title { \n"
                                            "line-height:auto; \n"
                                        "}\n"
                                        "#author { \n"
                                            "font-weight:thin; \n"
                                            "font-weight:thin; \n"
                                            "font-size:12px; \n"
                                        "}\n"
                                    "</style> \n"
                                 "</head> \n"
                                 "<body> \n"
                                 "<div id=\"cover\"><img src=\"%@\" style=\"width:320px;height150px;\" /></div> \n"
                                 "<div id=\"title\"><h1>%@</h1></div> \n"
                                 "<div id=\"author\"><p>%@</p></div> \n"
                                 "<div id=\"content\">%@</div> \n"
                                 "</body> \n"
                                 "</html>",
                                 thumbnail_url,
                                 self.article.title,
                                 author,
                                 self.article.content];
        [self.contentWebView loadHTMLString:htmlContent baseURL:nil];
        [self.contentWebView.scrollView setContentSize: CGSizeMake(self.contentWebView.frame.size.width, self.contentWebView.scrollView.contentSize.height)];
        self.contentWebView.scrollView.alwaysBounceVertical = NO;
        self.contentWebView.scrollView.alwaysBounceHorizontal = NO;
        //CGFloat contentHeight                   = self.contentWebView.scrollView.contentSize.height;
        //self.contentWebView.frame = CGRectMake(self.contentWebView.frame.origin.x, self.contentWebView.frame.origin.y, self.contentWebView.frame.size.width, contentHeight);
        
        /*NSString *result = [self.contentWebView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight;"];
        NSLog(@"%@",result);
        NSLog(@"%f",self.contentWebView.scrollView.contentSize.height);
        NSLog(@"%f",self.contentWebView.frame.size.height);*/
        //[self.contentWebView sizeToFit];
    } else {
        NSLog(@"Something went wrong");
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self displayArticle];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
