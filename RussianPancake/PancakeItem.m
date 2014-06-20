//
//  PancakeItem.m
//  RussianPancake
//
//  Created by Oleg Pochtovy on 19.06.14.
//  Copyright (c) 2014 Oleg Pochtovy. All rights reserved.
//

// This class holds an item’s attributes. The item will have a name/title, price, and an image file.

#import "PancakeItem.h"

#define kInventoryAddress @"http://www.vip-flat.eu/iOS/inventory/" // the address of our web service (just array in JSON format)

@implementation PancakeItem

@synthesize name, price, pictureFile;

// required method for protocol NSCopying. All this method does is to create a new PancakeItem, set the properties to be exactly the same as the existing object, and return the new object instance.
- (id)copyWithZone:(NSZone *)zone {
    PancakeItem *newItem = [PancakeItem new];
    [newItem setName:[self name]];
    [newItem setPrice:[self price]];
    [newItem setPictureFile:[self pictureFile]];
    
    return newItem;
}

// here we set up an initializer method. This is just a quick way to set up the default properties when we initialize an instance.
- (id)initWithName:(NSString *)inName andPrice:(float)inPrice andPictureFile:(NSString *)inPictureFile {
    if (self = [self init]) {
        [self setName:inName];
        [self setPrice:inPrice];
        [self setPictureFile:inPictureFile];
    }
    
    return self;
}

// method retrieveInventoryItems - is a class method, which will download and process the inventory items from the web service
+ (NSArray *)retrieveInventoryItems {
    // create variables
    NSMutableArray *inventory = [NSMutableArray new];
    NSError *err = nil;
    
    // get inventory data
    NSArray *jsonInventory = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:kInventoryAddress]]
                                                             options:kNilOptions
                                                               error:&err];
    // enumerate inventory objects; we use the enumerateObjectsUsingBlock: method to convert the objects from regular NSDictionaries to PancakeItem class objects
    [jsonInventory enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary *item = obj;
        [inventory addObject:[[PancakeItem alloc] initWithName:[item objectForKey:@"Name"]
                                                  andPrice:[[item objectForKey:@"Price"] floatValue] andPictureFile:[item objectForKey:@"Image"]]];
    }];
    
    // return a copy of the inventory data instead of returning it directly, because we don’t want to return a mutable version. The copy method creates an immutable version we can safely return
    return [inventory copy];
}

// implementations for isEqual: and hash: are needed for NSDictionary to work correctly
- (BOOL)isEqual:(id)object
{
    if ([object isKindOfClass:[self class]])
    {
        PancakeItem *otherItem = object;
        return [self.name isEqualToString:otherItem.name] && self.price == otherItem.price;
    }
    return NO;
}

// Returns an unsigned integer that can be used as a hash table address. If two string objects are equal (as determined by the isEqualToString: method), they must have the same hash value.
- (NSUInteger)hash
{
    return [self.name hash];
}

@end
