//
//  ParkSceneTableViewCell.h
//  TaipeiPark
//
//  Created by Andy Liu on 2017/3/13.
//  Copyright © 2017年 Andy Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

#define PARKSCENE_CELL @"ParkSceneCell"

@interface ParkSceneTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *image;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;

@property (strong, nonatomic) IBOutlet UILabel *parkLabel;
@property (strong, nonatomic) IBOutlet UILabel *introductionLabel;

@end
