//
//  PassengerTripCell.h
//  Carpool
//
//  Created by ZhengBob on 6/12/2016.
//  Copyright © 2016 Client. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TripModel.h"

@protocol PassengerTripCellDelegate <NSObject>

@optional

- (void)didClickPassengerTripCellButton:(UIButton *)button;

@end

@interface PassengerTripCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *foregroundView;

@property (weak, nonatomic) IBOutlet UILabel *carownerNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *carownerDepartmentLabel;

@property (weak, nonatomic) IBOutlet UILabel *carownerCarNumberLabel;
@property (weak, nonatomic) IBOutlet UIButton *startPlaceBtn;
@property (weak, nonatomic) IBOutlet UIButton *endPlaceBtn;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (nonatomic, copy) TripModel *model;
@property (weak, nonatomic) IBOutlet UIButton *editStartPlaceBtn;

@property (weak, nonatomic) IBOutlet UIButton *editEndPlaceBtn;

@property (nonatomic, strong) NSNumber *infoid;

@property (nonatomic, strong) NSString *status;

@property (nonatomic, weak) id<PassengerTripCellDelegate>delegate;

@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *phoneBtn;
@property (weak, nonatomic) IBOutlet UIButton *finishBtn;


@end
