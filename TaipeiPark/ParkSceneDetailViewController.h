//
//  ParkSceneDetailViewController.h
//  TaipeiPark
//
//  Created by Andy Liu on 2017/3/13.
//  Copyright © 2017年 Andy Liu. All rights reserved.
//

#import <UIKit/UIKit.h>




@interface ParkSceneDetailViewController : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource>

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *imageHConstraint;
@property(nonatomic,strong) NSString * name;
@property(nonatomic,strong) NSString * identity;

@property (strong, nonatomic) IBOutlet UIScrollView *sceneDetailScrollView;
@property (strong, nonatomic) IBOutlet UIView *detailContentView;
@property (strong, nonatomic) IBOutlet UIImageView *sceneImage;
@property (strong, nonatomic) IBOutlet UILabel *parkName;
@property (strong, nonatomic) IBOutlet UILabel *sceneName;
@property (strong, nonatomic) IBOutlet UILabel *openTime;
@property (strong, nonatomic) IBOutlet UILabel *introduction;
@property (strong, nonatomic) IBOutlet UICollectionView *sceneCollection;
@property (strong, nonatomic) IBOutlet UICollectionView *sceneCollectionView;

@end
