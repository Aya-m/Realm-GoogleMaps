//
//  RestaurantsListTableViewCell.h
//  GMap
//
//  Created by Aya-m on 2016/06/21.
//  Copyright © 2016年 Aya-m. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RestaurantsListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *telLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UIImageView *restaurantsImage;

@end
