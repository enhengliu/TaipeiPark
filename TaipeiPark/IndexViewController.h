//
//  IndexViewController.h
//  TaipeiPark
//
//  Created by Andy Liu on 2017/3/12.
//  Copyright © 2017年 Andy Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IndexViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *parkSceneTableView;
@property (strong, nonatomic) IBOutlet UILabel *parkSceneName;

@end
