//
//  SearchNetTool.m

#import "SearchNetTool.h"
#import "AFNetworking.h"
@implementation SearchNetTool
+ (void)searchNet{
    //检测网络
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        // 当网络状态发生改变的时候调用这个block
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"WIFI");
                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"自带网络");
                break;
                
            case AFNetworkReachabilityStatusNotReachable:
            {
                NSLog(@"没有网络");
                
                UIAlertView *alertNetSearch = [[UIAlertView alloc]initWithTitle:nil message:@"请检查网络设置！" delegate:self cancelButtonTitle:@"確定" otherButtonTitles:nil, nil];
                [alertNetSearch show];
                
                //      [ProgressHUD dismiss];
                //      [ProgressHUD showError:@"请检查网络设置！"];
            }
                
                break;
                
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"未知网络");
                break;
            default:
                break;
        }
    }];
    // 开始监控
    [mgr startMonitoring];
}


+ (void)stopSearch{
    [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
}


@end
