//
//  WallCell.m
//  Carpool
//
//  Created by ZhengBob on 12/1/2017.
//  Copyright © 2017 Client. All rights reserved.
//

#import "LovewallCell.h"

@implementation LovewallCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(LovewallModel *)model
{
    
    if (_model != model) {
        _model = model;
        
        self.lovername.text = model.lover_name;
        self.loverdepartment.text = model.department;
        self.startPlaceLabel.text = model.from_address;
        self.endPlaceLabel.text = model.to_address;
        self.freeSeatLabel.text = [NSString stringWithFormat:@"%d",([model.seat_count intValue] - [model.hitchhiked_count intValue])];
        self.timeLabel.text = [self formatTime:model.time];
        self.dataLabel.text = [self formatDate:model.time];
        
        self.lovewallID = model.love_wall_ID;
        self.carNumber = model.carnumber;
        self.phone = model.phone;
        self.loverid = model.lover_id;
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

- (IBAction)popularBtnClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(didClickButtonAction:)]) {
        [self.delegate didClickButtonAction:sender];
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
