//
//  HWItemCell.h
//  TryApp
//
//  Created by hqman on 15/5/13.
//  Copyright (c) 2015年 tiziapp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HWItemCell : UITableViewCell
 
@property (weak, nonatomic) IBOutlet UIImageView *thumbView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *snLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;

@end
