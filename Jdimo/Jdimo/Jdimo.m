#import "Jdimo.h"
#import "JdimoRuntimeHelper.h"

@implementation ObjectModel

Class nsDictionaryClass;
Class nsArrayClass;

+ (id)objectFromDictionary:(NSDictionary*)dictionary {
    id item = [[self alloc] initWithDictionary:dictionary];
    return item;
}

- (id)initWithDictionary:(NSDictionary *)dictionary {
	if (!nsDictionaryClass) nsDictionaryClass = [NSDictionary class];
	if (!nsArrayClass) nsArrayClass = [NSArray class];
	
	if ((self = [super init])) {
		for (NSString *key in [JdimoRuntimeHelper propertyNames:[self class]]) {

			id value = [dictionary valueForKey:key];
			
			if (value == [NSNull null] || value == nil) {
                continue;
            }
            
            if ([JdimoRuntimeHelper isPropertyReadOnly:[self class] propertyName:key]) {
                continue;
            }
			
			// handle dictionary
			if ([value isKindOfClass:nsDictionaryClass]) {
				Class klass = [JdimoRuntimeHelper propertyClassForPropertyName:key ofClass:[self class]];
				value = [[klass alloc] initWithDictionary:value];
			}
			// handle array
			else if ([value isKindOfClass:nsArrayClass]) {
				Class arrayItemType = [[self class] performSelector:NSSelectorFromString([NSString stringWithFormat:@"%@_class", key])];
				
				NSMutableArray *childObjects = [NSMutableArray arrayWithCapacity:[(NSArray*)value count]];
				
				for (id child in value) {
					if ([[child class] isSubclassOfClass:nsDictionaryClass]) {
						ObjectModel *childDTO = [[arrayItemType alloc] initWithDictionary:child];
						[childObjects addObject:childDTO];
					} else {
						[childObjects addObject:child];
					}
				}
				
				value = childObjects;
			}
			// handle all others
			[self setValue:value forKey:key];
		}
	}
	return self;	
}


- (void)encodeWithCoder:(NSCoder*)encoder {
	for (NSString *key in [JdimoRuntimeHelper propertyNames:[self class]]) {
		[encoder encodeObject:[self valueForKey:key] forKey:key];
	}
}

- (id)initWithCoder:(NSCoder *)decoder {
	if ((self = [super init])) {
		for (NSString *key in [JdimoRuntimeHelper propertyNames:[self class]]) {
            if ([JdimoRuntimeHelper isPropertyReadOnly:[self class] propertyName:key]) {
                continue;
            }
			id value = [decoder decodeObjectForKey:key];
			if (value != [NSNull null] && value != nil) {
				[self setValue:value forKey:key];
			}
		}
	}
	return self;
}

- (NSMutableDictionary *)toDictionary {
	NSMutableDictionary *dic = [NSMutableDictionary dictionary];
	
	for (NSString *key in [JdimoRuntimeHelper propertyNames:[self class]]) {
		id value = [self valueForKey:key];
        if (value && [value isKindOfClass:[ObjectModel class]]) {
            [dic setObject:[value toDictionary] forKey:key];
        } else if (value && [value isKindOfClass:[NSArray class]] && ((NSArray*)value).count > 0) {
            id internalValue = [value objectAtIndex:0];
            if (internalValue && [internalValue isKindOfClass:[ObjectModel class]]) {
                NSMutableArray *internalItems = [NSMutableArray array];
                for (id item in value) {
                    [internalItems addObject:[item toDictionary]];
                }
                [dic setObject:internalItems forKey:key];
            } else {
                [dic setObject:value forKey:key];
            }
        } else if (value != nil) {
            [dic setObject:value forKey:key];
        }
	}
    return dic;
}

- (NSString *)description {
    NSMutableDictionary *dic = [self toDictionary];
	
	return [NSString stringWithFormat:@"#<%@: description = %@>", [self class], [dic description]];
}

- (BOOL)isEqual:(id)object {
	if (object == nil || ![object isKindOfClass:[ObjectModel class]]) return NO;
	
	ObjectModel *model = (ObjectModel *)object;
	
	return [[self toDictionary] isEqualToDictionary:[model toDictionary]];
}

@end
