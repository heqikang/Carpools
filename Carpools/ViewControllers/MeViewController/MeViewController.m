//
//  MeViewController.m
//  Carpools
//
//  Created by ZhengBob on 24/4/2017.
//  Copyright © 2017 Esquel. All rights reserved.
//

#import "MeViewController.h"
#import "NormalCell.h"
#import "LineNormalCell.h"
#import "SpecialCell.h"
#import "WebPage.h"
#import "AppDelegate.h"
#import "SpecialCell.h"
#import "UserModel.h"
#import "SettingPage.h"
#import <sys/utsname.h>

@interface MeViewController ()<UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    NSString *deviceName;
    NSString *sysVersion;
    NSString *deviceUUID;
    NSDictionary *infoDic;
    // 获取App的版本号
    NSString *appVersion;
    // 获取App的build版本
    NSString *appBuildVersion;
    // 获取App的名称
    NSString *appName;
    NSString *carpool_version;
    NSString *deviceModel1;
    UIView *baseView;
}

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) NSDictionary *userinfo;

@property (nonatomic, strong) NSString *userName;

@property (nonatomic, strong) NSString *userId;

@property (nonatomic, strong) UIButton *userImageBtn;

@property (nonatomic, strong) UIAlertController *alert;

@property (nonatomic, strong) AppDelegate *appDelegate;

@property (nonatomic, strong) MBProgressHUD *loadingHud;

@end

@implementation MeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的";
    [self initCommon];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setTabBarControllerSeletedIndex) name:@"backBtnDidClick" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setTabBarControllerSeletedIndex) name:@"successfulLogin" object:nil];
}

- (void)setTabBarControllerSeletedIndex
{
    self.tabBarController.selectedIndex = 2;
}

#pragma mark - 设置tableView
- (void)settingTableView
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    UINib *normalNib = [UINib nibWithNibName:@"NormalCell" bundle:nil];
    [self.tableView registerNib:normalNib forCellReuseIdentifier:@"normalcell"];
    
    UINib *lineNormalNib = [UINib nibWithNibName:@"LineNormalCell" bundle:nil];
    [self.tableView registerNib:lineNormalNib forCellReuseIdentifier:@"linenormalcell"];
    
    UINib *specialNib = [UINib nibWithNibName:@"SpecialCell" bundle:nil];
    [self.tableView registerNib:specialNib forCellReuseIdentifier:@"specialcell"];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    self.appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (LOGINDATA == nil) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您还没登陆,请先登陆" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [alert addAction:[UIAlertAction actionWithTitle:@"登陆" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            self.appDelegate.loginView.hidden = NO;
            [self.appDelegate.window.rootViewController.view bringSubviewToFront:self.appDelegate.loginView];
        }]];
        [self presentViewController:alert animated:YES completion:nil];
        
    }else
    {
        [self getUserInfo];
    }
}

#pragma mark -- 获取个人信息
- (void)getUserInfo
{
    // http://getazlnx001.chinacloudapp.cn:8080/users?login_name=GET0289790&method=load_user
    self.loadingHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.loadingHud.mode = MBProgressHUDModeIndeterminate;
    self.loadingHud.label.text = @"玩命加载中...";
    NSString *url = [ESQ_USERS stringByAppendingString:[NSString stringWithFormat:@"login_name=%@&method=load_user", LOGINDATA[@"deptid"]]];
    [HttpRequest requestWithURLString:url parameters:nil type:HttpRequestTypeGet success:^(id responseObject) {
        if (responseObject) {
            NSError *error = nil;
            NSArray *array = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&error];
            if (array.count > 0) {
                self.dataArray = nil;
                NSDictionary *dic = [NSDictionary dictionary];
                dic = array[0];
                UserModel *model = [[UserModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [self.dataArray addObject:model];
                
            }else
            {
                NSLog(@"数据异常");
                
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.loadingHud hideAnimated:YES];
                [self settingTableView];
                [self.tableView reloadData];
            });
        }
    } failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.loadingHud hideAnimated:YES];
        });
    }];
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
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.dataArray.count;
    }else{
        return 3 * self.dataArray.count;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title;
    if(section == 0){
        return nil;
    }
    else if(section == 1){
        title = @"账号";
    }else
    {
        title = @"报表";
    }
    return title;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.01;
    }else
    {
        return 30.f;
    }
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
    if (indexPath.section == 0) {
        return 100.f;
    }
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NormalCell *normalCell = [tableView dequeueReusableCellWithIdentifier:@"normalcell"];
    LineNormalCell *lineNormalCell = [tableView dequeueReusableCellWithIdentifier:@"linenormalcell"];
    SpecialCell *specialCell = [tableView dequeueReusableCellWithIdentifier:@"specialcell"];
    if (indexPath.section == 0) {
        UserModel *model = [[UserModel alloc] init];
        model = self.dataArray[indexPath.row];
        
        specialCell.userImageBtn.tag = 10 + indexPath.row;
        
        self.userImageBtn = specialCell.userImageBtn;
        
        NSData *imageData = [[NSUserDefaults standardUserDefaults] objectForKey:@"image"];
        UIImage *image = [UIImage imageWithData:imageData];
        if (image == nil) {
            [self.userImageBtn setBackgroundImage:[UIImage imageNamed:@"user.jpg"] forState:UIControlStateNormal];
        }else
        {
            [self.userImageBtn setBackgroundImage:image forState:UIControlStateNormal];
        }
        
        [self.userImageBtn addTarget:self action:@selector(changeUserImage:) forControlEvents:UIControlEventTouchUpInside];
        
        specialCell.model = model;
        return specialCell;
    }else if(indexPath.section == 1)
    {
        if (indexPath.row == 0) {
            normalCell.normalTitleImageView.image = [UIImage imageNamed:@"setting.png"];
            normalCell.normalTitleLabel.text = @"设置";
            return normalCell;
        }else if(indexPath.row == 1)
        {
            normalCell.normalTitleImageView.image = [UIImage imageNamed:@"QR.png"];
            normalCell.normalTitleLabel.text = @"我的二维码";
            return normalCell;
        }else
        {
            lineNormalCell.lineNormalTitleImageView.image = [UIImage imageNamed:@"help.png"];
            lineNormalCell.lineNormalTitleLabel.text = @"帮助与支持";
            return lineNormalCell;
        }
        
    }else
    {
        if (indexPath.row == 0) {
            lineNormalCell.lineNormalTitleImageView.image = [UIImage imageNamed:@"positive.png"];
            lineNormalCell.lineNormalTitleLabel.text = @"爱与支持,你懂的";
            return lineNormalCell;
        }else if (indexPath.row == 1){
            normalCell.normalTitleImageView.image = [UIImage imageNamed:@"law.png"];
            normalCell.normalTitleLabel.text = @"免责声明";
            return normalCell;
        }else
        {
            normalCell.normalTitleImageView.image = [UIImage imageNamed:@"logout.png"];
            normalCell.normalTitleLabel.text = @"退出登录";
            return normalCell;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            UserModel *model = self.dataArray[indexPath.row];
            SettingPage *settingPage = [[SettingPage alloc] init];
            settingPage.model = model;
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:settingPage animated:YES];
            self.hidesBottomBarWhenPushed = NO;
            
        }else
        {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"持续更新中" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            [self event_log:@"Summary"];
            NSDictionary *logindata = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"logindata"];
            
            NSString *userid =logindata[@"uid"];
            NSString *url;
            url =@"http://getazlnx001.chinacloudapp.cn/carpool/shuttle/index.html?user_id=";
            WebPage *web = [[WebPage alloc] init];
            NSString *urls = [NSString stringWithFormat:@"%@%@",url,userid];
            web.urlStr = urls;
            web.titleString = @"爱与支持";
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:web animated:YES];
            self.hidesBottomBarWhenPushed = NO;
        }else if(indexPath.row == 1){
            [self event_log:@"Legal"];
            WebPage *web = [[WebPage alloc] init];
            NSString *url = @"";
            url = @"http://getazlnx001.chinacloudapp.cn/carpool/shuttle/legal.html";
            web.urlStr = url;
            web.titleString = @"免责声明";
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:web animated:YES];
            self.hidesBottomBarWhenPushed = NO;
        }else
        {
            //透明黑
            baseView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,kScreenWidth, kScreenHeight)];
            baseView.backgroundColor = [UIColor colorWithWhite:0 alpha:.5];
            
            UITapGestureRecognizer *baseViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(baseViewTapAction:)];
            [baseView addGestureRecognizer:baseViewTap];
            [self event_log:@"Logout"];
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"是否退出" message:@"真的要退出吗" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [USERDEFAULTS removeObjectForKey:@"loginData"];
                [USERDEFAULTS synchronize];
                self.appDelegate.loginView.hidden = NO;
                [self.appDelegate.window.rootViewController.view bringSubviewToFront:self.appDelegate.loginView];
                self.appDelegate.loginView.userNameTextField.text = @"";
                self.appDelegate.loginView.userPswTextField.text = @"";
                self.tabBarController.selectedIndex = 2;
                [self.tableView removeFromSuperview];
            }]];
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
            
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
}

+ (NSString*)deviceModelName
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceModel = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    //iPhone 系列
    if ([deviceModel isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([deviceModel isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([deviceModel isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([deviceModel isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceModel isEqualToString:@"iPhone3,2"])    return @"Verizon iPhone 4";
    if ([deviceModel isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceModel isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([deviceModel isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([deviceModel isEqualToString:@"iPhone5,3"])    return @"iPhone 5C";
    if ([deviceModel isEqualToString:@"iPhone5,4"])    return @"iPhone 5C";
    if ([deviceModel isEqualToString:@"iPhone6,1"])    return @"iPhone 5S";
    if ([deviceModel isEqualToString:@"iPhone6,2"])    return @"iPhone 5S";
    if ([deviceModel isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([deviceModel isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([deviceModel isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([deviceModel isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    
    //iPod 系列
    if ([deviceModel isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([deviceModel isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([deviceModel isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([deviceModel isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([deviceModel isEqualToString:@"iPod5,1"])      return @"iPod Touch 5G";
    
    //iPad 系列
    if ([deviceModel isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([deviceModel isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([deviceModel isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([deviceModel isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([deviceModel isEqualToString:@"iPad2,4"])      return @"iPad 2 (32nm)";
    if ([deviceModel isEqualToString:@"iPad2,5"])      return @"iPad mini (WiFi)";
    if ([deviceModel isEqualToString:@"iPad2,6"])      return @"iPad mini (GSM)";
    if ([deviceModel isEqualToString:@"iPad2,7"])      return @"iPad mini (CDMA)";
    
    if ([deviceModel isEqualToString:@"iPad3,1"])      return @"iPad 3(WiFi)";
    if ([deviceModel isEqualToString:@"iPad3,2"])      return @"iPad 3(CDMA)";
    if ([deviceModel isEqualToString:@"iPad3,3"])      return @"iPad 3(4G)";
    if ([deviceModel isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([deviceModel isEqualToString:@"iPad3,5"])      return @"iPad 4 (4G)";
    if ([deviceModel isEqualToString:@"iPad3,6"])      return @"iPad 4 (CDMA)";
    
    if ([deviceModel isEqualToString:@"iPad4,1"])      return @"iPad Air";
    if ([deviceModel isEqualToString:@"iPad4,2"])      return @"iPad Air";
    if ([deviceModel isEqualToString:@"iPad4,3"])      return @"iPad Air";
    if ([deviceModel isEqualToString:@"iPad5,3"])      return @"iPad Air 2";
    if ([deviceModel isEqualToString:@"iPad5,4"])      return @"iPad Air 2";
    if ([deviceModel isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceModel isEqualToString:@"x86_64"])       return @"Simulator";
    
    if ([deviceModel isEqualToString:@"iPad4,4"]
        ||[deviceModel isEqualToString:@"iPad4,5"]
        ||[deviceModel isEqualToString:@"iPad4,6"])      return @"iPad mini 2";
    
    if ([deviceModel isEqualToString:@"iPad4,7"]
        ||[deviceModel isEqualToString:@"iPad4,8"]
        ||[deviceModel isEqualToString:@"iPad4,9"])      return @"iPad mini 3";
    
    return deviceModel;
}

-(void)initCommon{
    
    deviceName = [[UIDevice currentDevice] name];
    
    sysVersion = [[UIDevice currentDevice] systemVersion];
    sysVersion = [@"iOS " stringByAppendingString:sysVersion];
    deviceUUID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    
    infoDic = [[NSBundle mainBundle] infoDictionary];
    // 获取App的版本号
    appVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    // 获取App的build版本
    appBuildVersion = [infoDic objectForKey:@"CFBundleVersion"];
    // 获取App的名称
    appName = [infoDic objectForKey:@"CFBundleDisplayName"];
    
    carpool_version = @"iOS 2.02";
    
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceModel = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    //iPhone 系列
    if ([deviceModel isEqualToString:@"iPhone1,1"])    deviceModel1 =  @"iPhone 1G";
    if ([deviceModel isEqualToString:@"iPhone1,2"])    deviceModel1 = @"iPhone 3G";
    if ([deviceModel isEqualToString:@"iPhone2,1"])    deviceModel1 = @"iPhone 3GS";
    if ([deviceModel isEqualToString:@"iPhone3,1"])    deviceModel1 = @"iPhone 4";
    if ([deviceModel isEqualToString:@"iPhone3,2"])    deviceModel1 = @"Verizon iPhone 4";
    if ([deviceModel isEqualToString:@"iPhone4,1"])    deviceModel1 = @"iPhone 4S";
    if ([deviceModel isEqualToString:@"iPhone5,1"])    deviceModel1 = @"iPhone 5";
    if ([deviceModel isEqualToString:@"iPhone5,2"])    deviceModel1 = @"iPhone 5";
    if ([deviceModel isEqualToString:@"iPhone5,3"])    deviceModel1 = @"iPhone 5C";
    if ([deviceModel isEqualToString:@"iPhone5,4"])    deviceModel1 = @"iPhone 5C";
    if ([deviceModel isEqualToString:@"iPhone6,1"])    deviceModel1 = @"iPhone 5S";
    if ([deviceModel isEqualToString:@"iPhone6,2"])    deviceModel1 = @"iPhone 5S";
    if ([deviceModel isEqualToString:@"iPhone7,1"])    deviceModel1 = @"iPhone 6 Plus";
    if ([deviceModel isEqualToString:@"iPhone7,2"])    deviceModel1 = @"iPhone 6";
    if ([deviceModel isEqualToString:@"iPhone8,1"])    deviceModel1 = @"iPhone 6s";
    if ([deviceModel isEqualToString:@"iPhone8,2"])    deviceModel1 = @"iPhone 6s Plus";
    
    //iPod 系列
    if ([deviceModel isEqualToString:@"iPod1,1"])      deviceModel1 = @"iPod Touch 1G";
    if ([deviceModel isEqualToString:@"iPod2,1"])      deviceModel1 = @"iPod Touch 2G";
    if ([deviceModel isEqualToString:@"iPod3,1"])      deviceModel1 = @"iPod Touch 3G";
    if ([deviceModel isEqualToString:@"iPod4,1"])      deviceModel1 = @"iPod Touch 4G";
    if ([deviceModel isEqualToString:@"iPod5,1"])      deviceModel1 = @"iPod Touch 5G";
    
    //iPad 系列
    if ([deviceModel isEqualToString:@"iPad1,1"])      deviceModel1 = @"iPad";
    if ([deviceModel isEqualToString:@"iPad2,1"])      deviceModel1 = @"iPad 2 (WiFi)";
    if ([deviceModel isEqualToString:@"iPad2,2"])      deviceModel1 = @"iPad 2 (GSM)";
    if ([deviceModel isEqualToString:@"iPad2,3"])      deviceModel1 = @"iPad 2 (CDMA)";
    if ([deviceModel isEqualToString:@"iPad2,4"])      deviceModel1 = @"iPad 2 (32nm)";
    if ([deviceModel isEqualToString:@"iPad2,5"])      deviceModel1 = @"iPad mini (WiFi)";
    if ([deviceModel isEqualToString:@"iPad2,6"])      deviceModel1 = @"iPad mini (GSM)";
    if ([deviceModel isEqualToString:@"iPad2,7"])      deviceModel1 = @"iPad mini (CDMA)";
    
    if ([deviceModel isEqualToString:@"iPad3,1"])      deviceModel1 = @"iPad 3(WiFi)";
    if ([deviceModel isEqualToString:@"iPad3,2"])      deviceModel1 = @"iPad 3(CDMA)";
    if ([deviceModel isEqualToString:@"iPad3,3"])      deviceModel1 = @"iPad 3(4G)";
    if ([deviceModel isEqualToString:@"iPad3,4"])      deviceModel1 = @"iPad 4 (WiFi)";
    if ([deviceModel isEqualToString:@"iPad3,5"])      deviceModel1 = @"iPad 4 (4G)";
    if ([deviceModel isEqualToString:@"iPad3,6"])      deviceModel1 = @"iPad 4 (CDMA)";
    
    if ([deviceModel isEqualToString:@"iPad4,1"])      deviceModel1 = @"iPad Air";
    if ([deviceModel isEqualToString:@"iPad4,2"])      deviceModel1 = @"iPad Air";
    if ([deviceModel isEqualToString:@"iPad4,3"])      deviceModel1 = @"iPad Air";
    if ([deviceModel isEqualToString:@"iPad5,3"])      deviceModel1 = @"iPad Air 2";
    if ([deviceModel isEqualToString:@"iPad5,4"])      deviceModel1 = @"iPad Air 2";
    if ([deviceModel isEqualToString:@"i386"])         deviceModel1 = @"Simulator";
    if ([deviceModel isEqualToString:@"x86_64"])       deviceModel1 = @"Simulator";
    
    if ([deviceModel isEqualToString:@"iPad4,4"]
        ||[deviceModel isEqualToString:@"iPad4,5"]
        ||[deviceModel isEqualToString:@"iPad4,6"])      deviceModel1 = @"iPad mini 2";
    
    if ([deviceModel isEqualToString:@"iPad4,7"]
        ||[deviceModel isEqualToString:@"iPad4,8"]
        ||[deviceModel isEqualToString:@"iPad4,9"])      deviceModel1 = @"iPad mini 3";
    
}

#pragma mark -- 检查系统版本,设备信息及软件版本等相关信息
-(void)event_log:(NSString *)module_name {
    
    @try {
        if (LOGINDATA != nil) {
            NSString *url = [ESQ_USERS stringByAppendingString:[NSString stringWithFormat:@"user_id=%@&method=event_log&module_name=%@&os=%@&device=%@&carpool_version=%@", LOGINDATA[@"uid"], module_name, sysVersion, deviceModel1, carpool_version]];
            [HttpRequest requestWithURLString:url parameters:nil type:HttpRequestTypeGet success:^(id responseObject) {
                
            } failure:^(NSError *error) {
                
            }];
        }
        
    } @catch (NSException *exception) {
        
    } @finally {
    }
    
}


#pragma mark -- 修改头像方法
- (void)changeUserImage:(UIButton *)btn
{
    UIImagePickerController *pickController = [[UIImagePickerController alloc] init];
    
    pickController.delegate = self;
    pickController.allowsEditing = YES;
    
    self.alert = [UIAlertController alertControllerWithTitle:@"图片选取" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [self.alert addAction:[UIAlertAction actionWithTitle:@"从相册中选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        pickController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        //        [pickController.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19], NSForegroundColorAttributeName:[UIColor redColor]}];
        
        // 设置模态出来的页面的标题颜色
        [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
        [self presentViewController:pickController animated:YES completion:nil];
    }]];
    
    [self.alert addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        pickController.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:pickController animated:YES completion:nil];
    }]];
    
    [self.alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    
    [self presentViewController:self.alert animated:YES completion:nil];
}


#pragma mark -- 取消图片选择
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark -- 图片选择接受后的方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image = info[@"UIImagePickerControllerEditedImage"];
    NSData *imageData = UIImagePNGRepresentation(image);
    //当图片不为空时显示图片并保存图片
    if (image != nil) {
        //图片显示在界面上
        [self.userImageBtn setBackgroundImage:image forState:UIControlStateNormal];
        
        [[NSUserDefaults standardUserDefaults] setObject:imageData forKey:@"image"];
        
    }
    //关闭相册界面
    
    NSDictionary *dict = @{@"data":imageData};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeIcon2" object:nil userInfo:dict];
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    
}

#pragma mark -UIButton action
- (void)baseViewTapAction:(UITapGestureRecognizer *)tap
{
    [baseView removeFromSuperview];
    baseView = nil;
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
