//
//  LovewallViewController.m
//  Carpools
//
//  Created by ZhengBob on 25/4/2017.
//  Copyright © 2017 Esquel. All rights reserved.
//

#import "LovewallViewController.h"
#import "LovewallCell.h"
#import "LovewallModel.h"

@interface LovewallViewController ()<UITableViewDelegate, UITableViewDataSource, LovewallCellDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) NSMutableArray *containArray;

@property (nonatomic, strong) MBProgressHUD *loadingHud;

@end


static int count;
@implementation LovewallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"墙上空座位";
    self.view.backgroundColor = [UIColor whiteColor];
    UINib *nib = [UINib nibWithNibName:@"LovewallCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"lovewallcell"];
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self getLovewallInfo];
}


#pragma mark - 获取墙上的空座位信息
- (void)getLovewallInfo
{
    //    http://getazlnx001.chinacloudapp.cn:8080/lovewall?method=open_lovewallbycompanyid&company_id=1
    self.loadingHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.loadingHud.label.text = @"努力加载中...";
    self.loadingHud.mode = MBProgressHUDModeIndeterminate;
    
    [HttpRequest requestWithURLString:GM_ESQ_LOVEWALL parameters:nil type:HttpRequestTypeGet success:^(id responseObject) {
        if (responseObject) {
            self.dataArray = nil;
            NSError *error = nil;
            NSArray *array = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&error];
            if (array.count == 0) {
                [self.loadingHud hideAnimated:YES];
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"墙上暂没有空座位哦!" message:@"要不您来发一个?" preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"再想一想" style:UIAlertActionStyleCancel handler:nil]];
                [self presentViewController:alert animated:YES completion:nil];
            }else
            {
                [self.loadingHud hideAnimated:YES];
                [self.loadingHud removeFromSuperview];
                for (NSDictionary *dict in array) {
                    LovewallModel *model = [[LovewallModel alloc] init];
                    [model setValuesForKeysWithDictionary:dict];
                    [self.dataArray addObject:model];
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }
    } failure:^(NSError *error) {
        [self.loadingHud hideAnimated:YES];
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"网络异常, 请重试" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
            [alert addAction:[UIAlertAction actionWithTitle:@"重试" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                [self getLovewallInfo];
            }]];
            [self presentViewController:alert animated:YES completion:nil];
        });
    }];
    
}

#pragma mark - 懒加载
- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
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

- (NSMutableArray *)containArray
{
    if (_containArray == nil) {
        _containArray = [NSMutableArray array];
    }
    return _containArray;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 165.f;
}

#pragma mark - *******UITableView Delegate********
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    @try {
        LovewallCell *cell = [tableView dequeueReusableCellWithIdentifier:@"lovewallcell"];
        LovewallModel *model = [[LovewallModel alloc] init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        model = self.dataArray[indexPath.row];
        
        cell.popularBtn.tag = 10 + indexPath.row;
        cell.delegate = self;
        cell.backgroundColor = [UIColor clearColor];
        cell.model = model;
        return cell;
        
    } @catch (NSException *exception) {
        return nil;
    } @finally {
        
    }
}

#pragma mark - 点赞按钮响应方法
- (void)didClickButtonAction:(UIButton *)button
{
    
    // 获取点赞信息
    // http://getazlnx001.chinacloudapp.cn:8080/lovewall?method=likebylovewallid&love_wall_id=11712
    
    // 发送点赞请求
    // http://getazlnx001.chinacloudapp.cn:8080/lovewall?method=likelovewall&love_wall_id=11712&uid=72200
    if (LOGINDATA) {
        LovewallModel *model = self.dataArray[button.tag - 10];
        
        NSString *getLikeInfoUrl = [ESQ_LOVEWALL stringByAppendingString:[NSString stringWithFormat:@"method=likebylovewallid&love_wall_id=%@",model.love_wall_ID]];
        NSString *url = [ESQ_LOVEWALL stringByAppendingString:[NSString stringWithFormat:@"method=likelovewall&love_wall_id=%@&uid=%@", model.love_wall_ID, LOGINDATA[@"uid"]]];
        [HttpRequest requestWithURLString:getLikeInfoUrl parameters:nil type:HttpRequestTypeGet success:^(id responseObject) {
            if (responseObject) {
                NSError *error = nil;
                self.containArray = nil;
                NSArray *array = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&error];
                if (array.count > 0) {
                    for (NSDictionary *dict in array) {
                        if ([dict[@"Name"] isEqualToString:LOGINDATA[@"name"]]) {
                            [self.containArray addObject:dict];
                        }
                    }
                    if (self.containArray.count == 0) {
                        [HttpRequest requestWithURLString:url parameters:nil type:HttpRequestTypeGet success:^(id responseObject) {
                            count = 0;
                            count++;
                            [model setValue:@([model.liked_count intValue] + count) forKey:@"liked_count"];
                            [self getLovewallInfo];
                        } failure:^(NSError *error) {
                            
                        }];
                    }
                }else
                {
                    [HttpRequest requestWithURLString:url parameters:nil type:HttpRequestTypeGet success:^(id responseObject) {
                        count = 0;
                        count++;
                        [model setValue:@([model.liked_count intValue] + count) forKey:@"liked_count"];
                        [self getLovewallInfo];
                    } failure:^(NSError *error) {
                        
                    }];
                }
            }
        } failure:^(NSError *error) {
            
        }];
    }
    
    

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.hidesBottomBarWhenPushed = YES;
    
    
    
    
    self.hidesBottomBarWhenPushed = YES;
}

- (void)viewWillLayoutSubviews
{
    
}


@end
