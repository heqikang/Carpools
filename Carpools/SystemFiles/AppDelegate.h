//
//  AppDelegate.h
//  Carpools
//
//  Created by ZhengBob on 17/4/2017.
//  Copyright © 2017 Esquel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginView.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <CoreLocation/CoreLocation.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) UITabBarController *tabVc;

@property (nonatomic, strong) LoginView *loginView;

@property (nonatomic, strong) CLLocationManager *locationManager;

@property (nonatomic, assign) CLLocationCoordinate2D *mycoordinate;

@end

