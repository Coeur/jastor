//
//  ObjectModel.h
//  Cœur
//
//  Created by Antoine Cœur on 22/07/13.
//  Copyright (c) 2013 Cœur. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+as.h"// needed to allow using 'as:'
#import <CoreData/CoreData.h>


@interface ObjectModel : NSObject

// creates an instance of the model
+ (instancetype)objectWithDictionary:(NSDictionary *)dictionary;
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

// creates an array of instances of the model
+ (NSMutableArray *)objectArrayWithArray:(NSArray *)array;
// creates a dictionary of instances of the model
+ (NSMutableDictionary *)stringObjectDictionaryWithDictionary:(NSDictionary *)dictionary;

// creates an array of instances of a different class
+ (NSMutableArray *)typedArrayWithArray:(NSArray *)array class:(Class)class;
// creates a dictionary of instances of a different class
+ (NSMutableDictionary *)stringTypedDictionaryWithDictionary:(NSDictionary *)dictionary class:(Class)class;

// exports the model to a dictionary
- (NSMutableDictionary *)toDictionary;

@end
