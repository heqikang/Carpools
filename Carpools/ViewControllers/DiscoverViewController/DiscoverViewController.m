//
//  DiscoverViewController.m
//  Carpools
//
//  Created by ZhengBob on 24/4/2017.
//  Copyright © 2017 Esquel. All rights reserved.
//

#import "DiscoverViewController.h"
#import "NormalCell.h"
#import "LineNormalCell.h"
#import "PopMenuView.h"
#import "LovewallViewController.h"
#import "TripViewController.h"
#import "TakeCarViewController.h"

@interface DiscoverViewController ()<UITableViewDelegate, UITableViewDataSource, PopMenuViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) PopMenuView *popMenuView;

@property (nonatomic, strong) UIButton *coverBtn;

@property (nonatomic, strong) UIButton *rightBarBtn;

@end


static int count = 3;
@implementation DiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发现";
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
    
    UINib *normalNib = [UINib nibWithNibName:@"NormalCell" bundle:nil];
    [self.tableView registerNib:normalNib forCellReuseIdentifier:@"normalcell"];
    
    UINib *lineNormalNib = [UINib nibWithNibName:@"LineNormalCell" bundle:nil];
    [self.tableView registerNib:lineNormalNib forCellReuseIdentifier:@"linenormalcell"];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    [self createRightBarItemButton];

}

- (void)viewWillAppear:(BOOL)animated
{
    [self loadPopMenuView];
}


#pragma mark - 通过Nib加载Xib的PopMenuView视图
- (void)loadPopMenuView
{
    self.popMenuView = [[[NSBundle mainBundle] loadNibNamed:@"PopMenuView" owner:nil options:nil] firstObject];
    self.popMenuView.frame = CGRectMake(kScreenWidth - 125, 5, 120, 0);
    self.popMenuView.backgroundColor = [UIColor whiteColor];
    self.popMenuView.alpha = 0;
    [self.view addSubview:self.popMenuView];
}

#pragma mark - ******PopMenuViewDelegate 代理方法*******
- (void)didClickTableViewCell:(NSIndexPath *)indexPath
{
    NSLog(@"indexPath:%ld", indexPath.row);
    if (indexPath.row == 0) {
        
    }else
    {
        
    }
}

#pragma mark -- ******创建导航栏右侧按钮******
- (void)createRightBarItemButton
{
    self.rightBarBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 24, 24)];
    [self.rightBarBtn setBackgroundImage:[UIImage imageNamed:@"add.png"] forState:UIControlStateNormal];
    [self.rightBarBtn addTarget:self action:@selector(pushPopMenu) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarBtnItem = [[UIBarButtonItem alloc]initWithCustomView:self.rightBarBtn];
    self.navigationItem.rightBarButtonItem = rightBarBtnItem;
}

#pragma mark - 右按钮响应方法(弹出/关闭下拉菜单)
- (void)pushPopMenu
{
    if (self.coverBtn) {
        [self hidePopMenuView];
        return;
    }
    [self showPopMenuView];
}

#pragma mark - 显示下拉菜单
- (void)showPopMenuView
{
    // 创建全屏蒙版按钮
    self.coverBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.coverBtn.frame = kScreenBounds;
    [self.coverBtn addTarget:self action:@selector(hidePopMenuView) forControlEvents:UIControlEventTouchUpInside];
    [UIView animateWithDuration:0.3 delay:0 options:0 animations:^{
        self.popMenuView.frame = CGRectMake(kScreenWidth - 125, 5, 120, 80);
        self.popMenuView.alpha = 1;
    } completion:^(BOOL finished) {
        [self.view insertSubview:self.coverBtn belowSubview:self.popMenuView];
        self.popMenuView.delegate = self;
    }];
}

#pragma mark - 隐藏下拉菜单
- (void)hidePopMenuView
{
    [self.coverBtn removeFromSuperview];
    self.coverBtn = nil;
    self.rightBarBtn.selected = !self.rightBarBtn.selected;
    [UIView animateWithDuration:0.3f delay:0 options:0 animations:^{
        self.popMenuView.frame = CGRectMake(kScreenWidth - 125, 5, 120, 0);
        self.popMenuView.alpha = 0;
    } completion:^(BOOL finished) {
        self.popMenuView.delegate = nil;
    }];
    
}

#pragma mark - 懒加载
- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:kScreenBounds style:UITableViewStyleGrouped];
    }
    return _tableView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title = nil;
    if (section == 0) {
        title = @"行程";
    }else if (section == 1){
        title = @"载客";
    }else
    {
        title = @"搭车";
    }
    return title;
}

#pragma mark -- ******tableView delegate*****
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NormalCell *normalCell = [tableView dequeueReusableCellWithIdentifier:@"normalcell"];
    normalCell.selectionStyle = UITableViewCellSelectionStyleBlue;
    LineNormalCell *lineNormalCell = [tableView dequeueReusableCellWithIdentifier:@"linenormalcell"];
    lineNormalCell.selectionStyle = UITableViewCellSelectionStyleBlue;
    if (indexPath.section == 0) {
        lineNormalCell.lineNormalTitleImageView.image = [UIImage imageNamed:@"journey.png"];
        lineNormalCell.lineNormalTitleLabel.text = @"我的行程";
        return lineNormalCell;
    }else if(indexPath.section == 1)
    {
        lineNormalCell.lineNormalTitleImageView.image = [UIImage imageNamed:@"car.png"];
        lineNormalCell.lineNormalTitleLabel.text = @"乘客约车需求";
        return lineNormalCell;
        
    }else
    {
        
        normalCell.normalTitleImageView.image = [UIImage imageNamed:@"love.png"];
        normalCell.normalTitleLabel.text = @"墙上空座位";
        return normalCell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.hidesBottomBarWhenPushed = YES;
    if (indexPath.section == 0) {
        TripViewController *tripViewController = [[TripViewController alloc] init];
        [self.navigationController pushViewController:tripViewController animated:YES];
        
    }else if (indexPath.section == 1){
        TakeCarViewController *takeCarViewController = [[TakeCarViewController alloc] init];
        [self.navigationController pushViewController:takeCarViewController animated:YES];
    }else if(indexPath.section == 2)
    {
        LovewallViewController *lovewall = [[LovewallViewController alloc] init];
        [self.navigationController pushViewController:lovewall animated:YES];
    }
    self.hidesBottomBarWhenPushed = NO;
}


@end
