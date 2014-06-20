//
//  PancakeViewController.h
//  RussianPancake
//
//  Created by Oleg Pochtovy on 19.06.14.
//  Copyright (c) 2014 Oleg Pochtovy. All rights reserved.
//

@class PancakeOrder;

#import <UIKit/UIKit.h>

@interface PancakeViewController : UIViewController {
    int currentItemIndex; // this variable will keep track of which item the user is currently browsing in the inventory
}

@property (weak, nonatomic) IBOutlet UIButton *ibRemoveItemButton;
@property (weak, nonatomic) IBOutlet UIButton *ibAddItemButton;
@property (weak, nonatomic) IBOutlet UIButton *ibPreviousItemButton;
@property (weak, nonatomic) IBOutlet UIButton *ibNextItemButton;
@property (weak, nonatomic) IBOutlet UIButton *ibTotalOrderButton;
@property (weak, nonatomic) IBOutlet UILabel *ibChalkboardLabel;
@property (weak, nonatomic) IBOutlet UIImageView *ibCurrentItemImageView;
@property (weak, nonatomic) IBOutlet UILabel *ibCurrentItemLabel;

@property (nonatomic, strong) NSMutableArray *inventory; // an array of the PancakeItems that we got from the web service
@property (nonatomic, strong) PancakeOrder *order; // an instance of the PancakeOrder class that stores the items currently in the user’s order

- (IBAction)ibaRemoveItem:(id)sender;
- (IBAction)ibaAddItem:(id)sender;
- (IBAction)ibaLoadPreviousItem:(id)sender;
- (IBAction)ibaLoadNextItem:(id)sender;
- (IBAction)ibaCalculateTotal:(id)sender;

// this method sets the displayed name and picture for the current inventory item, using currentItemIndex and the inventory array
- (void)updateCurrentInventoryItem;

// this method looks at the various states the program can be in and determines if the buttons should be enabled or disabled.
- (void)updateInventoryButtons;

// the updateOrderBoard method looks at the number of items in the order. If the number of items is zero, it returns a static string indicating that there are no items in the order. Otherwise, the method uses the orderDescription method defined in PancakeOrder to display a string of all the items in the order and their quantities.
- (void)updateOrderBoard;

@end
