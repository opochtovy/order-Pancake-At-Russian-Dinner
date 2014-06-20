//
//  PancakeViewController.m
//  RussianPancake
//
//  Created by Oleg Pochtovy on 19.06.14.
//  Copyright (c) 2014 Oleg Pochtovy. All rights reserved.
//

#import "PancakeViewController.h"
#import "PancakeItem.h"
#import "PancakeOrder.h"

@interface PancakeViewController ()

@end

@implementation PancakeViewController

@synthesize inventory, order;

dispatch_queue_t queue;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    currentItemIndex = 0;
    self.order = [PancakeOrder new];
    
    queue = dispatch_queue_create("opochtovy.queue", nil);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // update buttons
    [self updateInventoryButtons];
    
    // set - initial label text
    self.ibChalkboardLabel.text = @"Loading Inventory...";
    
    // use queue to fetch inventory and then set label text
    dispatch_async(queue, ^{
        self.inventory = [[PancakeItem retrieveInventoryItems] mutableCopy];
        dispatch_async(dispatch_get_main_queue(), ^{ // we make another call with dispatch_async, but this time we get the main queue and execute our Block on the main queue.
            [self updateOrderBoard];
            [self updateInventoryButtons];
            [self updateCurrentInventoryItem];
            self.ibChalkboardLabel.text = @"Inventory Loaded\n\n How can I help you?";
        });
    });
}

- (IBAction)ibaRemoveItem:(id)sender {
    PancakeItem *currentItem = [self.inventory objectAtIndex:currentItemIndex];
    [order removeItemFromOrder:currentItem];
    [self updateOrderBoard];
    [self updateCurrentInventoryItem];
    [self updateInventoryButtons];
    
    // next is an example of the Block UIView animation system - a nifty animation which shows the items being removed each time we tap the “-1″ button
    
    // first we just create a UILabel and set its properties
    UILabel *removeItemDisplay = [[UILabel alloc] initWithFrame:self.ibCurrentItemImageView.frame];
    [removeItemDisplay setCenter:self.ibChalkboardLabel.center];
    [removeItemDisplay setText:@"-1"];
    [removeItemDisplay setTextAlignment:UITextAlignmentCenter];
    [removeItemDisplay setTextColor:[UIColor redColor]];
    [removeItemDisplay setBackgroundColor:[UIColor clearColor]];
    [removeItemDisplay setFont:[UIFont boldSystemFontOfSize:32.0]];
    [[self view] addSubview:removeItemDisplay];
    // second we make an animation that moves the label that we just created
    [UIView animateWithDuration:1.0 animations:^{
        [removeItemDisplay setCenter:[self.ibCurrentItemImageView center]];
        [removeItemDisplay setAlpha:0.0];
    }
                     completion:^(BOOL finished) {
                         [removeItemDisplay removeFromSuperview];
                     }];
}

- (IBAction)ibaAddItem:(id)sender {
    PancakeItem *currentItem = [self.inventory objectAtIndex:currentItemIndex];
    [order addItemToOrder:currentItem];
    [self updateOrderBoard];
    [self updateCurrentInventoryItem];
    [self updateInventoryButtons];
    
    // next is an example of the Block UIView animation system - a nifty animation which shows the items being added each time we tap the “+1″ button
    
    // first we just create a UILabel and set its properties
    UILabel *addItemDisplay = [[UILabel alloc] initWithFrame:self.ibCurrentItemImageView.frame];
    [addItemDisplay setText:@"+1"];
    [addItemDisplay setTextColor:[UIColor whiteColor]];
    [addItemDisplay setBackgroundColor:[UIColor clearColor]];
    [addItemDisplay setTextAlignment:UITextAlignmentCenter];
    [addItemDisplay setFont:[UIFont boldSystemFontOfSize:32.0]];
    [[self view] addSubview:addItemDisplay];
    // second we make an animation that moves the label that we just created
    [UIView animateWithDuration:1.0
                     animations:^{
                         [addItemDisplay setCenter:self.ibChalkboardLabel.center];
                         [addItemDisplay setAlpha:0.0];
                     } completion:^(BOOL finished) {
                         [addItemDisplay removeFromSuperview];
                     }];
}

- (IBAction)ibaLoadPreviousItem:(id)sender {
    currentItemIndex--;
    [self updateCurrentInventoryItem];
    [self updateInventoryButtons];
}

- (IBAction)ibaLoadNextItem:(id)sender {
    currentItemIndex++;
    [self updateCurrentInventoryItem];
    [self updateInventoryButtons];
}

// this method shows the calculated total to the user when they hit the total button
- (IBAction)ibaCalculateTotal:(id)sender {
    // this just gets the total
    float total = [order totalOrder];
    // this creates a simple alert view
    UIAlertView *totalAlert = [[UIAlertView alloc] initWithTitle:@"Total" message:[NSString stringWithFormat:@"$%0.2f", total] delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil];
    // this shows alert view to the user
    [totalAlert show];
}

// this method sets the displayed name and picture for the current inventory item, using currentItemIndex and the inventory array
- (void)updateCurrentInventoryItem {
    if (currentItemIndex >= 0 && currentItemIndex < [self.inventory count]) {
        PancakeItem *currentItem = [self.inventory objectAtIndex:currentItemIndex];
        self.ibCurrentItemLabel.text = currentItem.name;
        self.ibCurrentItemImageView.image = [UIImage imageNamed:[currentItem pictureFile]];
    }
}

// this method looks at the various states the program can be in and determines if the buttons should be enabled or disabled.
- (void)updateInventoryButtons {
    if (!self.inventory || [self.inventory count] == 0) {
        self.ibAddItemButton.enabled = NO;
        self.ibRemoveItemButton.enabled = NO;
        self.ibNextItemButton.enabled = NO;
        self.ibPreviousItemButton.enabled = NO;
        self.ibTotalOrderButton.enabled = NO;
    } else {
        if (currentItemIndex <= 0) {
            self.ibPreviousItemButton.enabled = NO;
        } else {
            self.ibPreviousItemButton.enabled = YES;
        }
        if (currentItemIndex >= [self.inventory count]-1) {
            self.ibNextItemButton.enabled = NO;
        } else {
            self.ibNextItemButton.enabled = YES;
        }
        PancakeItem *currentItem = [self.inventory objectAtIndex:currentItemIndex];
        if (currentItem) {
            self.ibAddItemButton.enabled = YES;
        } else {
            self.ibAddItemButton.enabled = NO;
        }
        if (![self.order findKeyForOrderItem:currentItem]) {
            self.ibRemoveItemButton.enabled = NO;
        } else {
            self.ibRemoveItemButton.enabled = YES;
        }
        if ([order.orderItems count] == 0) {
            self.ibTotalOrderButton.enabled = NO;
        } else {
            self.ibTotalOrderButton.enabled = YES;
        }
    }
}

// the updateOrderBoard method looks at the number of items in the order. If the number of items is zero, it returns a static string indicating that there are no items in the order. Otherwise, the method uses the orderDescription method defined in PancakeOrder to display a string of all the items in the order and their quantities.
- (void)updateOrderBoard {
    if ([order.orderItems count] == 0) {
        self.ibChalkboardLabel.text = @"No items. Please order something!";
    } else {
        self.ibChalkboardLabel.text = [order orderDescription];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)dealloc {
//    dispatch_release(queue);
//}

@end
