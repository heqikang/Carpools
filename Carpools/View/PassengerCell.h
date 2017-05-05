//
//  PassengerCell.h
//  Carpool
//
//  Created by ZhengBob on 5/12/2016.
//  Copyright © 2016 Client. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TripModel.h"

@protocol PassengerCellDelegate <NSObject>

@optional

- (void)didClickPassengerCellButton:(UIButton *)button;

@end

@interface PassengerCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *foregroundView;

@property (weak, nonatomic) IBOutlet UILabel *passengerLabel;


@property (weak, nonatomic) IBOutlet UILabel *startPlaceLabel;

@property (weak, nonatomic) IBOutlet UILabel *endPlaceLabel;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;


@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (nonatomic, strong) NSNumber *infoid;

@property (nonatomic, strong) NSString *status;

@property (nonatomic, copy) TripModel *model;

@property (nonatomic, weak) id<PassengerCellDelegate>delegate;

@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

@end
