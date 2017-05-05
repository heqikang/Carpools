#import "HttpRequest.h"
#import "AFNetworking.h"

@implementation HttpRequest

#pragma mark - GET请求
+(void)requestGetWithURLString:(NSString *)URLString
                    parameters:(id)parameters
                       success:(void (^)(id))success
                       failure:(void (^)(NSError *))failure
{
    /*
     *   初始化会话管理
     */
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    /*
     *   网络响应的类型
     */
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    /*
     *   请求队列的最大并发数
     */
//    manger.operationQueue.maxConcurrentOperationCount = 5;
    /*
     *   请求超时的时间
     */
//    manger.requestSerializer.timeoutInterval = 5;
    
    
    /*   get请求
     *   
     *  progress  网络请求进度
     */
    [manger GET:URLString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}



#pragma mark - POST请求
+(void)requestPostWithURLString:(NSString *)URLString
                     parameters:(id)parameters
                        success:(void (^)(id))success
                        failure:(void (^)(NSError *))failure
{
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    //最大并发队列
//    manger.operationQueue.maxConcurrentOperationCount = 5;
    
    //请求超时
//    manger.requestSerializer.timeoutInterval = 5;
    
    [manger POST:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}


#pragma mark - GET/POST请求
+(void)requestWithURLString:(NSString *)URLString
                 parameters:(id)parameters
                       type:(HttpRequestType)type
                    success:(void (^)(id))success
                    failure:(void (^)(NSError *))failure
{
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    //请求超时
    manger.requestSerializer.timeoutInterval = 30;
    
    switch (type) {
            //GET请求
        case HttpRequestTypeGet:
        {
            [manger GET:URLString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (success) {
                    success(responseObject);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (failure) {
                    failure(error);
                }
            }];
        }
            break;
            
            //POST请求
        case HttpRequestTypePost:
        {
            [manger POST:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (success) {
                    success(responseObject);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (failure) {
                    failure(error);
                }
            }];
        }
            break;
    }
}



@end
