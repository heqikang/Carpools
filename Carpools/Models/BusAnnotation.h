//
//  BusAnnotation.h
//  Carpools
//
//  Created by ZhengBob on 26/4/2017.
//  Copyright © 2017 Esquel. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <MapKit/MapKit.h>

@interface BusAnnotation : NSObject<MKAnnotation>

@property (nonatomic,assign) CLLocationCoordinate2D coordinate;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,retain) NSNumber *type;

- (instancetype)initWithAnnotationModelWithDict:(NSDictionary *)dict;


@end
