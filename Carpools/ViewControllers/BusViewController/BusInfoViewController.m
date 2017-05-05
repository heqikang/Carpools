//
//  BusInfoViewController.m
//  Carpools
//
//  Created by ZhengBob on 26/4/2017.
//  Copyright © 2017 Esquel. All rights reserved.
//

#import "BusInfoViewController.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapNaviKit/AMapNaviKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "BusAnnotation.h"
#import "QKAnnotationView.h"

@interface BusInfoViewController ()<MAMapViewDelegate, AMapLocationManagerDelegate>

@property (nonatomic, strong) NSMutableArray *locationArray;

@property (nonatomic, strong) MAMapView *mapView;

@property (nonatomic, strong) NSMutableArray *annotations;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) AMapLocationManager *locationManager;

@property (nonatomic, assign) CLLocationCoordinate2D myCoord;

@end

@implementation BusInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"班车";
    self.view.backgroundColor = [UIColor whiteColor];
    [AMapServices sharedServices].enableHTTPS = YES;
    
    self.mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    self.mapView.delegate = self;
    
    ///如果您需要进入地图就显示定位小蓝点，则需要下面两行代码
    _mapView.showsUserLocation = YES;
    _mapView.userTrackingMode = MAUserTrackingModeFollow;
    
    [self settingMapView];
    
    [self loadBusLastPosition];
    [self.view addSubview:self.mapView];
    [_mapView setZoomLevel:16.1 animated:YES];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:10.f target:self selector:@selector(loadBusLastPosition) userInfo:nil repeats:YES];
    
    [self showMyPosition];
}

- (NSMutableArray *)annotations
{
    if (_annotations == nil) {
        _annotations = [NSMutableArray array];
    }
    return _annotations;
}

- (AMapLocationManager *)locationManager
{
    if (_locationManager == nil) {
        _locationManager = [[AMapLocationManager alloc] init];
    }
    return _locationManager;
}

-(void)showMyPosition
{
    //定位管理器
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    CLLocationDistance distance = 200.0;
    self.locationManager.distanceFilter = distance;
    [self.locationManager startUpdatingLocation];
}

#pragma mark -- 加载班车位置信息
- (void)loadBusLastPosition
{
    [HttpRequest requestWithURLString:GM_ESQ_BUSLASTPOSITION parameters:nil type:HttpRequestTypeGet success:^(id responseObject) {
        if (responseObject) {
            NSError *error = nil;
            NSArray *array = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&error];
            if (array) {
                for (NSDictionary *dict in array) {
                    MAPointAnnotation *annotation = [[MAPointAnnotation alloc] init];
                    annotation.coordinate = CLLocationCoordinate2DMake([dict[@"Latitude"] doubleValue], [dict[@"Longitude"] doubleValue]);
                    annotation.title = dict[@"route_long_name"];
                    annotation.subtitle = dict[@"LicensePlateNo"];
                    [self.annotations addObject:annotation];
                }
            }
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.mapView addAnnotations:self.annotations];
    [self.mapView showAnnotations:self.annotations edgePadding:UIEdgeInsetsMake(20, 20, 20, 80) animated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.mapView addAnnotations:self.annotations];
    [self.mapView showAnnotations:self.annotations edgePadding:UIEdgeInsetsMake(20, 20, 20, 80) animated:YES];
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *pointReuseIndetifier = @"pointReuseIndetifier";
        MAPinAnnotationView *annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation                                                 reuseIdentifier:pointReuseIndetifier];
        }
        annotationView.canShowCallout = YES;
//        annotationView.image = [UIImage imageNamed:@"bus2.png"];
        annotationView.animatesDrop = YES;
        annotationView.draggable = YES;
        annotationView.rightCalloutAccessoryView  = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        annotationView.pinColor  = [self.annotations indexOfObject:annotation] % 3;
        return annotationView;
    }
    return nil;
}

#pragma mark - 高德地图设置
- (void)settingMapView
{
    // 地图罗盘
    self.mapView.showsCompass = NO;
    // 地图交通
    self.mapView.showTraffic = YES;
    // 地图比例尺
    self.mapView.showsScale = NO;
}


- (void)viewWillDisappear:(BOOL)animated
{
    [self cleanMapView];
    [self cleanTimer];
}

#pragma mark - 停止并置空定时器
- (void)cleanTimer
{
    [_timer invalidate];
    _timer = nil;
}

#pragma mark - 销毁地图
- (void)cleanMapView
{
    self.mapView = nil;
    self.mapView.delegate = nil;
    self.mapView.showsUserLocation = NO;
}

- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location
{
    self.myCoord = location.coordinate;
    NSLog(@"经度为:%f 纬度为:%f", self.myCoord.longitude, self.myCoord.latitude);
}

@end
