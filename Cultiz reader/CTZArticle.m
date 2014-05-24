//
//  CTZArticle.m
//  Cultiz reader
//
//  Created by Tristan on 24/05/2014.
//  Copyright (c) 2014 Cultiz. All rights reserved.
//

#import "CTZArticle.h"

@implementation CTZArticle

- (void)articleBuilder:(NSArray *)articleList
{
    for (NSString *key in articleList) {
        NSLog(@"%@ => %@", key, [articleList valueForKey:key]);
        if ([self respondsToSelector:NSSelectorFromString(key)]) {
            NSLog(@"%@ => %@", key, [articleList valueForKey:key]);
            [self setValue:[articleList valueForKey:key] forKey:key];
        }
    }
}

@end