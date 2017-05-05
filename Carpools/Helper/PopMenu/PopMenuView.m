//
//  PopMenuView.m
//  Carpools
//
//  Created by ZhengBob on 24/4/2017.
//  Copyright © 2017 Esquel. All rights reserved.
//

#import "PopMenuView.h"

@interface PopMenuView ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *listArray;

@end


static int rowCount = 2;
@implementation PopMenuView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.PopTableView.delegate = self;
    self.PopTableView.dataSource = self;
    self.PopTableView.scrollEnabled = NO;
    self.layer.borderWidth = 0.5f;
    self.layer.cornerRadius = 5.f;
    self.layer.masksToBounds = YES;
    self.listArray = [NSArray arrayWithObjects:@"我要约车", @"发布空座位", nil];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return rowCount;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = self.listArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(didClickTableViewCell:)]) {
        [self.delegate didClickTableViewCell:indexPath];
    }
}

@end
