//
//  CTZDetailViewController.m
//  Cultiz reader
//
//  Created by Tristan on 24/05/2014.
//  Copyright (c) 2014 Cultiz. All rights reserved.
//

#import "CTZDetailViewController.h"
#import "CTZArticle.h"
#import <FacebookSDK/FacebookSDK.h>

@interface CTZDetailViewController ()
@end

@implementation CTZDetailViewController

#pragma mark - Managing the detail item

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc]
                                    initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                    target:self
                                    action:@selector(shareActionSheet)];
    self.navigationItem.rightBarButtonItem = shareButton;
    [self displayArticle];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
        self.navBar.title           = self.article.title;
        
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
                                 self.article.thumbnail_big,
                                 self.article.title,
                                 self.article.author,
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

# pragma mark - Sharing actions

-(void)shareActionSheet
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"Annuler"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Publier sur Facebook",
                                                                      @"Envoyer par message",
                                                                      @"Autres options...",
                                                                      nil];
    
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"The %d button was tapped: %@", buttonIndex, [actionSheet buttonTitleAtIndex:buttonIndex]);
    switch (buttonIndex) {
        case 0: // "Publier sur Facebook"
            [self fbShareDialog];
            break;
            
        case 1: // "Envoyer par message"
            [self fbMessengerDialog];
            break;
            
        /*case 2:  // "Commenter"
            
            break;*/
            
        case 2: // "Autres options..."
            [self iOSDefaultSharing];
            break;
            
        default:
            break;
    }
}

-(void)fbShareDialog
{
    // Check if the Facebook app is installed and we can present the share dialog
    FBLinkShareParams *params = [[FBLinkShareParams alloc] init];
    params.link = [NSURL URLWithString:self.article.url];
    NSLog(@"%@",params.link);
    
    // If the Facebook app is installed and we can present the share dialog
    if ([FBDialogs canPresentShareDialogWithParams:params]) {
        // Present the share dialog
        NSLog(@"Share Dialog");
        [FBDialogs presentShareDialogWithLink:params.link
                                      handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
                                          if(error) {
                                              // An error occurred, we need to handle the error
                                              // See: https://developers.facebook.com/docs/ios/errors
                                              NSLog(@"Error publishing story: %@", error.description);
                                          } else {
                                              // Success
                                              NSLog(@"result %@", results);
                                          }
                                      }];
    } else {
        // Facebook App is not installed, prompt what to do next
        NSString *msg        = @"Tu n'as pas installé l'app Facebook. Veux-tu voir les autres options de partage à la place ?";
        [self sharingAppNotInstalled:msg];
        
    }
}

- (void)fbMessengerDialog
{
    // Check if the Facebook app is installed and we can present
    // the message dialog
    FBLinkShareParams *params = [[FBLinkShareParams alloc] init];
    /*params.link =
    [NSURL URLWithString:self.article.url];
    params.name = self.article.title;
    params.caption = @"Cultiz";
    params.picture = [NSURL URLWithString:self.article.thumbnail_big];
    params.linkDescription = self.article.excerpt;*/
    
    // If the Facebook app is installed and we can present the share dialog
    if ([FBDialogs canPresentMessageDialogWithParams:params]) {
        // Enable button or other UI to initiate launch of the Message Dialog
        [FBDialogs presentMessageDialogWithLink:[NSURL URLWithString:self.article.url]
                                        handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
                                            if(error) {
                                                // An error occurred, we need to handle the error
                                                // See: https://developers.facebook.com/docs/ios/errors
                                                NSLog(@"Error messaging link: %@", error.description);
                                            } else {
                                                // Success
                                                NSLog(@"result %@", results);
                                            }
                                        }];
    }  else {
        // Disable button or other UI for Message Dialog
        NSString *msg        = @"Tu n'as pas installé l'app Facebook Messenger. Veux-tu voir les autres options de partage à la place ?";
        [self sharingAppNotInstalled:msg];
    }
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        NSLog(@"user pressed Annuler");
    } else {
        NSLog(@"user pressed Autres options");
        [self iOSDefaultSharing];
    }
}

// A function for parsing URL parameters returned by the Feed Dialog.
- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val =
        [kv[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        params[kv[0]] = val;
    }
    return params;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    BOOL urlWasHandled = [FBAppCall handleOpenURL:url
                                sourceApplication:sourceApplication
                                  fallbackHandler:^(FBAppCall *call) {
                                      NSLog(@"Unhandled deep link: %@", url);
                                      // Here goes the code to handle the links
                                      // Use the links to show a relevant view of your app to the user
                                  }];
    
    return urlWasHandled;
}

- (void)iOSDefaultSharing
{
    NSString *textToShare = [NSString stringWithFormat:@"Matte cet article : %@ (%@) sur Cultiz\n%@", self.article.title, self.article.author, self.article.url];
    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:[NSArray arrayWithObject:textToShare] applicationActivities:nil];
    [self presentViewController:activityController animated:YES completion:nil];
}


- (void)sharingAppNotInstalled:(NSString *)msg
{
    UIAlertView *alert  = [[UIAlertView alloc] initWithTitle:@"Hey !"
                                                     message:msg
                                                    delegate:self
                                           cancelButtonTitle:@"Annuler"
                                           otherButtonTitles:@"Autres options...",
                           nil];
    [alert show];
}

@end
