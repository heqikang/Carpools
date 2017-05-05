//
//  LoginView.h
//  Carpools
//
//  Created by ZhengBob on 24/4/2017.
//  Copyright © 2017 Esquel. All rights reserved.
//

#import <UIKit/UIKit.h>

// 设置代理
@protocol LoginViewDelegate <NSObject>

@optional

// 代理方法
- (void)didClickButtonAction:(UIButton *)button;

@end

@interface LoginView : UIView

@property (nonatomic, weak) id<LoginViewDelegate>delegate;

@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;

@property (weak, nonatomic) IBOutlet UITextField *userPswTextField;

@end
