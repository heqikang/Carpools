//
//  PassengerCell.m
//  Carpool
//
//  Created by ZhengBob on 5/12/2016.
//  Copyright © 2016 Client. All rights reserved.
//

#import "PassengerCell.h"

@implementation PassengerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(TripModel *)model
{
    if (_model != model) {
        _model = model;
        self.startPlaceLabel.text = model.from_address_name;
        self.endPlaceLabel.text = model.to_address_name;
        
        self.timeLabel.text = [self formatTime:model.time];
        self.dateLabel.text = [self formatDate:model.time];
        self.passengerLabel.text = model.passenger_name;
        self.foregroundView.layer.cornerRadius = 8.0f;
        self.foregroundView.layer.masksToBounds = YES;
        self.infoid = model.infoid;
        self.status = model.status;
    }
}

-(NSString *)formatTime:(NSString *)Inputtime{
    NSString *thetime = [Inputtime substringFromIndex:4];
    //    NSString *themonth = [thetime substringToIndex:2];
    //    NSString *theday = [[thetime substringToIndex:4] substringFromIndex:2];
    NSString *thehour = [[thetime substringFromIndex:4] substringToIndex:2];
    NSString *themin = [[thetime substringFromIndex:4] substringFromIndex:2];
    NSString *formatthetime = [NSString stringWithFormat:@"%@:%@", thehour,themin];
    return formatthetime;
}

- (NSString *)formatDate:(NSString *)inputTime{
    
    NSString *thetime = [inputTime substringFromIndex:4];
    NSString *themonth = [thetime substringToIndex:2];
    NSString *theday = [[thetime substringToIndex:4] substringFromIndex:2];
    NSString *formatthedate = [NSString stringWithFormat:@"%@月%@日",themonth, theday];
    
    return formatthedate;
}

- (IBAction)passengerCellBtnAction:(UIButton *)sender {
    if ([self.cancelDelegate respondsToSelector:@selector(didClickPassengerCellButton:)]) {
        [self.cancelDelegate didClickPassengerCellButton:sender];
    }
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
