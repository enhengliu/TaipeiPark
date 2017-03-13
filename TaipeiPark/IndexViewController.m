//
//  IndexViewController.m
//  TaipeiPark
//
//  Created by Andy Liu on 2017/3/12.
//  Copyright © 2017年 Andy Liu. All rights reserved.
//

#import "IndexViewController.h"
#import "TPCoreDataHelper.h"
#import "TPDataManager.h"
#import "ApiDefine.h"
#import "ParkScene+CoreDataClass.h"
#import "ParkSceneTableViewCell.h"
#import <UIImageView+AFNetworking.h>
#import "ParkSceneDetailViewController.h"

@interface IndexViewController ()

@end

@implementation IndexViewController {
    
    NSArray * parkArray;
    NSMutableArray * parkSceneArray;

}

#pragma mark - View Life Cycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self initUI];
    [self initData];

    [self getDataWithUrl:APIURL];
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Init

-(void)initUI {
    self.title = @"臺北公園景點";
    self.parkSceneTableView.delegate = self;
    self.parkSceneTableView.dataSource = self;
    self.parkSceneTableView.estimatedRowHeight = 152;
    self.parkSceneTableView.rowHeight = UITableViewAutomaticDimension;
    [self.parkSceneTableView registerNib:[UINib nibWithNibName:@"ParkSceneTableViewCell" bundle:nil] forCellReuseIdentifier:PARKSCENE_CELL];

}

-(void)initData {
    
    parkSceneArray = [[NSMutableArray alloc] init];

}

#pragma mark - Network Method

-(void)getDataWithUrl:(NSString *)url {
    
    [[TPDataManager shareManager] getDataWithUrl:url parameters:nil success:^(id responseObject){
        
        if (!responseObject [KEY_RESULT]) {
            return;
        }
        
        if (!responseObject[KEY_RESULT][KEY_RESULTS]) {
            return ;
        }
        
        NSArray * sceneArray = responseObject [KEY_RESULT][KEY_RESULTS];
        
        for (NSDictionary * scene in sceneArray) {
            [[TPCoreDataHelper shareManager]insertObjectWithEntity:TPENTITYNAME parameter:scene];
        }
        
        [[TPCoreDataHelper shareManager]saveContext];
        
        parkArray = [[TPCoreDataHelper shareManager]queryWithEntity:TPENTITYNAME property:[NSArray arrayWithObjects:TPCOREDATA_KEY_PARKNAME, nil] sortKey:TPCOREDATA_KEY_ID ascending:true];
        
        for (int i = 0 ; i < parkArray.count; i++) {
        
            NSString * key = [parkArray objectAtIndex:i];
            NSArray * parkScenes = [[TPCoreDataHelper shareManager] queryWithEntity:TPENTITYNAME predicate:[NSPredicate predicateWithFormat:@"parkname == %@",key] sortKey:nil ascending:true];
            [parkSceneArray addObject:parkScenes];
        }
     
        [self.parkSceneTableView reloadData];

    } failure:^(NSError *error){
    }];
    
}

#pragma mark - TableView Delegate and DataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return parkArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSArray * tempParkScenes = [parkSceneArray objectAtIndex:section];
    return tempParkScenes.count;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [parkArray objectAtIndex:section];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ParkSceneTableViewCell * cell = [self.parkSceneTableView dequeueReusableCellWithIdentifier:PARKSCENE_CELL];
    
    ParkScene * parkScene = [[parkSceneArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    cell.introductionLabel.text = parkScene.introduction;
    CGSize size = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return 1  + size.height;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ParkSceneTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:PARKSCENE_CELL forIndexPath:indexPath];
    ParkScene * parkScene = [[parkSceneArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.nameLabel.text = parkScene.name;
    cell.parkLabel.text = parkScene.parkname;
    NSURLRequest * imageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:parkScene.image]];
    UIImage * placeholderImage = [UIImage imageNamed:@"placeholder-image"];
    [cell.image setImageWithURLRequest:imageRequest placeholderImage:placeholderImage success:nil failure:nil];
    cell.introductionLabel.text = parkScene.introduction;
    return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
   ParkSceneDetailViewController * parkSceneDetailViewController = [[ParkSceneDetailViewController alloc] init];
    ParkScene * parkScene = [[parkSceneArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];

    parkSceneDetailViewController.name = parkScene.name;
    parkSceneDetailViewController.identity = parkScene.id;
    [self.navigationController pushViewController:parkSceneDetailViewController animated:true];
    
}

@end
