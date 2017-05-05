//
//  WallModel.h
//  Carpool
//
//  Created by ZhengBob on 12/1/2017.
//  Copyright © 2017 Client. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LovewallModel : NSObject

@property (nonatomic, strong) NSNumber *lover_id;

@property (nonatomic, strong) NSNumber *liked_count;

@property (nonatomic, strong) NSString *lover_name;

@property (nonatomic, strong) NSString *department;

@property (nonatomic, strong) NSString *from_address;

@property (nonatomic, strong) NSString *to_address;

@property (nonatomic, strong) NSNumber *seat_count;

@property (nonatomic, strong) NSNumber *hitchhiked_count;

@property (nonatomic, strong) NSString *time;

@property (nonatomic, strong) NSNumber *love_wall_ID;

@property (nonatomic, strong) NSString *carnumber;

@property (nonatomic, strong) NSNumber *startpid;

@property (nonatomic, strong) NSNumber *endpid;

@property (nonatomic, strong) NSNumber *carownid;

@property (nonatomic, strong) NSString *phone;

@property (nonatomic, strong) NSString *status;

@property (nonatomic, strong) NSString *from_latitude;

@property (nonatomic, strong) NSString *from_longtitude;

@property (nonatomic, strong) NSString *to_latitude;

@property (nonatomic, strong) NSString *to_longtitude;

@property (nonatomic, strong) NSString *passAddress;

@end
