//
//  TripViewController.m
//  Carpools
//
//  Created by ZhengBob on 25/4/2017.
//  Copyright © 2017 Esquel. All rights reserved.
//

#import "TripViewController.h"
#import "GroupShadowTableView.h"
#import "AppDelegate.h"
#import "PassengerCell.h"
#import "PassengerTripCell.h"
#import "DriverTripCell.h"
#import "DriverLovewallCell.h"

@interface TripViewController ()<GroupShadowTableViewDelegate, GroupShadowTableViewDataSource, PassengerTripCellDelegate, PassengerCellDelegate, DriverTripCellDelegate>

@property (strong, nonatomic) GroupShadowTableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, assign) NSInteger driverTripIndexPathSection;

@property (nonatomic, assign) NSInteger passengerCellIndexPathSection;

@property (nonatomic, assign) NSInteger passengerTripCellIndexPathSection;

@property (nonatomic, strong) AppDelegate *appDelegate;

@property (nonatomic, strong) MBProgressHUD *loadingHud;


@end

@implementation TripViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的行程";
    [self.view addSubview:self.tableView];
    
    UINib *passengerNib = [UINib nibWithNibName:@"PassengerTripCell" bundle:nil];
    [self.tableView registerNib:passengerNib forCellReuseIdentifier:@"passengertripcell"];
    
    UINib *driverNib = [UINib nibWithNibName:@"DriverTripCell" bundle:nil];
    [self.tableView registerNib:driverNib forCellReuseIdentifier:@"drivertripcell"];
    
    UINib *passengerStatusNib = [UINib nibWithNibName:@"PassengerCell" bundle:nil];
    [self.tableView registerNib:passengerStatusNib forCellReuseIdentifier:@"passengercell"];
    
    UINib *driverLovewallNib = [UINib nibWithNibName:@"DriverLovewallCell" bundle:nil];
    [self.tableView registerNib:driverLovewallNib forCellReuseIdentifier:@"driverlovewallcell"];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    self.appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (LOGINDATA != nil) {
        [self getMyTripInfo];
    }else
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您还没登陆,请先登陆" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [alert addAction:[UIAlertAction actionWithTitle:@"登陆" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self.appDelegate.loginView.hidden = NO;
            [self.appDelegate.window.rootViewController.view bringSubviewToFront:self.appDelegate.loginView];
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

#pragma mark - 获取我的行程信息
- (void)getMyTripInfo
{
    // http://getazlnx001.chinacloudapp.cn:8080/info?method=my_carpool_trip&user_id=72200
    self.loadingHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.loadingHud.mode = MBProgressHUDModeIndeterminate;
    self.loadingHud.label.text = @"玩命加载中...";
    NSString *url = [ESQ_INFO stringByAppendingString:[NSString stringWithFormat:@"method=my_carpool_trip&user_id=%@", LOGINDATA[@"uid"]]];
    [HttpRequest requestGetWithURLString:url parameters:nil success:^(id responseObject) {
        if (responseObject) {
            NSError *error = nil;
            NSArray *array = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&error];
            if (array.count > 0) {
                [self.loadingHud hideAnimated:YES];
                self.dataArray = nil;
                for (NSDictionary *dict in array) {
                    TripModel *model = [[TripModel alloc] init];
                    [model setValuesForKeysWithDictionary:dict];
                    [self.dataArray addObject:model];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
            }else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.loadingHud hideAnimated:YES];
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您没有任何行程" preferredStyle:UIAlertControllerStyleAlert];
                    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
                    [self presentViewController:alert animated:YES completion:nil];
                });
                
            }
        }
    } failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.loadingHud hideAnimated:YES];
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"网络不给力,请重试" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
            [alert addAction:[UIAlertAction actionWithTitle:@"重试" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self getMyTripInfo];
            }]];
            [self presentViewController:alert animated:YES completion:nil];
            
        });
        
    }];
}

#pragma mark - 懒加载
- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[GroupShadowTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) style:UITableViewStyleGrouped];
        _tableView.groupShadowDelegate = self;
        _tableView.groupShadowDataSource = self;
        _tableView.showSeparator = YES;
    }
    return _tableView;
}

- (NSMutableArray *)dataArray
{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (CGFloat)groupShadowTableView:(GroupShadowTableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 160.f;
}

- (NSInteger)numberOfSectionsInGroupShadowTableView:(GroupShadowTableView *)tableView
{
    return self.dataArray.count;
}


#pragma mark -  ******TableView Delegate******
- (NSInteger)groupShadowTableView:(GroupShadowTableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)groupShadowTableView:(GroupShadowTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DriverTripCell *driverCell = [tableView dequeueReusableCellWithIdentifier:@"drivertripcell"];
    driverCell.selectionStyle = UITableViewCellSelectionStyleNone;
    PassengerTripCell *passengerCell = [tableView dequeueReusableCellWithIdentifier:@"passengertripcell"];
    passengerCell.selectionStyle = UITableViewCellSelectionStyleNone;
    PassengerCell *pCell = [tableView dequeueReusableCellWithIdentifier:@"passengercell"];
    pCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    DriverLovewallCell *driverLovewallCell = [tableView dequeueReusableCellWithIdentifier:@"driverlovewallcell"];
    driverLovewallCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (self.dataArray.count > 0) {
        TripModel *model = [[TripModel alloc] init];
        model = self.dataArray[indexPath.section];
        
        if ([model.trip_type isEqualToString:@"1"]) {
            driverLovewallCell.model = model;
            return driverLovewallCell;
        }else
        {
            if ([model.status isEqualToString:@"0"]) {
                pCell.model = model;
                self.passengerCellIndexPathSection = indexPath.section;
                pCell.cancelBtn.tag = 1000 + indexPath.section;
                NSLog(@"pCell.cancelBtn的tag:%ld", pCell.cancelBtn.tag);
                pCell.cancelDelegate = self;
                [pCell.cancelBtn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
                return pCell;
            }else
            {
                if ([LOGINDATA[@"name"] isEqualToString:model.passenger_name]) {
                    passengerCell.model = model;
                    self.passengerTripCellIndexPathSection = indexPath.section;
                    passengerCell.chatBtn.tag = 10 + indexPath.section;
                    passengerCell.phoneBtn.tag = 11 + indexPath.section;
                    passengerCell.cancelBtn.tag = 12 + indexPath.section;
                    passengerCell.delegate = self;
                    return passengerCell;
                }
                else {
                    driverCell.model = model;
                    driverCell.selectionStyle = UITableViewCellSelectionStyleNone;
                    self.driverTripIndexPathSection = indexPath.section;
                    
                    driverCell.chatBtn.tag = 10 + indexPath.section;
                    driverCell.phoneBtn.tag = 11 + indexPath.section;
                    driverCell.cancelBtn.tag = 12 + indexPath.section;
                    driverCell.finishBtn.tag = 13 + indexPath.section;
                    driverCell.delegate = self;
                    return driverCell;
                }
            }
        }
    }else
    {
        return nil;
    }
}

- (void)cancel{
    NSLog(@"点击取消按钮");
}

- (void)didClickPassengerCellButton:(UIButton *)button
{
    TripModel *model = self.dataArray[self.passengerCellIndexPathSection];
    NSLog(@"%ld", button.tag);
}

#pragma mark -- 乘客对司机的操作
- (void)didClickPassengerTripCellButton:(UIButton *)button
{
    TripModel *model = self.dataArray[self.passengerTripCellIndexPathSection];
    NSInteger tag = button.tag - self.passengerTripCellIndexPathSection;
    if (tag == 10) {
        
    }else if (tag == 11){
        NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@", model.driver_phone];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }else if (tag == 12){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"真的要取消搭乘吗" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:nil]];
        [alert addAction:[UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            // http://getazlnx001.chinacloudapp.cn:8080/info?infoid=12533&method=cancelbooking&status=2
            NSString *url = [ESQ_INFO stringByAppendingString:[NSString stringWithFormat:@"infoid=%@&method=cancelbooking&status=2", model.infoid]];
            [HttpRequest requestWithURLString:url parameters:nil type:HttpRequestTypeGet success:^(id responseObject) {
                if (responseObject) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.dataArray removeObject:model];
                        [self.tableView reloadData];
                    });
                }
            } failure:^(NSError *error) {
                
            }];
            
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    }
    NSLog(@"%ld", button.tag);
}

#pragma mark -- 司机对乘客的操作
- (void)didClickDriverTripCellBtn:(UIButton *)button
{
    TripModel *model = self.dataArray[self.driverTripIndexPathSection];
    NSInteger tag = button.tag - self.driverTripIndexPathSection;
    if (tag == 10) {
        NSLog(@"点击了聊天图标");
    }else if (tag == 11){
        NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@", model.passenger_phone];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        NSLog(@"点击了打电话图标");
    }else if (tag == 12){
        
        // http://getazlnx001.chinacloudapp.cn:8080/lovewall?method=cancel_trip_by_driver&user_id=36870&info_id=12635
        NSString *url = [ESQ_LOVEWALL stringByAppendingString:[NSString stringWithFormat:@"user_id=%@&info_id=%@&method=cancel_trip_by_driver", LOGINDATA[@"uid"], model.infoid]];
        
        NSString *string = [NSString stringWithFormat:@"您确信取消 %@ 到 %@ 的行程吗?",  model.passenger_name, model.to_address_name];
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"通知" message:string preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:nil]];
        [alert addAction:[UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [HttpRequest requestWithURLString:url parameters:nil type:HttpRequestTypeGet success:^(id responseObject) {
                if (responseObject) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.dataArray removeObject:model];
                        [self.tableView reloadData];
                    });
                }
            } failure:^(NSError *error) {
                
            }];
        }]];
        [self presentViewController:alert animated:YES completion:nil];
        
        NSLog(@"点击了取消图标");
    }else if (tag == 13){
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"真的完成搭乘吗" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:nil]];
        [alert addAction:[UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            // http://getazlnx001.chinacloudapp.cn:8080/info?method=passagefinishbooking&infoid=13004
            NSString *url = [ESQ_INFO stringByAppendingString:[NSString stringWithFormat:@"method=passagefinishbooking&infoid=%@", model.infoid]];
            [HttpRequest requestWithURLString:url parameters:nil type:HttpRequestTypeGet success:^(id responseObject) {
                if (responseObject) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.dataArray removeObject:model];
                        [self.tableView reloadData];
                    });
                }
            } failure:^(NSError *error) {
                
            }];
        }]];
        
        [self presentViewController:alert animated:YES completion:nil];
        NSLog(@"点击了完成图标");
    }
}




@end
