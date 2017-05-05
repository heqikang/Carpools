//
//  DriverLovewallCell.m
//  Carpool
//
//  Created by ZhengBob on 10/4/2017.
//  Copyright © 2017 Esquel. All rights reserved.
//

#import "DriverLovewallCell.h"

@implementation DriverLovewallCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(TripModel *)model
{
    
    if (_model != model) {
        _model = model;
        
        self.lovername.text = model.driver_name;
        self.loverdepartment.text = model.driver_department;
        self.startPlaceLabel.text = model.from_address_name;
        self.endPlaceLabel.text = model.to_address_name;
        self.freeSeatLabel.text = [NSString stringWithFormat:@"%d",([model.seat_count intValue] - [model.hitchhiked_count intValue])];
        self.timeLabel.text = [self formatTime:model.time];
        self.dataLabel.text = [self formatDate:model.time];
        
        self.lovewallID = model.love_wall_ID;
        self.carNumber = model.driver_carnumber;
        self.phone = model.driver_phone;
        self.loverid = model.driver_id;
        self.startpid = model.startpid;
        self.endpid = model.endpid;
        self.status = model.status;
        
        self.from_latitude = model.from_latitude;
        self.from_longtitude = model.from_longtitude;
        self.to_latitude = model.to_latitude;
        self.to_longtitude = model.to_longtitude;
        self.backgroundColor = [UIColor clearColor];
        
        
        [self.popularBtn setTitle:[NSString stringWithFormat:@"%@", model.liked_count] forState:UIControlStateNormal];
        [self.popularBtn bringSubviewToFront:self.contentView];
        self.takeCarLabel.text = [NSString stringWithFormat:@"%d", [model.hitchhiked_count intValue]];
    }
}

-(NSString *)formatTime:(NSString *)Inputtime{
    NSString *thetime = [Inputtime substringFromIndex:4];
    //    NSString *themonth = [thetime substringToIndex:2];
    //    NSString *theday = [[thetime substringToIndex:4] substringFromIndex:2];
    NSString *thehour = [[thetime substringFromIndex:4] substringToIndex:2];
    NSString *themin = [[thetime substringFromIndex:4] substringFromIndex:2];
    //    NSString *formatthetime = [NSString stringWithFormat:@"%@/%@/%@:%@",themonth,theday,thehour,themin];
    NSString *formatthetime = [NSString stringWithFormat:@"%@:%@",thehour,themin];
    return formatthetime;
}

- (NSString *)formatDate:(NSString *)inputTime{
    
    NSString *thetime = [inputTime substringFromIndex:4];
    NSString *themonth = [thetime substringToIndex:2];
    NSString *theday = [[thetime substringToIndex:4] substringFromIndex:2];
    NSString *formatthedate = [NSString stringWithFormat:@"%@月%@日",themonth, theday];
    
    return formatthedate;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
