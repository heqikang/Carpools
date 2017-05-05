//
//  SettingPage.m
//  Carpool
//
//  Created by ZhengBob on 15/3/2017.
//  Copyright © 2017 Esquel. All rights reserved.
//

#import "SettingPage.h"
#import "SettingCell.h"
#import "TipView.h"
#import "LineSettingCell.h"

@interface SettingPage ()<UITableViewDelegate, UITableViewDataSource>
{
    UIView *baseView;
    TipView *tipView;
}

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSString *addressid;

@property (nonatomic, strong) NSDictionary *userinfo;

@end

@implementation SettingPage

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    UINib *nib = [UINib nibWithNibName:@"SettingCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"settingcell"];
    UINib *lineNib = [UINib nibWithNibName:@"LineSettingCell" bundle:nil];
    [self.tableView registerNib:lineNib forCellReuseIdentifier:@"linesettingcell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.userinfo = [userDefaults dictionaryForKey:@"logindata"];
    
    self.tableView.backgroundColor = [UIColor whiteColor];
}

- (NSDictionary *)userinfo
{
    if (_userinfo == nil) {
        _userinfo = [NSDictionary dictionary];
    }
    return _userinfo;
}

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) style:UITableViewStyleGrouped];
    }
    return _tableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else{
        return 2;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 50;
    }else
    {
        return 30.f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5.f;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title;
    if (section == 0) {
        title = @"联系方式";
    }else if (section == 1){
        title = @"车辆信息";
    }else
    {
        title = @"地址";
    }
    return title;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SettingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"settingcell"];
    LineSettingCell *lineCell = [tableView dequeueReusableCellWithIdentifier:@"linesettingcell"];
    [cell.cellBtn addTarget:self action:@selector(modify:) forControlEvents:UIControlEventTouchUpInside];
    [lineCell.cellBtn addTarget:self action:@selector(modify:) forControlEvents:UIControlEventTouchUpInside];
    lineCell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    if (indexPath.section == 0) {
        lineCell.cellImageView.image = [UIImage imageNamed:@"setting_phone.png"];
        lineCell.cellLabel.text = @"电话";
        lineCell.cellTextField.text = self.model.phone;
        lineCell.cellBtn.tag = 10 + indexPath.section;
        tipView.sureBtn.tag = lineCell.cellBtn.tag;;
        
        return lineCell;
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            cell.cellImageView.image = [UIImage imageNamed:@"setting_carNumber.png"];
            cell.cellLabel.text = @"车牌";
            cell.cellTextField.text = self.model.carnumber;
            cell.cellBtn.tag = 11 + indexPath.section;
            tipView.sureBtn.tag = cell.cellBtn.tag;
            return cell;
        }else{
            lineCell.cellImageView.image = [UIImage imageNamed:@"setting_car.png"];
            lineCell.cellLabel.text = @"汽车型号";
            lineCell.cellTextField.text = self.model.cartype;
            lineCell.cellBtn.tag = 12 + indexPath.section;
            tipView.sureBtn.tag = lineCell.cellBtn.tag;
            return lineCell;
        }
    }else
    {
        if (indexPath.row == 0) {
            cell.cellImageView.image = [UIImage imageNamed:@"setting_home.png"];
            cell.cellLabel.text = @"家";
            cell.cellTextField.text = self.model.home_address_name;
            cell.cellBtn.tag = 13 + indexPath.section;
            tipView.sureBtn.tag = cell.cellBtn.tag;
            return cell;
        }else
        {
            lineCell.cellImageView.image = [UIImage imageNamed:@"setting_factory.png"];
            lineCell.cellLabel.text = @"公司";
            lineCell.cellTextField.text = self.model.work_address_name;
            lineCell.cellBtn.tag = 14 + indexPath.section;
            tipView.sureBtn.tag = lineCell.cellBtn.tag;
            return lineCell;
        }
    }
    
}

- (void)modify:(UIButton *)btn
{
    
//    if (btn.tag - 10 == 0 || btn.tag - 11 == 1 || btn.tag - 12 == 1) {
        [tipView removeFromSuperview];
        //透明黑
        baseView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        baseView.backgroundColor = [UIColor colorWithWhite:0 alpha:.5];
        
        UITapGestureRecognizer *baseViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelBtnAction)];
        [baseView addGestureRecognizer:baseViewTap];
        [self.view addSubview:baseView];
        tipView = [[TipView alloc] initWithFrame:CGRectMake(16, kScreenWidth / 3, kScreenWidth - 32, 120)];
        [self.view addSubview:tipView];
        tipView.backgroundColor = [UIColor whiteColor];
        
//        tipView.center = self.view.center;
        [tipView.cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [tipView.cancelBtn addTarget:self action:@selector(cancelBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [tipView.sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    tipView.sureBtn.tag = btn.tag;
    [tipView.sureBtn addTarget:self action:@selector(sureBtnAction:) forControlEvents:UIControlEventTouchUpInside];
//    }
    if (btn.tag - 10 == 0) {
        tipView.tipLabel.text = @"修改电话号码";
        tipView.tipImageView.image = [UIImage imageNamed:@"setting_phone.png"];
        tipView.tipTextField.text = self.model.phone;
        [tipView.tipTextField becomeFirstResponder];
    }else if(btn.tag - 11 == 1){
        tipView.tipLabel.text = @"修改车牌号码";
        tipView.tipImageView.image = [UIImage imageNamed:@"setting_carNumber.png"];
        tipView.tipTextField.text = self.model.carnumber;
        [tipView.tipTextField becomeFirstResponder];
    }else if(btn.tag - 12 == 1){
        tipView.tipLabel.text = @"修改汽车型号";
        tipView.tipImageView.image = [UIImage imageNamed:@"setting_car.png"];
        tipView.tipTextField.text = self.model.cartype;
        [tipView.tipTextField becomeFirstResponder];
    }else if (btn.tag - 13 == 2 || btn.tag - 14 == 2){
        tipView.tipLabel.text = @"修改地址";
//        RoadlineTableVC *textroadline = [[RoadlineTableVC alloc]init];
//        [self.navigationController pushViewController:textroadline animated:YES];
//        textroadline.sendAddress = ^(NSMutableDictionary *dic){
//            tipView.tipTextField.text = dic[@"addressname"];
//            self.addressid = dic[@"addressid"];
//            NSLog(@"addressid:%@", self.addressid);
//        };
    }else
    {
        
    }
}

- (void)cancelBtnAction
{
    [baseView removeFromSuperview];
    baseView = nil;
    [tipView removeFromSuperview];
    tipView = nil;
}

- (void)getUserInfo
{
    // http://getazlnx001.chinacloudapp.cn:8080/users?login_name=GET0289790&method=load_user
    
    NSString *url = [ESQ_USERS stringByAppendingString:[NSString stringWithFormat:@"login_name=%@&method=load_user", LOGINDATA[@"deptid"]]];
    
    [HttpRequest requestWithURLString:url parameters:nil type:HttpRequestTypeGet success:^(id responseObject) {
        if (responseObject) {
            NSError *error = nil;
            NSArray *array = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&error];
            if (array.count > 0) {
                NSDictionary *dic = [NSDictionary dictionary];
                dic = array[0];
                for (NSDictionary *dict in array) {
                    self.model = [[UserModel alloc] init];
                    [self.model setValuesForKeysWithDictionary:dict];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self.tableView reloadData];
                });
            }
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)sureBtnAction:(UIButton *)btn
{
    // http://getazlnx001.chinacloudapp.cn:8080/users?user_id=72200&field_name=phone&new_value=15767382958&method=updateuserbyfield
    NSString *url = nil;
    if (btn.tag - 10 == 0) {
        url = [ESQ_USERS stringByAppendingString:[NSString stringWithFormat:@"user_id=%@&field_name=phone&new_value=%@&method=updateuserbyfield", self.model.uid, tipView.tipTextField.text]];
//        param = @{@"user_id":self.model.uid, @"field_name":@"phone",@"new_value":tipView.tipTextField.text, @"method":@"updateuserbyfield"};
    }else if (btn.tag - 11 == 1) {
        url = [ESQ_USERS stringByAppendingString:[NSString stringWithFormat:@"user_id=%@&field_name=carnumber&new_value=%@&method=updateuserbyfield", self.model.uid, tipView.tipTextField.text]];
//        param = @{@"user_id":self.model.uid, @"field_name":@"carnumber",@"new_value":tipView.tipTextField.text, @"method":@"updateuserbyfield"};
    }else if(btn.tag - 12 == 1){
        url = [ESQ_USERS stringByAppendingString:[NSString stringWithFormat:@"user_id=%@&field_name=cartype&new_value=%@&method=updateuserbyfield", self.model.uid, tipView.tipTextField.text]];
//        param = @{@"user_id":self.model.uid, @"field_name":@"cartype",@"new_value":tipView.tipTextField.text, @"method":@"updateuserbyfield"};
    }else if (btn.tag - 13 == 2){
        url = [ESQ_USERS stringByAppendingString:[NSString stringWithFormat:@"user_id=%@&field_name=home_address_id&new_value=%@&method=updateuserbyfield", self.model.uid, tipView.tipTextField.text]];
//        param = @{@"user_id":self.model.uid, @"field_name":@"home_address_id",@"new_value":self.addressid, @"method":@"updateuserbyfield"};
    }else if(btn.tag - 14 == 2){
        url = [ESQ_USERS stringByAppendingString:[NSString stringWithFormat:@"user_id=%@&field_name=company_address_id&new_value=%@&method=updateuserbyfield", self.model.uid, tipView.tipTextField.text]];
//        param = @{@"user_id":self.model.uid, @"field_name":@"company_address_id",@"new_value":self.addressid, @"method":@"updateuserbyfield"};
    }
    
    [HttpRequest requestWithURLString:url parameters:nil type:HttpRequestTypeGet success:^(id responseObject) {
        if (responseObject) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"修改成功" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [tipView removeFromSuperview];
                [baseView removeFromSuperview];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self getUserInfo];
                });
            }]];
            [self presentViewController:alert animated:YES completion:nil];
        }else
        {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"修改失败" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [tipView removeFromSuperview];
                [baseView removeFromSuperview];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self getUserInfo];
                });
            }]];
            [self presentViewController:alert animated:YES completion:nil];
        }
    } failure:^(NSError *error) {
        
    }];
}


@end
