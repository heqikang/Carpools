//
//  TripModel.h
//  Carpool
//
//  Created by ZhengBob on 9/3/2017.
//  Copyright © 2017 Esquel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TripModel : NSObject

@property (nonatomic, strong) NSString *trip_type;

@property (nonatomic, assign) NSNumber *infoid;

@property (nonatomic, assign) NSNumber *startpid;

@property (nonatomic, assign) NSNumber *endpid;

@property (nonatomic, strong) NSString *status;

@property (nonatomic, strong) NSString *time;

@property (nonatomic, assign) NSNumber *love_wall_ID;

@property (nonatomic, assign) NSNumber *from_address_id;

@property (nonatomic, strong) NSString *passenger_name;

@property (nonatomic, strong) NSString *driver_name;

@property (nonatomic, strong) NSString *driver_id;

@property (nonatomic, strong) NSString *passenger_department;

@property (nonatomic, strong) NSString *driver_department;

@property (nonatomic, strong) NSString *driver_carnumber;

@property (nonatomic, strong) NSString *to_address_name;

@property (nonatomic, strong) NSString *from_address_name;

@property (nonatomic, strong) NSString *driver_phone;

@property (nonatomic, strong) NSString *passenger_phone;

@property (nonatomic, strong) NSString *seat_count;

@property (nonatomic, strong) NSString *liked_count;

@property (nonatomic, strong) NSString *hitchhiked_count;

@property (nonatomic, strong) NSString *from_latitude;

@property (nonatomic, strong) NSString *from_longtitude;

@property (nonatomic, strong) NSString *to_latitude;

@property (nonatomic, strong) NSString *to_longtitude;

@end
