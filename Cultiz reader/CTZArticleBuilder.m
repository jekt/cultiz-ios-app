//
//  CTZArticleBuilder.m
//  Cultiz reader
//
//  Created by Tristan on 26/05/2014.
//  Copyright (c) 2014 Cultiz. All rights reserved.
//

#import "CTZArticleBuilder.h"
#import "CTZArticle.h"

@implementation CTZArticleBuilder

+ (NSArray *)articleListFromJSON:(NSArray *)parsedObject
{
    //NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:objectNotation options:0 error:nil];
    
    NSMutableArray *articles = [[NSMutableArray alloc] init];
    
    /*NSArray *results = [parsedObject valueForKey:@"posts"];
    NSLog(@"Count %d", results.count);
    NSLog(@"results %@", results);*/
    
    for (NSDictionary *articleDic in parsedObject) {
        NSLog(@"for articleDic %@", articleDic);
        CTZArticle *article = [[CTZArticle alloc] init];
        NSLog(@"article init");
        for (NSString *key in articleDic) {
            NSLog(@"for key %@", key);
            if ([article respondsToSelector:NSSelectorFromString(key)]) {
                if ([key isEqual:@"title"]) {
                    NSAttributedString *plainTitle = [[NSAttributedString alloc]
                                                      initWithData:[[articleDic valueForKey:key] dataUsingEncoding:NSUTF8StringEncoding]
                                                      options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                                                NSCharacterEncodingDocumentAttribute:
                                                                    [NSNumber numberWithInt:NSUTF8StringEncoding]
                                                                }
                                                      documentAttributes:nil
                                                      error:nil];
                    NSLog(@"%@",plainTitle);
                    [article setValue:[NSString stringWithFormat:@"%@",
                                                plainTitle.string]
                               forKey:key];
                    NSLog(@"%@",article.title);
                } else if ([key isEqual:@"thumbnail_images"]) {
                    NSArray *thumbnail_cell     = [[articleDic valueForKey:key] valueForKey:@"thumbnail"];
                    NSString *thumbnail_small_url   = [thumbnail_cell valueForKey:@"url"];
                    [article setValue:thumbnail_small_url
                               forKey:@"thumbnail_small"];

                    NSArray *thumbnail_detail     = [[articleDic valueForKey:key] valueForKey:@"post"];
                    NSString *thumbnail_big_url   = [thumbnail_detail valueForKey:@"url"];
                    [article setValue:thumbnail_big_url
                               forKey:@"thumbnail_big"];
                } else if ([key isEqual:@"author"]) {
                    [article setValue:[NSString stringWithFormat:@"par %@",
                                       [[articleDic valueForKey:key]
                                        valueForKey:@"name"]]
                               forKey:@"author"];
                } else {
                    [article setValue:[articleDic valueForKey:key] forKey:key];
                }
            }
        }
        NSLog(@"article in builder %@", article);
        [articles addObject:article];
    }
    
    return articles;
}


@end
