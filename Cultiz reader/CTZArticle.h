//
//  CTZArticle.h
//  Cultiz reader
//
//  Created by Tristan on 24/05/2014.
//  Copyright (c) 2014 Cultiz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CTZArticle : NSObject

@property (strong, nonatomic) NSString *id;
@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) NSArray  *categories;
@property (strong, nonatomic) NSArray  *tags;
@property (strong, nonatomic) NSString *author;
@property (strong, nonatomic) NSArray  *thumbnail_images;
@property (strong, nonatomic) NSString *thumbnail_small;
@property (strong, nonatomic) NSString *thumbnail_big;
@property (strong, nonatomic) NSString *prev_article_id;

//+ (void)articleBuilder:(NSDictionary *)articleData;

@end
