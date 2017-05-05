//
//  TakeCarCell.m
//  Carpool
//
//  Created by ZhengBob on 28/11/2016.
//  Copyright © 2016 Client. All rights reserved.
//

#import "TakeCarCell.h"

@implementation TakeCarCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(TakeCarModel *)model
{
    if (_model != model) {
        _model = model;
        self.foregroundView.layer.cornerRadius = 5;
        self.foregroundView.layer.masksToBounds = YES;
        
        self.passengerNameLabel.text = model.name;
        self.passengerDepartmentLabel.text = [NSString stringWithFormat:@"%@",  model.department];
        self.startPlaceLabel.text = model.from_address_name;
        self.endPlaceLabel.text = model.to_address_name;
        
        self.startTimeLabel.text = [self formatTime:model.time];
        self.startDateLabel.text = [self formatDate:model.time];
        
        self.backgroundColor = [UIColor clearColor];
        
//        self.textLabel.font = [UIFont fontWithName:@"System" size:18];
//        self.selectionStyle = UITableViewCellSelectionStyleDefault;
//        self.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
//        self.textLabel.numberOfLines = 6;
        
//        self.backView.layer.borderWidth = 1.0f;
//        self.backView.layer.borderColor = [UIColor lightGrayColor].CGColor;
//        self.backView.layer.cornerRadius = 8.0f;
//        self.backView.layer.masksToBounds = YES;
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

- (IBAction)accectBtnClick:(id)sender
{
    [self.accectBtnClick setImage:[UIImage imageNamed:@"squareSelect"] forState:UIControlStateNormal];
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
