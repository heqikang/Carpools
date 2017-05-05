//
//  DriverTripCell.m
//  Carpool
//
//  Created by ZhengBob on 30/11/2016.
//  Copyright © 2016 Client. All rights reserved.
//

#import "DriverTripCell.h"

@implementation DriverTripCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(TripModel *)model
{
    if (_model != model) {
        _model = model;
        
        self.passengerNameLabel.text = [NSString stringWithFormat:@"%@", model.passenger_name];
        self.startPlaceLabel.text = model.from_address_name;
        self.endPlaceLabel.text = model.to_address_name;
        
        self.timeLabel.text = [self formatTime:model.time];
        self.dateLabel.text = [self formatDate:model.time];
        self.foregroundView.layer.cornerRadius = 5.0f;
        self.foregroundView.layer.masksToBounds = YES;
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

- (NSString *)getaddressnamewith:(NSInteger)addressid{
    NSArray *arr = [[NSUserDefaults standardUserDefaults] arrayForKey:@"Alladdress"];
    if (arr) {
        NSDictionary *addressdic = [NSDictionary dictionary];
        for (NSInteger i = 0; i < arr.count; i++) {
            addressdic = arr[i];
            if ([addressdic[@"addressid"] integerValue] == addressid) {
                return addressdic[@"addressname"];
            }
        }
    }else{
        NSLog(@"no networking");
    }
    return @"";
}

- (IBAction)driverTripCellBtnAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(didClickDriverTripCellBtn:)]) {
        [self.delegate didClickDriverTripCellBtn:sender];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
