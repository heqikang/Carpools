//
//  AppDelegate.m
//  Carpools
//
//  Created by ZhengBob on 17/4/2017.
//  Copyright © 2017 Esquel. All rights reserved.
//

#import "AppDelegate.h"
#import "DiscoverViewController.h"

@interface AppDelegate ()<LoginViewDelegate, CLLocationManagerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // 检测网络状态
    [SearchNetTool searchNet];
    
    //配置用户key
    [AMapServices sharedServices].apiKey = @"74ca902d3d0bf0069bc9e30b4ce622f2";
    [self settingLocationManager];
    
    [self loadLoginView];
    self.window.backgroundColor = [UIColor whiteColor];
    if ([IsLoginTool isLogin] == nil) {
        self.loginView.hidden = NO;
        [self.window.rootViewController.view bringSubviewToFront:self.loginView];
    }else
    {
        self.loginView.hidden = YES;
        [self.window.rootViewController.view sendSubviewToBack:self.loginView];
        [self getAlladdress];
    }
    
    return YES;
}

#pragma mark - ******load loginView******
- (void)loadLoginView
{
    self.loginView = [[[NSBundle mainBundle] loadNibNamed:@"LoginView" owner:nil options:nil] firstObject];
    self.loginView.delegate = self;
    self.loginView.frame = [UIScreen mainScreen].bounds;
    [self.window.rootViewController.view addSubview:self.loginView];
    [self.window bringSubviewToFront:self.loginView];
}


#pragma mark - *****LoginViewDelegate 代理方法******
- (void)didClickButtonAction:(UIButton *)button
{
    // 登陆按钮
    if (button.tag == 0) {
        // http://getazlnx001.chinacloudapp.cn:8080/users?method=login&depid='GET0289790'&passwd='0289790'
        if (self.loginView.userNameTextField.text.length > 0 & self.loginView.userPswTextField.text.length > 0) {
            NSString *url = [ESQ_USERS stringByAppendingString:[NSString stringWithFormat:@"method=login&depid='%@'&passwd='%@'", self.loginView.userNameTextField.text, self.loginView.userPswTextField.text]];
            [HttpRequest requestWithURLString:url parameters:nil type:HttpRequestTypeGet success:^(id responseObject) {
                NSError *error = nil;
                if (responseObject) {
                    NSArray *array = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&error];
                    if (array.count > 0) {
                        [USERDEFAULTS setObject:array[0] forKey:@"loginData"];
                        
                        // 返回主线程
                        dispatch_async(dispatch_get_main_queue(), ^{
                            self.loginView.hidden = YES;
                            [self.window.rootViewController.view sendSubviewToBack:self.loginView];
                            [self getAlladdress];
                            [self.window endEditing:YES];
                            // 同步数据
                            [USERDEFAULTS synchronize];
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"successfulLogin" object:nil userInfo:nil];
                        });
                        
                    }
                }
            } failure:^(NSError *error) {
                
            }];
        }
    }
    // 返回按钮
    else if(button.tag == 1){
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
        self.loginView.hidden = YES;
        [self.window.rootViewController.view sendSubviewToBack:self.loginView];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"backBtnDidClick" object:nil userInfo:nil];
        
    }
}

#pragma mark -- 获取所有地址
-(void)getAlladdress{
    
    // http://getazlnx001.chinacloudapp.cn:8080/roadline?method=queryaddressbycompanyid&company_id=1
    NSString *url = [ESQ_ROADLINE stringByAppendingString:[NSString stringWithFormat:@"method=queryaddressbycompanyid&company_id=%@", LOGINDATA[@"company_id"]]];
    [HttpRequest requestWithURLString:url parameters:nil type:HttpRequestTypeGet success:^(id responseObject) {
        if (responseObject) {
            NSError *error = nil;
            NSArray *array = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&error];
            [USERDEFAULTS setObject:array forKey:@"allAddress"];
            dispatch_async(dispatch_get_main_queue(), ^{
                [USERDEFAULTS synchronize];
            });
        }
    } failure:^(NSError *error) {
        
    }];
}


#pragma mark - 创建定位管理器
- (CLLocationManager *)locationManager
{
    if (_locationManager == nil) {
        _locationManager = [[CLLocationManager alloc] init];
    }
    return _locationManager;
}

- (void)settingLocationManager {
    
    if(IS_OS_8_OR_LATER) {
        [self.locationManager requestAlwaysAuthorization];
    }
    //如果没有授权则请求用户授权
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined){
        [self.locationManager requestWhenInUseAuthorization];
    }else if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse){
        //设置代理
        self.locationManager.delegate = self;
        //设置定位精度
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        //定位频率,每隔多少米定位一次
        CLLocationDistance distance = 10.0;//十米定位一次
        self.locationManager.distanceFilter = distance;
        //启动跟踪定位
        [self.locationManager startUpdatingLocation];
    }
    if( [CLLocationManager locationServicesEnabled] ) {
        NSLog(@"Location Services Enabled....");
    }
    else {
        
    }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *location = [locations lastObject];
    CLLocationCoordinate2D coordinate = location.coordinate;
    
    
    @try{
        
        self.mycoordinate = &(coordinate);
        
        [self updateUserPosition:coordinate];
    }
    @catch(NSException *exception) {
        NSLog(@"exception:%@", exception);
    }
    @finally {
        
    }
}

#pragma mark - 上传更新自己的位置信息
- (void)updateUserPosition:(CLLocationCoordinate2D)userCoordinate
{
    if (LOGINDATA[@"uid"]) {
        NSString *url = [ESQ_USERS stringByAppendingString:[NSString stringWithFormat:@"method=update_user_position&user_id=%@&longitude=%@&latitude=%@", LOGINDATA[@"uid"], [NSNumber numberWithDouble:userCoordinate.longitude], [NSNumber numberWithDouble:userCoordinate.latitude]]];
        [HttpRequest requestWithURLString:url parameters:nil type:HttpRequestTypeGet success:^(id responseObject) {
            if (responseObject) {
                
            }
        } failure:^(NSError *error) {
            
        }];
        
    }
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
