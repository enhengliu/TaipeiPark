//
//  TPCoreDataHelper.m
//  TaipeiPark
//
//  Created by Andy Liu on 2017/3/12.
//  Copyright © 2017年 Andy Liu. All rights reserved.
//

#import "TPCoreDataHelper.h"
#import "ParkScene+CoreDataClass.h"
@implementation TPCoreDataHelper


static TPCoreDataHelper * manager = nil;

+(TPCoreDataHelper *)shareManager{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        manager=[[self alloc]init];
    });
    
    return manager;
}

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

#pragma mark - init method

-(id)init{
    
    if (self=[super init]) {
        
        NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
        if (!coordinator) {
            return nil;
        }
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
        
    }
    
    return self;
}

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.enheng.CoreData" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:TPDATABASENAME withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite",TPDATABASENAME]];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - public method

-(void)insertObjectWithEntity:(NSString *)entity parameter:(NSDictionary *)param{
    
    NSManagedObject * object = [NSEntityDescription insertNewObjectForEntityForName:entity inManagedObjectContext:self.managedObjectContext];
    
    for (NSString*key in param.allKeys) {
        NSString * objectKey = [[key stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"~!@#$%^&*()_+"]] lowercaseString];
        [object setValue:param[key] forKey:objectKey];
    }
    
}

-(NSArray *)queryWithEntity:(NSString *)entity predicate:(NSPredicate *)predicate sortKey:(NSString *)key ascending:(BOOL)isAscending{
    
    NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName:entity];
    [request setPredicate:predicate];

    if (key){
        NSSortDescriptor * sortDestor = [[NSSortDescriptor alloc]initWithKey:key ascending:isAscending];
        [request setSortDescriptors:@[sortDestor]];
    }
    
    NSError * error = nil;
    NSArray * fetchedResults = [[self managedObjectContext] executeFetchRequest:request error:&error];
    if (!fetchedResults) {
        NSLog(@"error:%@ ,%@",error,[error userInfo]);
    }
    
    return fetchedResults;
}

-(NSArray *)queryWithEntity:(NSString *)entity property:(NSArray *)property sortKey:(NSString *)key ascending:(BOOL)isAscending {
    
    NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName:entity];
    request.resultType = NSDictionaryResultType;
    [request setPropertiesToFetch:property];
    request.returnsDistinctResults = YES;

    
    if (key){
        NSSortDescriptor * sortDestor = [[NSSortDescriptor alloc]initWithKey:key ascending:isAscending];
        [request setSortDescriptors:@[sortDestor]];
    }
    
    NSError * error = nil;
    NSArray * fetchedResults = [[self managedObjectContext] executeFetchRequest:request error:&error];
    if (!fetchedResults) {
        NSLog(@"error:%@ ,%@",error,[error userInfo]);
    }
    
    NSMutableArray * resultArray = [[NSMutableArray alloc] init];
    for (NSDictionary * resultDict in fetchedResults) {
        [resultArray addObject:[resultDict objectForKey:TPCOREDATA_KEY_PARKNAME]];
    }

    return resultArray;
}

-(void)deleteObjectsWithEntity:(NSString *)entity {
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:entity];
    NSBatchDeleteRequest *delete = [[NSBatchDeleteRequest alloc] initWithFetchRequest:request];
    NSError *deleteError = nil;
    [[self persistentStoreCoordinator] executeRequest:delete withContext:[self managedObjectContext] error:&deleteError];
    
}

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}


@end
