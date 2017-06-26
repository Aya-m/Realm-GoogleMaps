//
//  RestrantsMapViewController.h
//  GMap
//
//  Created by Aya-m on 2016/06/21.
//  Copyright © 2016年 Aya-m. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RestrantsMapViewController : UIViewController 
@property (nonatomic, weak) NSString *restaurantName;
@property (nonatomic, weak) NSString *restaurantAddress;
@property (nonatomic) double restaurantLatitude;
@property (nonatomic) double restaurantLongitude;
@property (nonatomic, weak) NSString *restaurantCategory;
@property (nonatomic, weak) NSString *restaurantTel;
@property (nonatomic, weak) NSString *restaurantImage_url;

@end
