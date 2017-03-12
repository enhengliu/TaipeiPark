//
//  ParkScene+CoreDataProperties.h
//  TaipeiPark
//
//  Created by Andy Liu on 2017/3/12.
//  Copyright © 2017年 Andy Liu. All rights reserved.
//

#import "ParkScene+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface ParkScene (CoreDataProperties)

+ (NSFetchRequest<ParkScene *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *image;
@property (nullable, nonatomic, copy) NSString *introduction;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *opentime;
@property (nullable, nonatomic, copy) NSString *parkname;
@property (nullable, nonatomic, copy) NSString *id;
@property (nullable, nonatomic, copy) NSString *yearbuilt;

@end

NS_ASSUME_NONNULL_END
