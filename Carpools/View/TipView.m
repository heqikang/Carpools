//
//  TipView.m
//  Carpool
//
//  Created by ZhengBob on 16/3/2017.
//  Copyright © 2017 Esquel. All rights reserved.
//

#import "TipView.h"

@implementation TipView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 10, self.frame.size.width - 32, 24)];
        self.tipImageView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 40, 24, 24)];
        self.tipTextField = [[UITextField alloc] initWithFrame:CGRectMake(40, 36, self.frame.size.width - 48, 30)];
        self.tipTextField.textAlignment = NSTextAlignmentCenter;
        self.lineView = [[UIView alloc] initWithFrame:CGRectMake(40, 66, self.frame.size.width - 48, 1)];
        self.lineView.backgroundColor = [UIColor lightGrayColor];
        self.sureBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        self.sureBtn.frame = CGRectMake(self.frame.size.width - 60, 80, 60, 30);
        
        self.cancelBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        self.cancelBtn.frame = CGRectMake(self.frame.size.width - 140, 80, 60, 30);
        [self addSubview:self.tipLabel];
        [self addSubview:self.tipImageView];
        [self addSubview:self.tipTextField];
        [self addSubview:self.lineView];
        [self addSubview:self.cancelBtn];
        [self addSubview:self.sureBtn];
    }
    return self;
}

@end
