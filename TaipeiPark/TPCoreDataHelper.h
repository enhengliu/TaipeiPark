//
//  TPCoreDataHelper.h
//  TaipeiPark
//
//  Created by Andy Liu on 2017/3/12.
//  Copyright © 2017年 Andy Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "TPCoreDataDefine.h"



@interface TPCoreDataHelper : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;

@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+(TPCoreDataHelper *)shareManager;

-(void)insertObjectWithEntity:(NSString *)entity parameter:(NSDictionary *)param;

-(NSArray*)queryWithEntity:(NSString *)entity predicate:(NSPredicate *)predicate sortKey:(NSString *)key ascending:(BOOL)isAscending;

-(NSArray *)queryWithEntity:(NSString *)entity property:(NSArray *)property sortKey:(NSString *)key ascending:(BOOL)isAscending;

-(void)deleteObjectsWithEntity:(NSString *)entity;

- (void)saveContext;

@end
