//
//  PropertiesRuntimeHelper.h
//  Jdimo
//
//  Created by Elad Ossadon on 12/14/11.
//  http://devign.me | http://elad.ossadon.com | http://twitter.com/elado
//

@interface PropertiesRuntimeHelper : NSObject

+ (NSArray *)propertyNames:(Class)klass;

@end


/*
@interface NSObject (extendedProperties)

+ (instancetype)newWithProperties:(NSDictionary *)properties;
- (instancetype)initWithProperties:(NSDictionary *)properties;
- (NSArray *)allPropertyKeys;

@end
*/
