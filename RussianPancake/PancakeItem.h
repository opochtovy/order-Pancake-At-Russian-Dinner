//
//  PancakeItem.h
//  RussianPancake
//
//  Created by Oleg Pochtovy on 19.06.14.
//  Copyright (c) 2014 Oleg Pochtovy. All rights reserved.
//

// This class holds an item’s attributes. The item will have a name/title, price, and an image file.

#import <Foundation/Foundation.h>

@interface PancakeItem : NSObject <NSCopying>

@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) float price;
@property (nonatomic, strong) NSString *pictureFile;

// here we set up an initializer method. This is just a quick way to set up the default properties when we initialize an instance.
- (id)initWithName:(NSString *)inName andPrice:(float)inPrice andPictureFile:(NSString *)inPictureFile;

// method retrieveInventoryItems - is a class method, which will download and process the inventory items from the web service
+ (NSArray *)retrieveInventoryItems;

@end
