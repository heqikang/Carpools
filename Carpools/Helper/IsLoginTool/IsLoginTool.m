//
//  IsLoginTool.m
//  Carpools
//
//  Created by ZhengBob on 24/4/2017.
//  Copyright © 2017 Esquel. All rights reserved.
//

#import "IsLoginTool.h"

@implementation IsLoginTool

+ (id)isLogin
{
    NSDictionary *dict = [NSDictionary dictionary];
    id obj = [[NSUserDefaults standardUserDefaults] objectForKey:@"loginData"];
    if ([obj isKindOfClass:[NSDictionary class]]) {
        dict = obj;
        return obj;
    }else{
        return nil;
    }
}
@end
