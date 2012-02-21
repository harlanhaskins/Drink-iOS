//
//  DrinkListViewController.h
//  Drink5
//
//  Created by henry brown on 2/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DropViewController.h"
#import <UIKit/UIKit.h>

@protocol DrinkListSource <DropSource>
- (void)getDrinkStats;
- (void)getBalance:(id)sender;
- (void)switchMachine:(id)sender: (NSString *)machine;
- (void)resetStreams;
@end

@interface DrinkListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    NSArray *tableViewArray;
    UITableView *tableView;
    NSInteger *balance;
    UITableViewCell *drinkCell;
    
    NSMutableArray *drinkNames;
    NSMutableArray *drinkPrices;
    NSMutableArray *drinkQuantities;
    NSMutableArray *drinkSomethings;
}

@property (nonatomic, retain) NSMutableArray *drinkNames;
@property (nonatomic, retain) NSMutableArray *drinkPrices;
@property (nonatomic, retain) NSMutableArray *drinkQuantities;
@property (nonatomic, retain) NSMutableArray *drinkSomethings;

@property (nonatomic, retain) NSArray *tableViewArray;

@property (nonatomic, retain) IBOutlet UITableView *tableView; 

@property (nonatomic, strong) IBOutlet id <DrinkListSource> listSource;


@property (weak, nonatomic) IBOutlet UILabel *drinkName;

@property (weak, nonatomic) IBOutlet UILabel *drinkPrice;

@property (weak, nonatomic) IBOutlet UILabel *drinkQuantity;

@property (strong, nonatomic) IBOutlet UITableViewCell *drinkCell;

- (void) setSlotStats:(NSString *)stats;

- (void) setBalance:(NSInteger *)balance;

- (void) setup;
@end