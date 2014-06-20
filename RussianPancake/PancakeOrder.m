//
//  PancakeOrder.m
//  RussianPancake
//
//  Created by Oleg Pochtovy on 19.06.14.
//  Copyright (c) 2014 Oleg Pochtovy. All rights reserved.
//

// This class will represent the order and the operations that go along with an order: adding an item, removing an item, calculating the total for the order, and printing out an overview of the order.

#import "PancakeOrder.h"
#import "PancakeItem.h"

@implementation PancakeOrder

@synthesize orderItems;

// This method isn’t directly useful, but will be necessary in accessing the item dictionary.
- (PancakeItem *)findKeyForOrderItem:(PancakeItem *)searchItem {
    // find the matching item index
    NSIndexSet *indexes = [[self.orderItems allKeys] indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        PancakeItem *key = obj;
        //return [searchItem.name isEqualToString:key.name] && searchItem.price == key.price; // we remove this string cause we implemented methods isEqual: and hash: in PancakeOrder.m
        return [searchItem isEqual:key];
    }]; // we use the indexesOfObjectsPassingTest: method to find the keys that match the name and price
    // This method indexesOfObjectsPassingTest: works on an array and uses the Block to compare two objects to return the indexes of all the objects that pass any specific test specified by the the Block.
    
    // return first matching item
    if ([indexes count] >=1) {
        PancakeItem *key = [[self.orderItems allKeys] objectAtIndex:[indexes firstIndex]];
        return key;
    }
    
    // if nothing is found
    return nil;
}

// the getter for the orderItems property. If orderItems has been assigned something, it returns that object. If it hasn’t been assigned anything, it creates a new dictionary and assigns that to orderItems, and then returns it.
- (NSMutableDictionary *)orderItems {
    if (!orderItems) {
        orderItems = [NSMutableDictionary new];
    }
    return orderItems;
}

// orderDescription method will sort the order items by name and provide the string used when the app prints on the chalkboard.
- (NSString *)orderDescription {
    // create description string. Each item in the order will be appended to this string.
    NSMutableString *orderDescription = [NSMutableString new];
    
    // sort the order items by name
    NSArray *keys = [[self.orderItems allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        PancakeItem *item1 = (PancakeItem *)obj1;
        PancakeItem *item2 = (PancakeItem *)obj2;
        return [item1.name compare:item2.name];
    }];
    
    // enumerate items and add item name and quantity to description
    [keys enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        PancakeItem *item = (PancakeItem *)obj;
        NSNumber *quantity = (NSNumber *)[self.orderItems objectForKey:item];
        [orderDescription appendFormat:@"%@ x%@\n", item.name, quantity];
    }];
    
    // return the orderDescription string, but again we return a copy of it so that it’s an immutable version
    return [orderDescription copy];
}

// the addItemToOrder method will add an item to the order
- (void)addItemToOrder:(PancakeItem *)inItem {
    // find item in order list - we use the method findKeyForOrderItem to find the key for the orderItem dictionary entry. If the object isn’t found, it simply returns nil.
    PancakeItem *key = [self findKeyForOrderItem:inItem];
    
    // if the object wasn’t found in the order at this point, add the item to the order with a quantity of 1
    if (!key) {
        [self.orderItems setObject:[NSNumber numberWithInt:1] forKey:inItem];
    } else {
        // if the object was found, we read the quantity value, store it, and increment it
        NSNumber *quantity = [self.orderItems objectForKey:key];
        int intQuantity = [quantity intValue];
        intQuantity++;
        
        // update order items list with new quantity
        [self.orderItems removeObjectForKey:key];
        [self.orderItems setObject:[NSNumber numberWithInt:intQuantity] forKey:key];
    }
}

// the removeItemFromOrder: method will remove an item from the order
- (void)removeItemFromOrder:(PancakeItem *)inItem {
    // find the item in order list
    PancakeItem *key = [self findKeyForOrderItem:inItem];
    
    // we remove the item only it it exists
    if (key && ([[[self orderItems] objectForKey:key] intValue] > 0)) {
        // get the quantity and decrement by one
        NSNumber *quantity = [[self orderItems] objectForKey:key];
        int intQuantity = [quantity intValue];
        intQuantity--;
        
        // remove object from array
        [[self orderItems] removeObjectForKey:key];
        
        // add a new object with updated quantity only if quantity > 0
        if (quantity > 0) {
            [[self orderItems] setObject:[NSNumber numberWithInt:intQuantity] forKey:key];
        }
    }
}

// the method totalOrder totals the order and returns the result
- (float)totalOrder {
    // define and initialize the total variable
    __block float total = 0.0;
    
    // block for calculating total
    float (^itemTotal)(float, int) = ^float(float price, int quantity) {
        return price * quantity;
    };
    
    // enumerate order items to get total - This code segment goes over every object in the orderItems dictionary using a Block method, enumerateKeysAndObjectsUsingBlock: and uses the previous Block variable to find the total for each item for the quantity ordered and then adds that to the grand total (which is why we needed the __block keyword on the total variable since it is being modified inside of a Block).
    [self.orderItems enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        PancakeItem *item = (PancakeItem *)key;
        NSNumber *quantity = (NSNumber *)obj;
        int intQuantity = [quantity intValue];
        total += itemTotal(item.price, intQuantity);
    }];
    
    return total;
}

@end
