//
//  BusAnnotation.m
//  Carpools
//
//  Created by ZhengBob on 26/4/2017.
//  Copyright © 2017 Esquel. All rights reserved.
//

#import "BusAnnotation.h"

@implementation BusAnnotation

- (instancetype)initWithAnnotationModelWithDict:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        
        
        self.coordinate = CLLocationCoordinate2DMake([dict[@"Latitude"] doubleValue], [dict[@"Longitude"] doubleValue]);
        self.title = dict[@"route_short_name"];
        self.name = dict[@"route_long_name"];
        //        self.type = dict[@"type"];
        
    }
    return self;
}

@end
