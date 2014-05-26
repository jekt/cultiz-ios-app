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
                [article setValue:[articleDic valueForKey:key] forKey:key];
            }
        }
        NSLog(@"article in builder %@", article);
        [articles addObject:article];
    }
    
    return articles;
}


@end
