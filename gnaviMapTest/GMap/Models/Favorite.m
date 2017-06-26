//
//  Favorite.m
//  GMap
//
//  Created by Aya-m on 2016/06/28.
//  Copyright © 2016年 Aya-m. All rights reserved.
//

#import "Favorite.h"
#import "Config.h"

@implementation Favorite

+ (void)writeRestaurants:(NSMutableDictionary *)restaurantsDataMarray {
    if(YES == [restaurantsDataMarray isKindOfClass:[NSMutableArray class]]) {
        // item がNSArryの場合
        NSLog(@"NSArry");
    } else {
        // item がNSDictionaryの場合
        NSLog(@"NSDictionary");
    }
    // デフォルトのRealmを取得
    RLMRealm *realm = [RLMRealm defaultRealm];
    Favorite *favorite = [[Favorite alloc] init];
    // トランザクションを開始し書き込む
//    [realm beginWriteTransaction];
    [realm transactionWithBlock:^{
    favorite.name = restaurantsDataMarray[@"name"];
    favorite.address = restaurantsDataMarray[@"address"];
    favorite.latitude = restaurantsDataMarray[@"latitude"];
    favorite.longitude = restaurantsDataMarray[@"longitude"];
    favorite.image_url = restaurantsDataMarray[@"image_url"];
    favorite.category = restaurantsDataMarray[@"category"];
    favorite.tel = restaurantsDataMarray[@"tel"];
    [realm addObject:favorite];
    }];
//    [realm commitWriteTransaction];
    [self readAllRestaurants];
}

+ (void)readRestaurants {
    RLMResults<Favorite *> *favorite = [Favorite allObjects];
    NSLog(@"%@" ,favorite);
}

+ (NSMutableArray *)readAllRestaurants {
    RLMResults *allRestaurants = [Favorite allObjects];
    NSMutableArray *marr = [NSMutableArray array];
    for (Favorite *favorite in allRestaurants) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic[kRestaurantsName]      =  [NSString stringWithFormat:@"%@",favorite.name];
        dic[kRestaurantsAddress]   =  [NSString stringWithFormat:@"%@",favorite.address];
        dic[kRestaurantsLatitude]  =  [NSString stringWithFormat:@"%@",favorite.latitude];
        dic[kRestaurantsLongitude] =  [NSString stringWithFormat:@"%@",favorite.longitude];
        dic[kRestaurantsImage_url] =  [NSString stringWithFormat:@"%@",favorite.image_url];
        dic[kRestaurantsCategory]  =  [NSString stringWithFormat:@"%@",favorite.category];
        dic[kRestaurantsTel]       =  [NSString stringWithFormat:@"電話; %@",favorite.tel];
        [marr addObject:dic];
    }
    NSLog(@"favorite all : %@" ,marr);
    return marr;
}

@end
