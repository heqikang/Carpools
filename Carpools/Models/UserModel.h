//
//  UserModel.h
//  Carpool
//
//  Created by ZhengBob on 10/3/2017.
//  Copyright © 2017 Esquel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject

@property (nonatomic, copy) NSNumber *uid;

@property (nonatomic, strong) NSString *loginname;

@property (nonatomic, strong) NSString *deptid;

@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) NSString *phone;

@property (nonatomic, strong) NSString *carnumber;

@property (nonatomic, strong) NSString *cartype;

@property (nonatomic, strong) NSString *Department;

@property (nonatomic, strong) NSString *home_address_name;

@property (nonatomic, strong) NSString *work_address_name;

@end
