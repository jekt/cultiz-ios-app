//
//  CTZArticleBuilder.h
//  Cultiz reader
//
//  Created by Tristan on 26/05/2014.
//  Copyright (c) 2014 Cultiz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CTZArticleBuilder : NSObject
+ (NSArray *)articleListFromJSON:(NSArray *)parsedObject;
@end
