//
//  BusViewController.m
//  Carpools
//
//  Created by ZhengBob on 24/4/2017.
//  Copyright © 2017 Esquel. All rights reserved.
//

#import "BusViewController.h"
#import "NormalCell.h"
#import "LineNormalCell.h"
#import "ScheduleViewController.h"
#import "BusInfoViewController.h"

@interface BusViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation BusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"班车";
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    UINib *normalNib = [UINib nibWithNibName:@"NormalCell" bundle:nil];
    [self.tableView registerNib:normalNib forCellReuseIdentifier:@"normalcell"];
    
    UINib *lineNormalNib = [UINib nibWithNibName:@"LineNormalCell" bundle:nil];
    [self.tableView registerNib:lineNormalNib forCellReuseIdentifier:@"linenormalcell"];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor whiteColor];
}

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title;
    if (section == 0) {
        title = @"公司班车";
    }else if (section == 1){
        title = @"公共汽车";
    }else
    {
        title = @"长途巴士";
    }
    return title;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5.f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NormalCell *normalCell = [tableView dequeueReusableCellWithIdentifier:@"normalcell"];
    LineNormalCell *lineNormalCell = [tableView dequeueReusableCellWithIdentifier:@"linenormalcell"];
    if (indexPath.section == 0 || indexPath.section == 1) {
        if (indexPath.row == 0) {
            normalCell.normalTitleImageView.image = [UIImage imageNamed:@"time.png"];
            normalCell.normalTitleLabel.text = @"时刻表";
            return normalCell;
        }else
        {
            lineNormalCell.lineNormalTitleImageView.image = [UIImage imageNamed:@"location.png"];
            lineNormalCell.lineNormalTitleLabel.text = @"实时位置";
            return lineNormalCell;
        }
        
    }else
    {
        if (indexPath.row == 0) {
            normalCell.normalTitleImageView.image = [UIImage imageNamed:@"time.png"];
            normalCell.normalTitleLabel.text = @"时刻表";
        }else
        {
            normalCell.normalTitleImageView.image = [UIImage imageNamed:@"location.png"];
            normalCell.normalTitleLabel.text = @"实时位置";
        }
        return normalCell;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.hidesBottomBarWhenPushed = YES;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            ScheduleViewController *scheduleViewController = [[ScheduleViewController alloc] init];
            scheduleViewController.urlStr = @"http://getazlnx001.chinacloudapp.cn/carpool/routes/busschedule.html";
            [self.navigationController pushViewController:scheduleViewController animated:YES];
        }else
        {
            BusInfoViewController *busInfoViewController = [[BusInfoViewController alloc] init];
            [self.navigationController pushViewController:busInfoViewController animated:YES];
        }
    }else
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"持续更新中" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }
    self.hidesBottomBarWhenPushed = NO;
}

@end
