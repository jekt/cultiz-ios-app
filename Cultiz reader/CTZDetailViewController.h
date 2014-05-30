//
//  CTZDetailViewController.h
//  Cultiz reader
//
//  Created by Tristan on 24/05/2014.
//  Copyright (c) 2014 Cultiz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CTZArticle.h"

@interface CTZDetailViewController : UIViewController <UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *contentWebView;
@property (weak, nonatomic) IBOutlet UINavigationItem *navBar;

@property (strong, nonatomic) CTZArticle *article;

- (void)getArticleFromMaster:(CTZArticle *)article;
- (void)displayArticle;
@end
