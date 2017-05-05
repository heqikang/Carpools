//
//  TakeCarModel.h
//  Carpool
//
//  Created by ZhengBob on 28/11/2016.
//  Copyright © 2016 Client. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TakeCarModel : NSObject

@property (nonatomic, assign) NSNumber *infoid;

@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) NSString *phone;

@property (nonatomic, strong) NSString *from_address_name;

@property (nonatomic, strong) NSString *to_address_name;

@property (nonatomic, strong) NSString *time;

@property (nonatomic, strong) NSString *companyname;

@property (nonatomic, strong) NSString *department;


@end
