//
//  TPDataManager.h
//  TaipeiPark
//
//  Created by Andy Liu on 2017/3/12.
//  Copyright © 2017年 Andy Liu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^Success)(id json);
typedef void(^Failure)(NSError *error);

@interface TPDataManager : NSObject

+ (TPDataManager *)shareManager;

- (void)getDataWithUrl:(NSString *)url parameters:(NSDictionary *)paramters success:(Success)success failure:(Failure)failure;

@end
