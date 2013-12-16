#import "Jdimo.h"

@interface ProductCategory : ObjectModel

@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSArray *children;

@end
