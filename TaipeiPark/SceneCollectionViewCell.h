//
//  SceneCollectionViewCell.h
//  TaipeiPark
//
//  Created by Andy Liu on 2017/3/13.
//  Copyright © 2017年 Andy Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SCENE_COLLECTIONVIEW_CELL @"SceneCollectionViewCell"

@interface SceneCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *image;
@property (strong, nonatomic) IBOutlet UILabel *name;

@end
