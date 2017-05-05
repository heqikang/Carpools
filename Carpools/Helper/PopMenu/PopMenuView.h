//
//  PopMenuView.h
//  Carpools
//
//  Created by ZhengBob on 24/4/2017.
//  Copyright © 2017 Esquel. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PopMenuViewDelegate <NSObject>

@optional

- (void)didClickTableViewCell:(NSIndexPath *)indexPath;

@end

@interface PopMenuView : UIView

@property (weak, nonatomic) IBOutlet UITableView *PopTableView;

@property (nonatomic, weak) id<PopMenuViewDelegate>delegate;


@end
