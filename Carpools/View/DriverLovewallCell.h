//
//  DriverLovewallCell.h
//  Carpool
//
//  Created by ZhengBob on 10/4/2017.
//  Copyright © 2017 Esquel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TripModel.h"

@interface DriverLovewallCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lovername;
@property (weak, nonatomic) IBOutlet UILabel *loverdepartment;
@property (weak, nonatomic) IBOutlet UILabel *dataLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *startPlaceLabel;

@property (weak, nonatomic) IBOutlet UILabel *endPlaceLabel;

@property (weak, nonatomic) IBOutlet UILabel *freeSeatLabel;
@property (weak, nonatomic) IBOutlet UILabel *takeCarLabel;
@property (weak, nonatomic) IBOutlet UIButton *popularBtn;

@property (weak, nonatomic) IBOutlet UILabel *popularLabel;


@property (nonatomic, strong) NSNumber *lovewallID;

@property (nonatomic, strong) NSString *carNumber;

@property (nonatomic, strong) NSString *phone;

@property (nonatomic, strong) NSString *loverid;

@property (nonatomic, strong) NSNumber *carownid;

@property (nonatomic, strong) NSNumber *startpid;

@property (nonatomic, strong) NSNumber *endpid;

@property (nonatomic, copy) TripModel *model;

@property (nonatomic, strong) NSString *status;

@property (nonatomic, strong) NSString *from_latitude;

@property (nonatomic, strong) NSString *from_longtitude;

@property (nonatomic, strong) NSString *to_latitude;

@property (nonatomic, strong) NSString *to_longtitude;

@end
