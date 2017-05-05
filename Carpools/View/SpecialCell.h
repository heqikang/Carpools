//
//  SpecialCell.h
//  Carpool
//
//  Created by ZhengBob on 6/3/2017.
//  Copyright © 2017 Esquel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserModel.h"

@interface SpecialCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *userImageBtn;

@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *DetailBtn;

@property (nonatomic, copy) UserModel *model;

@end
