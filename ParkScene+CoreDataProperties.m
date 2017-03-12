//
//  ParkScene+CoreDataProperties.m
//  TaipeiPark
//
//  Created by Andy Liu on 2017/3/12.
//  Copyright © 2017年 Andy Liu. All rights reserved.
//

#import "ParkScene+CoreDataProperties.h"

@implementation ParkScene (CoreDataProperties)

+ (NSFetchRequest<ParkScene *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"ParkScene"];
}

@dynamic image;
@dynamic introduction;
@dynamic name;
@dynamic opentime;
@dynamic parkname;
@dynamic id;
@dynamic yearbuilt;

@end
