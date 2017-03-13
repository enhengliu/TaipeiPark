//
//  ParkSceneDetailViewController.m
//  TaipeiPark
//
//  Created by Andy Liu on 2017/3/13.
//  Copyright © 2017年 Andy Liu. All rights reserved.
//

#import "ParkSceneDetailViewController.h"
#import "TPCoreDataHelper.h"
#import "ParkScene+CoreDataClass.h"
#import <UIImageView+AFNetworking.h>
#import "SceneCollectionViewCell.h"

@interface ParkSceneDetailViewController ()

@end

@implementation ParkSceneDetailViewController {
    
    ParkScene * parkScene;
    NSMutableArray * sceneArray;
    
}

#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self getDetailwithID:self.identity];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Init Method

-(void)initUI {
    
    self.title = self.name;
    self.sceneCollectionView.delegate = self;
    self.sceneCollectionView.dataSource = self;
    [self.sceneCollectionView registerNib:[UINib nibWithNibName:@"SceneCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:SCENE_COLLECTIONVIEW_CELL];

}

#pragma mark - Get Data Method

-(void)getDetailwithID:(NSString *)identity {
    
    NSArray * parkScenes = [[TPCoreDataHelper shareManager] queryWithEntity:TPENTITYNAME predicate:[NSPredicate predicateWithFormat:@"id == %@",identity] sortKey:nil ascending:true];
    
    if (parkScenes) {
        
        parkScene  = [parkScenes objectAtIndex:0];
        
        NSURLRequest * imageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:parkScene.image]];
        UIImage * placeholderImage = [UIImage imageNamed:@"placeholder-image"];
        
        __block UIImageView * tempSceneImage = self.sceneImage;
        __block NSLayoutConstraint * tempLayouonstraint;
        [self.sceneImage setImageWithURLRequest:imageRequest placeholderImage:placeholderImage success:nil failure:^(NSURLRequest *request, NSHTTPURLResponse * _Nullable response, NSError *error){
            tempSceneImage.hidden = true;
            tempLayouonstraint.constant = 0;
        }];
        self.sceneName.text = parkScene.name;
        self.parkName.text = parkScene.parkname;
        self.openTime.text = [NSString stringWithFormat:@"開放時間：%@",parkScene.opentime];
        self.introduction.text = parkScene.introduction;
        
    
        
        NSArray * tempSceneArray =  [[TPCoreDataHelper shareManager] queryWithEntity:TPENTITYNAME predicate:[NSPredicate predicateWithFormat:@"parkname == %@",parkScene.parkname] sortKey:nil ascending:true];
        sceneArray = [NSMutableArray arrayWithArray:tempSceneArray];
        [sceneArray removeObject:parkScene];

    }
    
    
}

#pragma mark - Collection Delegate and DataSource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return  1;
}



-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return sceneArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    SceneCollectionViewCell *cell = (SceneCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:SCENE_COLLECTIONVIEW_CELL forIndexPath:indexPath];

    ParkScene * scene = [sceneArray objectAtIndex:indexPath.row];

    NSURLRequest * imageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:scene.image]];

    UIImage * placeholderImage = [UIImage imageNamed:@"placeholder-image"];
    [cell.image setImageWithURLRequest:imageRequest placeholderImage:placeholderImage success:nil failure:nil];
    cell.name.text = scene.name;
    
    return cell;
    
}





@end
