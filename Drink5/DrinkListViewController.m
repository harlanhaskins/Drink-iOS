//
//  DrinkListViewController.m
//  Drink5
//
//  Created by henry brown on 2/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DropViewController.h"
#import "DrinkListViewController.h"
#import "DrinkCell.h"
//#import "KeychainItemWrapper.h"
//KeychainItemWrapper *keychain;

@implementation DrinkListViewController

@synthesize listSource;
@synthesize drinkName;
@synthesize drinkPrice;
@synthesize drinkQuantity;
@synthesize drinkCell;
@synthesize tableViewArray;
@synthesize tableView;
@synthesize logoutSource;

DropViewController *dropViewController;

NSString *machineName =@"Big Drink";

NSString *slotStats;
NSInteger *balance;

@synthesize drinkThumbnail;
@synthesize drinkThumbnailOverlay;

@synthesize drinkItems;

- (IBAction)dropConnection:(id)sender {
    [listSource connectionError];
}

- (IBAction)switchToBigDrink:(id)sender {
    //machineName = @"Big Drink";
    [listSource switchMachine:self :@"d"];
}

- (IBAction)switchToLittleDrink:(id)sender {
    //machineName = @"Little Drink";
    [listSource switchMachine:self :@"ld"];
}

- (IBAction)switchToSnack:(id)sender {
    //machineName = @"Snack";
    [listSource switchMachine:self :@"s"];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
- (IBAction)logout:(id)sender {
    [logoutSource logout];
    [self.navigationController popViewControllerAnimated:YES];
}


- (void) setBalance:(NSInteger *)balanceP {
    balance = balanceP;
    [tableView reloadData];
}

- (void) setMachineName:(NSString *)nameP {
    machineName = nameP;
}

- (void)setup
{
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSString *logosPath = [[NSString alloc] initWithFormat:@"%@/icons",path];
    imageNames = [[NSMutableDictionary alloc] init];
    [imageNames setValue:[[NSString alloc] initWithFormat:@"%@/coke.png",logosPath] forKey:@"Coke"];
    [imageNames setValue:[[NSString alloc] initWithFormat:@"%@/jolt_orange.png",logosPath] forKey:@"JOLT Orange"];
    [imageNames setValue:[[NSString alloc] initWithFormat:@"%@/jolt_cola.png",logosPath] forKey:@"JOLT Cola"];
    [imageNames setValue:[[NSString alloc] initWithFormat:@"%@/jolt_grape.png",logosPath] forKey:@"JOLT Grape"];
    [imageNames setValue:[[NSString alloc] initWithFormat:@"%@/dr_pepper.png",logosPath] forKey:@"Dr. Pepper"];
    [imageNames setValue:[[NSString alloc] initWithFormat:@"%@/dr_pepper.png",logosPath] forKey:@"Dr. Pepper"];
    [imageNames setValue:[[NSString alloc] initWithFormat:@"%@/sunkist.png",logosPath] forKey:@"Sunkist"];
    [imageNames setValue:[[NSString alloc] initWithFormat:@"%@/guarana_brazilia.png",logosPath] forKey:@"Guarana Brazilia"];
    [imageNames setValue:[[NSString alloc] initWithFormat:@"%@/drinks_choice.png",logosPath] forKey:@"Drink's Choice"];
    
    [imageNames setValue:[[NSString alloc] initWithFormat:@"%@/chips.png",logosPath] forKey:@"Chips"];
    [imageNames setValue:[[NSString alloc] initWithFormat:@"%@/twizzlers.png",logosPath] forKey:@"Twizzlers"];
    [imageNames setValue:[[NSString alloc] initWithFormat:@"%@/chocolate_chip_cookies.png",logosPath] forKey:@"Chocolate Chip Cookies"];
    [imageNames setValue:[[NSString alloc] initWithFormat:@"%@/mini_pretzels.png",logosPath] forKey:@"Mini Pretzles"];
    [imageNames setValue:[[NSString alloc] initWithFormat:@"%@/peanut_butter_crackers.png",logosPath] forKey:@"Peanut Butter Crackers"];
    [imageNames setValue:[[NSString alloc] initWithFormat:@"%@/nestle_candy_bars.png",logosPath] forKey:@"Nestle Candy Bars"];
    [imageNames setValue:[[NSString alloc] initWithFormat:@"%@/fruit_snacks.png",logosPath] forKey:@"Welch's Fruit Snacks"];
    
    [imageNames setValue:[[NSString alloc] initWithFormat:@"%@/default_icon.png",logosPath] forKey:@"default"];
    
    [imageNames setValue:[[NSString alloc] initWithFormat:@"%@/crossedOut.png",path] forKey:@"grayedOut"];
    [self.navigationItem setHidesBackButton:YES animated:YES];
}

- (void) setSlotStats:(NSString *)stats {
    NSLog(@"got stats");
    NSLog(stats);
    NSArray *array = [[NSArray alloc] initWithArray:[stats componentsSeparatedByString:@"\n"]];
    NSMutableArray *mutDrinkItems = [[NSMutableArray alloc] init];
    for( NSInteger i = 0; i < [array count] - 2; i++) {
        DrinkItem *drinkItem = [[DrinkItem alloc] init];
        NSArray *quoteArray = [[NSArray alloc] initWithArray:[[array objectAtIndex:i] componentsSeparatedByString:@"\""]];
        NSArray *tempArray = [[NSArray alloc] initWithArray:[[quoteArray objectAtIndex:2] componentsSeparatedByString:@" "]];
        drinkItem.name = [quoteArray objectAtIndex:1];
        drinkItem.price = [tempArray objectAtIndex:1];
        drinkItem.quantity = [tempArray objectAtIndex:2];
        drinkItem.something = [tempArray objectAtIndex:3];
        drinkItem.row = i + 1;
        [mutDrinkItems addObject:drinkItem];
         }
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"quantity" ascending:NO];
    NSArray *descriptors = [NSArray arrayWithObject:sortDescriptor];
    drinkItems = [mutDrinkItems sortedArrayUsingDescriptors:descriptors];

    
    
    
    NSLog(@"slot stats set");
    [listSource getBalance:self];
    [self setup];
}

- (void)awakeFromNib
{
    //[self setup];
}

- (void)viewDidLoad:(BOOL)animated
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.listSource getDrinkStats];
}

- (void)viewDidUnload
{
    [self setDrinkThumbnail:nil];
    [self setDrinkThumbnailOverlay:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [drinkItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)
indexPath
{
    static NSString *DrinkCellIdentifier = @"DrinkCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DrinkCellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"DrinkCell" owner:self options:nil];
        if ([nib count] > 0) {
            cell = self.drinkCell;
        } else {
            NSLog(@"Failed to load CustomCell nib file!");
        }
    }
    NSUInteger row = [indexPath row];
    
    drinkPrice.text = [NSString stringWithFormat:@"%@Ȼ", [[drinkItems objectAtIndex:row] price]];
    drinkQuantity.text = [NSString stringWithFormat:@"%@ stocked", [[drinkItems objectAtIndex:row] quantity]];
    drinkName.text = [[drinkItems objectAtIndex:row] name];
    
    //drinkPrice.text = [NSString stringWithFormat:@"%@ credits", [drinkPrices objectAtIndex:row]];
    //drinkQuantity.text = [NSString stringWithFormat:@"%@ remain", [drinkQuantities objectAtIndex:row]];
    //drinkName.text = [drinkNames objectAtIndex:row];
    UIImage *thumbNailImage = [[UIImage alloc] initWithContentsOfFile:[imageNames objectForKey:drinkName.text]];
    if (thumbNailImage == nil) {
        thumbNailImage = [[UIImage alloc] initWithContentsOfFile:[imageNames objectForKey:@"default"]];
    }
        drinkThumbnail.image = thumbNailImage;
    
    
    NSInteger quantity = [[[drinkItems objectAtIndex:row] quantity] intValue];
    if (quantity <= 0) {
        drinkPrice.textColor = [UIColor grayColor];
        drinkName.textColor = [UIColor grayColor];
        drinkQuantity.textColor = [UIColor redColor];
        drinkThumbnailOverlay.image = [[UIImage alloc] initWithContentsOfFile:[imageNames objectForKey:@"grayedOut"]];
    } 
    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    NSInteger quantity = [[[drinkItems objectAtIndex:row] quantity] intValue];
    if (quantity <= 0) {
        return nil;
    }
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    [self performSegueWithIdentifier:@"TransitionToDrop" sender:self];
    [dropViewController setDrinkName:[[drinkItems objectAtIndex:row] name]];
    UIImage *itemIcon = [[UIImage alloc] initWithContentsOfFile:[imageNames objectForKey:[[drinkItems objectAtIndex:row] name]]];
    if (itemIcon == nil) itemIcon = [[UIImage alloc] initWithContentsOfFile:[imageNames objectForKey:@"default"]];
    dropViewController.itemIcon.image = itemIcon;
    [dropViewController setSlotToDrop:[[drinkItems objectAtIndex:row] row]];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"TransitionToDrop"]) {
        dropViewController = segue.destinationViewController;
        [dropViewController setDropSource:listSource];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [NSString stringWithFormat:@"%d Credits -  %@", balance, machineName];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 63;
}


@end
 