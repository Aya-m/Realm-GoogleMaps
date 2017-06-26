//
//  RestaurantsListViewController.m
//  GMap
//
//  Created by Aya-m on 2016/06/21.
//  Copyright © 2016年 Aya-m. All rights reserved.
//

#import "RestaurantsListViewController.h"
#import "Restaurants.h"
#import "RestaurantsListTableViewCell.h"
#import "Config.h"
#import "RestrantsMapViewController.h"
#import "Favorite.h"

static NSString *const TableViewCell = @"Cell";

@interface RestaurantsListViewController () <UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic) NSMutableArray *restaurantsList;
@property(nonatomic) NSInteger row;
@property(nonatomic) NSInteger statusMode;

@end

@implementation RestaurantsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _restaurantsList = [Restaurants readAllRestaurants];
    NSLog(@"allRestaurants %@" ,self.restaurantsList);
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    // カスタムセルを使用
    UINib *nib = [UINib nibWithNibName:@"RestaurantsListTableViewCell" bundle:nil];
    [_tableView registerNib:nib forCellReuseIdentifier:TableViewCell];
    [_tableView reloadData];
    
    _statusMode = AllListMode;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//---------------------------------------------------------------------------------------------------------
#pragma mark - UITableViewDelegate
#pragma mark - UITableViewDataSource
//---------------------------------------------------------------------------------------------------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor orangeColor];
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 8.0f, 150.0f, 15.0f)];
    lbl.font = [UIFont fontWithName:@"AppleGothic" size:16];
    lbl.textAlignment = UIBaselineAdjustmentAlignCenters;
    lbl.textColor = [UIColor whiteColor];
    lbl.text = @"List of restaurants";
    [view addSubview:lbl];
    return view;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.restaurantsList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // カスタムセルを取得
    RestaurantsListTableViewCell *cell    = [tableView dequeueReusableCellWithIdentifier:TableViewCell
                                                                       forIndexPath:indexPath];
    if (!cell) {
        cell = [[RestaurantsListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TableViewCell];
    }
    
    cell.nameLabel.text  =  self.restaurantsList [indexPath.row][kRestaurantsName];
    cell.telLabel.text   = self.restaurantsList [indexPath.row][kRestaurantsAddress];
    cell.categoryLabel.text    =  self.restaurantsList [indexPath.row][kRestaurantsCategory];
    UIImage *image;
   if([self.restaurantsList [indexPath.row][kRestaurantsImage_url] isEqualToString:@"noImage.png"]) {
        image = [UIImage imageNamed:@"noImage.png"];
   } else {
       NSURL *url = [NSURL URLWithString:self.restaurantsList [indexPath.row][kRestaurantsImage_url]];
       NSData *myData = [NSData dataWithContentsOfURL:url];
       image = [[UIImage alloc] initWithData:myData];
   }
    cell.restaurantsImage.image = image;
    // ハイライトなし
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

// セルが選択された時に呼び出される
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
     _row = indexPath.row;
    if (_statusMode == EditMode) {
        // 選択されたセルを取得
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        // セルのアクセサリにチェックマークを指定
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        
    } else if (_statusMode == AllListMode) {
        [Favorite writeRestaurants:self.restaurantsList[_row]];
        [self performSegueWithIdentifier:@"toRestrantsMap" sender:self];
        
    }  else if (_statusMode == BookmarksMode) {
        [self performSegueWithIdentifier:@"toRestrantsMap" sender:self];
    }
}

// セルの選択がはずれた時に呼び出される
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 選択がはずれたセルを取得
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    // セルのアクセサリを解除する（チェックマークを外す）
    cell.accessoryType = UITableViewCellAccessoryNone;
}

- (IBAction)editMode:(id)sender {
    self.tableView.allowsMultipleSelection = YES;
    _statusMode = EditMode;
}

- (IBAction)showBookmarks:(id)sender {
    self.tableView.allowsMultipleSelection = NO;
    _statusMode = BookmarksMode;
    [_restaurantsList removeAllObjects];
    _restaurantsList = [Favorite readAllRestaurants];
    [_tableView reloadData];
}

- (IBAction)showAllList:(id)sender {
    self.tableView.allowsMultipleSelection = NO;
    _statusMode = AllListMode;
    [_restaurantsList removeAllObjects];
    _restaurantsList = [Restaurants readAllRestaurants];
    [_tableView reloadData];
}

// セグエ発動時に必ず呼ばれる　ここを利用しないと次の画面に情報をおくれないですよ
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"toRestrantsMap"]) {
        RestrantsMapViewController *restrantsMap = (RestrantsMapViewController*)[segue destinationViewController];
        restrantsMap.restaurantName = self.restaurantsList[_row][kRestaurantsName];
        restrantsMap.restaurantAddress = self.restaurantsList[_row][kRestaurantsAddress];
        restrantsMap.restaurantLatitude = [self.restaurantsList[_row][kRestaurantsLatitude]doubleValue];
        restrantsMap.restaurantLongitude = [self.restaurantsList[_row][kRestaurantsLongitude]doubleValue];
        restrantsMap.restaurantCategory = self.restaurantsList[_row][kRestaurantsCategory];
        restrantsMap.restaurantTel = self.restaurantsList[_row][kRestaurantsTel];
        restrantsMap.restaurantImage_url = self.restaurantsList[_row][kRestaurantsImage_url];
    }
}

@end
