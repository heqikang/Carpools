//
//  LoginView.m
//  Carpools
//
//  Created by ZhengBob on 24/4/2017.
//  Copyright © 2017 Esquel. All rights reserved.
//

#import "LoginView.h"

@implementation LoginView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)buttonAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(didClickButtonAction:)]) {
        [self.delegate didClickButtonAction:sender];
    }
    
}

@end
