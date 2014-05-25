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

- (void)getArticleFromMaster:(NSDictionary *)article;
- (void)displayArticle:(CTZArticle *)article;
@end
