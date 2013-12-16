#import "ProductCategory.h"

@implementation ProductCategory

@synthesize name, children;

+ (Class)children_class { // used by Jdimo
	return [ProductCategory class];
}

@end
