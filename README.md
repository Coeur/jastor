Jdimo
===

Jdimo is an Objective-C base class that is initialized with a dictionary (probably from your JSON response), and assigns dictionary values to all its (derived class's) typed @properties.

It supports nested types, arrays, NSString, NSNumber, NSDate and more.

Jdimo is NOT a JSON parser. For that, you have NSJSONSerialization.

The name sounds like **JSON Dictionary to Model Object**. Or something.


Examples
---

You have the following JSON:

```json
{
	"name": "Foo",
	"amount": 13
}
```

and the following class:

```objc
@interface Product
@property (nonatomic, copy) NSString *name;
@property (nonatomic, retain) NSNumber *amount;
@end

@implementation Product
@end
```

with Jdimo, you can just inherit from `ObjectModel` class, and use `initWithDictionary:`

```objc
// Product.h
@interface Product : ObjectModel
@property (nonatomic, copy) NSString *name;
@property (nonatomic, retain) NSNumber *amount;
@end

// Product.m
@implementation Product
@end

// Some other code
NSDictionary *dictionary = /* parse the JSON response to a dictionary */;
Product *product = [[Product alloc] initWithDictionary:dictionary];

// Log
product.name // => Foo
product.amount // => 13
```

Nested Objects
---
Jdimo also converts nested objects to their destination type:

```js
// JSON
{
	"name": "Foo",
	"category": {
		"name": "Bar Category"
	}
}
```

```objc
// ProductCategory.h
@interface ProductCategory : Jdimo
@property (nonatomic, copy) NSString *name;
@end

// ProductCategory.m
@implementation ProductCategory
@end

// Product.h
@interface Product : ObjectModel
@property (nonatomic, copy) NSString *name;
@property (nonatomic, retain) ProductCategory *category;
@end

// Product.m
@implementation Product
@end


// Code
NSDictionary *dictionary = /* parse the JSON response to a dictionary */;
Product *product = [[Product alloc] initWithDictionary:dictionary];

// Log
product.name // => Foo
product.category // => <ProductCategory>
product.category.name // => Bar Category
```

Arrays
---
Having fun so far?

Jdimo also supports arrays of a certain type:

```js
// JSON
{
	"name": "Foo",
	"categories": [
		{ "name": "Bar Category 1" },
		{ "name": "Bar Category 2" },
		{ "name": "Bar Category 3" }
	]
}
```

```objc
// ProductCategory.h
@interface ProductCategory : Jdimo
@property (nonatomic, copy) NSString *name;
@end

// ProductCategory.m
@implementation ProductCategory
@end

// Product.h
@interface Product : ObjectModel
@property (nonatomic, copy) NSString *name;
@property (nonatomic, retain) NSArray *categories;
@end

// Product.m
@implementation Product

+ (Class)categories_class {
	return [ProductCategory class];
}

@end


// Code
NSDictionary *dictionary = /* parse the JSON response to a dictionary */;
Product *product = [[Product alloc] initWithDictionary:dictionary];

// Log
product.name // => Foo
product.categories // => <NSArray>
[product.categories count] // => 3
[product.categories objectAtIndex:1] // => <ProductCategory>
[[product.categories objectAtIndex:1] name] // => Bar Category 2
```

Notice the declaration of 

```objc
+ (Class)categories_class {
	return [ProductCategory class];
}
```

it tells Jdimo what class of items the array holds.


Nested + Arrays = Trees
---
Jdimo can handle trees of data:

```js
// JSON
{
	"name": "1",
	"children": [
		{ "name": "1.1" },
		{ "name": "1.2",
		  children: [
			{ "name": "1.2.1",
			  children: [
				{ "name": "1.2.1.1" },
				{ "name": "1.2.1.2" },
			  ]
			},
			{ "name": "1.2.2" },
		  ]
		},
		{ "name": "1.3" }
	]
}
```

```objc
// ProductCategory.h
@interface ProductCategory : Jdimo
@property (nonatomic, copy) NSString *name;
@property (nonatomic, retain) NSArray *children;
@end

// ProductCategory.m
@implementation ProductCategory

+ (Class)children_class {
	return [ProductCategory class];
}

@end


// Code
NSDictionary *dictionary = /* parse the JSON response to a dictionary */;
ProductCategory *category = [[ProductCategory alloc] initWithDictionary:dictionary];

// Log
category.name // => 1
category.children // => <NSArray>
[category.children count] // => 3
[category.children objectAtIndex:1] // => <ProductCategory>
[[category.categories objectAtIndex:1] name] // => 1.2

[[[category.children objectAtIndex:1] children] objectAtIndex:0] // => <ProductCategory>
[[[[category.children objectAtIndex:1] children] objectAtIndex:0] name] // => 1.2.1.2
```

How does it work?
---
Runtime API. The class's properties are read in runtime and assigns all values from dictionary to these properties with `NSObject setValue:forKey:`. For Dictionaries, Jdimo instantiates a new class, based on the property type, and issues another `initWithDictionary`. Arrays are only a list of items such as strings (which are not converted) or dictionaries (which are treated the same as other dictionaries).

Installation
---
Just copy Jdimo.m+.h and JdimoRuntimeHelper.m+.h to your project, create a class, inherit, use the `initWithDictionary` and enjoy!

Or `pod 'jdimo'`

Testing
---

In Xcode, hit CMD+U under iPhone simulator scheme.

REALLY Good to know
---

**Jdimo classes also conforms to NSCoding protocol**

So you get `initWithCoder`/`encodeWithCoder` for free.

**You can look at the tests for real samples**.

Alternatives
---

* [NSObject+setValuesForKeysWithJSONDictionary](https://gist.github.com/atomicbird/1592634)
* [KVCObjectMapping](https://github.com/tuyennguyencanada/KVCObjectMapping)
* [RestKit](http://restkit.org/)


Contributors
---

* **Antoine Coeur** [@Coeur](http://github.com/Coeur)
* **Elad Ossadon** [@elado](http://twitter.com/elado)
* **Yosi Taguri** [@yosit](http://github.com/yosit)
