//
//  NSObject+as.m
//  Jdimo
//
//  Created by Antoine Cœur on 16/12/2013.
//
//

#import "NSObject+as.h"

@implementation NSObject (as)

- (id)as:(Class)class
{
    if ([self isKindOfClass:class])
        return self;
    return nil;
}

@end
