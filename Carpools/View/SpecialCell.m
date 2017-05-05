//
//  SpecialCell.m
//  Carpool
//
//  Created by ZhengBob on 6/3/2017.
//  Copyright © 2017 Esquel. All rights reserved.
//

#import "SpecialCell.h"

@implementation SpecialCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(UserModel *)model
{
    if (_model != model) {
        _model = model;
        self.userNameLabel.text = model.name;
        self.userImageBtn.layer.cornerRadius = 20.f;
        self.userImageBtn.layer.masksToBounds = YES;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
