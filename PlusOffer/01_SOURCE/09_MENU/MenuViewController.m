//
//  MenuViewController.m
//  PlusOffer
//
//  Created by Dao Pham Hoang Duy on 1/7/14.
//  Copyright (c) 2014 Trongvm. All rights reserved.
//

#import "MenuViewController.h"
#import "MenuModel.h"
#import "MenuItem.h"
@interface MenuViewController () <NSFetchedResultsControllerDelegate>
@property (nonatomic, retain) NSMutableArray *dataSource;
@property (nonatomic, retain) NSMutableArray *listMenu;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@end

@implementation MenuViewController



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
 
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tabBarDisplayType = TAB_BAR_DISPLAY_HIDE;
    [self setCustomBarLeftWithImage:[UIImage imageNamed:@"nav-bar-icon-back.png"] selector:nil context_id:nil];
    
     _tableView = [[UITableView alloc]  initWithFrame:CGRectMake(0 , 0 , 320 , self.view.frame.size.height - NAVIGATION_BAR_HEIGHT - CHECK_IOS)  style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView setSeparatorColor:[UIColor clearColor]];
    [self.tableView setBackgroundView:nil];
    _tableView.backgroundColor = UIColorFromRGB(0xeeeeee);
    [self.view addSubview:_tableView];
//    NSLog(@"%@",_brandID);
    [self reloadInterface];
    [self loadOfferDetail];
}
#pragma mark - NSFetchedResultsControllerDelegate

- (NSFetchedResultsController *)fetchedResultsController{
    
    if (!_fetchedResultsController)
    {
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([MenuModel class])];
        fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"item_id" ascending:YES]];
        
        NSFetchedResultsController *myFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext sectionNameKeyPath:nil cacheName:@"Menu"];
        [myFetchedResultsController setDelegate:self];
        self.fetchedResultsController = myFetchedResultsController;
        
        NSError *error = nil;
        [self.fetchedResultsController performFetch:&error];
        
        NSAssert(!error, @"Error performing fetch request: %@", error);
    }
    return _fetchedResultsController;
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [NSFetchedResultsController deleteCacheWithName:@"Menu"];
    [self reloadInterface];
}

- (void)reloadInterface
{
    // NSLog(@"data = %@", self.fetchedResultsController.fetchedObjects);
    self.dataSource = [self.fetchedResultsController.fetchedObjects mutableCopy];
    self.listMenu = [NSMutableArray array];
    for (MenuModel *itemModel in self.dataSource)
    {

        NSMutableDictionary * dic = [NSMutableDictionary new];
        [dic setValue:[NSString stringWithFormat:@"%d" ,itemModel.item_id.integerValue] forKey:@"item_id"];
        [dic setValue:itemModel.item_name forKey:@"item_name"];
        [dic setValue:[NSString stringWithFormat:@"%d" ,itemModel.item_price.integerValue] forKey:@"item_price"];
        [dic setValue:itemModel.item_image forKey:@"item_image"];
        [dic setValue:itemModel.item_description forKey:@"item_description"];
    //    [dic setValue:_brandName forKey:@"brand_id"];
        MenuItem *item = [[MenuItem alloc] initWithData:dic];
        [self.listMenu addObject:item];
    //    [self setTitle:itemModel.brand_id];
    }
    [self.tableView reloadData];
}

#pragma mark - API
-(void)loadOfferDetail
{
    [(PlusAPIManager*)[PlusAPIManager sharedAPIManager] RK_RequestApiGetListItemMenu:self forBrand_id:_brandID];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_listMenu count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellID = [[MenuCell class] description];
    MenuCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[MenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setObject:[_listMenu objectAtIndex:indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 5;
//}
#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // deselecte row
//    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    [tableView deselectRowAtIndexPath:indexPath animated:NO];
//    
//    OfferTableItem *_selectedOfferItem = (OfferTableItem *)[self.dataSource objectAtIndex:indexPath.row];
//    [appDelegate changeToOfferDetailViewController:_selectedOfferItem];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
