//
//  DriverTripCell.h
//  Carpool
//
//  Created by ZhengBob on 30/11/2016.
//  Copyright © 2016 Client. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TripModel.h"

@protocol DriverTripCellDelegate <NSObject>

@optional

- (void)didClickDriverTripCellBtn:(UIButton *)button;

@end

@interface DriverTripCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *foregroundView;
@property (weak, nonatomic) IBOutlet UILabel *passengerNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *startPlaceLabel;
@property (weak, nonatomic) IBOutlet UILabel *endPlaceLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (nonatomic, copy) TripModel *model;
@property (nonatomic, weak) id<DriverTripCellDelegate>delegate;

@property (weak, nonatomic) IBOutlet UIButton *chatBtn;
@property (weak, nonatomic) IBOutlet UIButton *phoneBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *finishBtn;

@end
