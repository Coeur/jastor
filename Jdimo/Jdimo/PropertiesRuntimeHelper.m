//
//  PropertiesRuntimeHelper.m
//  Jdimo
//
//  Created by Elad Ossadon on 12/14/11.
//  http://devign.me | http://elad.ossadon.com | http://twitter.com/elado
//

#import <objc/runtime.h>
#import "PropertiesRuntimeHelper.h"

@implementation PropertiesRuntimeHelper

static NSMutableDictionary *propertyListByClass;

+ (NSArray *)propertyNames:(Class)klass {
    if (klass == [NSObject self]) {
        // empty propertyList for the Topclass
        return @[];
    }
    
    // Retreiving propertyNames from Superclass
    NSArray *superPropertyNames = [PropertiesRuntimeHelper propertyNames:class_getSuperclass(klass)];
    
    // Checking if (partial) propertyList is in cache
	if (!propertyListByClass) {
        propertyListByClass = [NSMutableDictionary dictionaryWithCapacity:1];
    }
	NSString *className = NSStringFromClass(klass);
	NSArray *value = propertyListByClass[className];
	if (value) {
		return [value arrayByAddingObjectsFromArray:superPropertyNames];
	}
	
	unsigned int propertyCount = 0;
	objc_property_t *properties = class_copyPropertyList(klass, &propertyCount);
	NSMutableArray *propertyNamesArray = [NSMutableArray arrayWithCapacity:propertyCount];
	
	for (unsigned int i = 0; i < propertyCount; ++i) {
		objc_property_t property = properties[i];
		const char * name = property_getName(property);
		[propertyNamesArray addObject:@(name)];
	}
	free(properties);
	
    // Saving (partial) propertyList in cache
	propertyListByClass[className] = propertyNamesArray;
    
    // Building full propertyList
	[propertyNamesArray addObjectsFromArray:superPropertyNames];
    
    // Returning full propertyList
    return propertyNamesArray;
}

@end


/*
@implementation NSObject (extendedProperties)

+ (instancetype)newWithProperties:(NSDictionary *)properties
{
    return [[self alloc] initWithProperties:properties];
}

- (instancetype)initWithProperties:(NSDictionary *)properties
{
    if (self = [self init])
    {
        [self setValuesForKeysWithDictionary:properties];
    }
    return self;
}

- (NSDictionary *)allProperties
{
    return [self dictionaryWithValuesForKeys:[self allPropertyKeys]];
}

- (NSArray *)allPropertyKeys
{
    return [PropertiesRuntimeHelper propertyNames:[self class]];
}

@end
*/
