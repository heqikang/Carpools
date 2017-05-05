//
//  TakeCarViewController.m
//  Carpools
//
//  Created by ZhengBob on 5/5/2017.
//  Copyright © 2017 Esquel. All rights reserved.
//

#import "TakeCarViewController.h"
#import "AppDelegate.h"
#import "TakeCarModel.h"
#import "TakeCarCell.h"
#import "TripViewController.h"
#import "GroupShadowTableView.h"

static BOOL isSelected = NO;

@interface TakeCarViewController ()<GroupShadowTableViewDelegate, GroupShadowTableViewDataSource>

@property (nonatomic, strong) GroupShadowTableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) NSString *passengerName;

@property (nonatomic, strong) NSString *destination;

@property (nonatomic, assign) NSIndexPath *indexPath;

@property (nonatomic, strong) AppDelegate *appDelegate;

@property (nonatomic, strong) MBProgressHUD *loadingHud;


@end

@implementation TakeCarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"乘客约车需求";
    self.view.backgroundColor = [UIColor colorWithRed:229.0/255.0 green:235.0/255.0 blue:242.0/255.0 alpha:1];
    
    [self.view addSubview:self.tableView];
    
    UINib *nib = [UINib nibWithNibName:@"TakeCarCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"takeCarCell"];
    
    self.tableView.backgroundColor = [UIColor colorWithRed:229.0/255.0 green:235.0/255.0 blue:242.0/255.0 alpha:1];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getPassengerRequestInfo) name:@"successfulLogin" object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (LOGINDATA == nil) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您还没登陆,请先登陆" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [alert addAction:[UIAlertAction actionWithTitle:@"登陆" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self.appDelegate.loginView.hidden = NO;
            [self.appDelegate.window.rootViewController.view bringSubviewToFront:self.appDelegate.loginView];
        }]];
        [self presentViewController:alert animated:YES completion:nil];
        
    }else
    {
        [self getPassengerRequestInfo];
    }
}

#pragma mark -- 懒加载
- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[GroupShadowTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
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

#pragma mark -- 获取乘客约车需求
- (void)getPassengerRequestInfo
{
    
    self.loadingHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.loadingHud.mode = MBProgressHUDModeIndeterminate;
    self.loadingHud.label.text = @"玩命加载中...";
    // http://getazlnx001.chinacloudapp.cn:8080/info?method=carownerqueryallbooking&carownid=72200
    NSString *url = [ESQ_INFO stringByAppendingString:[NSString stringWithFormat:@"method=carownerqueryallbooking&carownid=%@", LOGINDATA[@"uid"]]];
    [HttpRequest requestWithURLString:url parameters:nil type:HttpRequestTypeGet success:^(id responseObject) {
        if (responseObject) {
            NSError *error = nil;
            NSArray *array = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&error];
            if (array.count == 0) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"暂时没人发约车需求" preferredStyle:UIAlertControllerStyleAlert];
                    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:0 handler:nil]];
                    [self presentViewController:alert animated:YES completion:nil];
                });
            }else
            {
                self.dataArray = nil;
                for (NSDictionary *dict in array) {
                    TakeCarModel *model = [[TakeCarModel alloc] init];
                    
                    [model setValuesForKeysWithDictionary:dict];
                    
                    [self.dataArray addObject:model];
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.loadingHud hideAnimated:YES];
                [self.tableView reloadData];
            });
        }
    } failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.loadingHud hideAnimated:YES];
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"网络不给力,请重试" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
            [alert addAction:[UIAlertAction actionWithTitle:@"重试" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self getPassengerRequestInfo];
            }]];
            [self presentViewController:alert animated:YES completion:nil];
        });
    }];
}

#pragma mark -- 返回分区数
- (NSInteger)numberOfSectionsInGroupShadowTableView:(GroupShadowTableView *)tableView {
    return self.dataArray.count;
}

#pragma mark -- 返回行高
- (CGFloat)groupShadowTableView:(GroupShadowTableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150;
}

#pragma mark -- 返回分区数
- (NSInteger)groupShadowTableView:(GroupShadowTableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

#pragma mark -- 显示cell
- (UITableViewCell *)groupShadowTableView:(GroupShadowTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TakeCarCell *cell = [tableView dequeueReusableCellWithIdentifier:@"takeCarCell"];
    TakeCarModel *model = self.dataArray[indexPath.section];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = model;
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


@end
