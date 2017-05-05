//
//  TakeCarCell.h
//  Carpool
//
//  Created by ZhengBob on 28/11/2016.
//  Copyright © 2016 Client. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TakeCarModel.h"

@interface TakeCarCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *foregroundView;


@property (weak, nonatomic) IBOutlet UIView *leftView;

@property (weak, nonatomic) IBOutlet UILabel *passengerNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *passengerDepartmentLabel;
@property (weak, nonatomic) IBOutlet UILabel *startPlaceLabel;

@property (weak, nonatomic) IBOutlet UILabel *endPlaceLabel;
@property (weak, nonatomic) IBOutlet UILabel *startDateLabel;

@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;

@property (weak, nonatomic) IBOutlet UIButton *accectBtnClick;

@property (nonatomic, copy) TakeCarModel *model;

@end
