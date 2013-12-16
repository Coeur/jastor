//
//  ObjectModel.m
//  Cœur
//
//  Created by Antoine Cœur on 22/07/13.
//  Copyright (c) 2013 Cœur. All rights reserved.
//

#import <objc/runtime.h>
#import "ObjectModel.h"
#import "NSObject+setValuesForKeysWithJSONDictionary.h"
#import "PropertiesRuntimeHelper.h"


@implementation ObjectModel

+ (instancetype)objectWithDictionary:(NSDictionary *)dictionary
{
    id obj = [[self alloc] initWithDictionary:dictionary];
    return obj;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self)
    {
        [self setValuesForKeysWithJSONDictionary:dictionary dateFormatter:nil];
    }
    return self;
}

+ (NSMutableArray *)objectArrayWithArray:(NSArray *)array
{
    NSMutableArray * mutableArray = [NSMutableArray array];
    for (NSDictionary *d in array) {
        [mutableArray addObject:[self objectWithDictionary:d]];
    }
    return mutableArray;
}
+ (NSMutableDictionary *)stringObjectDictionaryWithDictionary:(NSDictionary *)dictionary
{
    NSMutableDictionary * mutableDictionary = [NSMutableDictionary dictionary];
    for (NSString *k in dictionary) {
        mutableDictionary[k] = [self objectWithDictionary:dictionary[k]];
    }
    return mutableDictionary;
}

+ (NSMutableArray *)typedArrayWithArray:(NSArray *)array class:(Class)class
{
    NSMutableArray * mutableArray = [NSMutableArray array];
    for (id d in array) {
        id object = [d as:class];
        if (object)
            [mutableArray addObject:object];
    }
    return mutableArray;
}
+ (NSMutableDictionary *)stringTypedDictionaryWithDictionary:(NSDictionary *)dictionary class:(Class)class
{
    NSMutableDictionary * mutableDictionary = [NSMutableDictionary dictionary];
    for (NSString *k in dictionary) {
        id object = [dictionary[k] as:class];
        if (object)
            mutableDictionary[k] = object;
    }
    return mutableDictionary;
}


#pragma mark -

- (NSMutableDictionary *)toDictionary {
	NSMutableDictionary *dic = [NSMutableDictionary dictionary];
	
	for (NSString *key in [PropertiesRuntimeHelper propertyNames:[self class]]) {
		id value = [self valueForKey:key];
        if (value && [value isKindOfClass:[ObjectModel self]]) {
            dic[key] = [value toDictionary];
        } else if (value && [value isKindOfClass:[NSArray self]] && [(NSArray *)value count] > 0) {
            id internalValue = value[0];
            if (internalValue && [internalValue isKindOfClass:[ObjectModel self]]) {
                NSMutableArray *internalItems = [NSMutableArray array];
                for (id item in value) {
                    [internalItems addObject:[item toDictionary]];
                }
                dic[key] = internalItems;
            } else {
                dic[key] = value;
            }
        } else if (value != nil) {
            dic[key] = value;
        }
	}
    return dic;
}

- (NSString *)description {
    NSMutableDictionary *dic = [self toDictionary];
	
	return [NSString stringWithFormat:@"#<%@: %@>", [self class], [dic description]];
}

/*
- (void)setValuesForKeysWithDictionary:(NSDictionary *)d
{
    NSMutableDictionary *newDict = [NSMutableDictionary dictionaryWithDictionary:d];
	for (NSString *key in [ObjectModel propertyNames:[self class]]) {
        [newDict setValue:[[newDict valueForKey:key] as:[NSString self]] forKey:key];
    }
    [super setValuesForKeysWithDictionary:newDict];
}
*/

@end
