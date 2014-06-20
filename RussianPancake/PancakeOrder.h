//
//  PancakeOrder.h
//  RussianPancake
//
//  Created by Oleg Pochtovy on 19.06.14.
//  Copyright (c) 2014 Oleg Pochtovy. All rights reserved.
//

// This class will represent the order and the operations that go along with an order: adding an item, removing an item, calculating the total for the order, and printing out an overview of the order.

#import <Foundation/Foundation.h>

@class PancakeItem;

@interface PancakeOrder : NSObject

// This dictionary will hold the items ordered by the user. This dictionary is a dictionary of key-values pairs. The key will be an PancakeItem and the value will be a NSNumber, specifying how many of that particular item has been ordered
@property (nonatomic, strong) NSMutableDictionary *orderItems;

// This method isn’t directly useful, but will be necessary in accessing the item dictionary.
- (PancakeItem *)findKeyForOrderItem:(PancakeItem *)searchItem;

- (NSMutableDictionary *)orderItems;
// orderDescription method will provide the string used when the app prints on the chalkboard.
- (NSString *)orderDescription;

// the addItemToOrder method will add an item to the order
- (void)addItemToOrder:(PancakeItem *)inItem;
// the removeItemFromOrder: method will remove an item from the order
- (void)removeItemFromOrder:(PancakeItem *)inItem;

// the method totalOrder totals the order and returns the result
- (float)totalOrder;

@end
