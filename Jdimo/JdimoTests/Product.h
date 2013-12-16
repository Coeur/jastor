#import "Jastor.h"

@interface Product : Jdimo

@property (nonatomic, strong) ProductCategory *category;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSNumber *amount;
@property (nonatomic, copy) NSDate *createdAt;


@end
