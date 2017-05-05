
#import <Foundation/Foundation.h>
@class UploadParam;

typedef NS_ENUM(NSInteger,HttpRequestType)
{
    //get请求
    HttpRequestTypeGet,
    //post请求
    HttpRequestTypePost
};

@interface HttpRequest : NSObject

/*  发送get请求
 *
 *  URLString  请求的网址字符串
 *  parameters 请求的參数
 *  success    请求成功的回调
 *  failure    请求失败的回调
 */
+(void)requestGetWithURLString:(NSString *)URLString
                    parameters:(id)parameters
                       success:(void(^)(id responseObject))success
                       failure:(void(^)(NSError *error))failure;


/*  发送post请求
 *
 *  URLString  请求的网址字符串
 *  parameters 请求的參数
 *  success    请求成功的回调
 *  failure    请求失败的回调
 */
+(void)requestPostWithURLString:(NSString *)URLString
                     parameters:(id)parameters
                        success:(void(^)(id responseObject))success
                        failure:(void(^)(NSError *error))failure;


/*  发送网络请求
 *
 *  URLString  请求的网址字符串
 *  parameters 请求的參数
 *  type       请求的类型
 *  success    请求成功的回调
 *  failure    请求失败的回调
 */
+(void)requestWithURLString:(NSString *)URLString
                 parameters:(id)parameters
                       type:(HttpRequestType)type
                    success:(void(^)(id responseObject))success
                    failure:(void(^)(NSError *error))failure;


@end
