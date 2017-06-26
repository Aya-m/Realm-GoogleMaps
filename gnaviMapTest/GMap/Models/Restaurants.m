//
//  Restaurants.m
//  GMap
//
//  Created by Aya-m on 2016/06/20.
//  Copyright © 2016年 Aya-m. All rights reserved.
//

#import "Restaurants.h"
#import "Config.h"

@interface Restaurants() {

}

@end

@implementation Restaurants

+ (NSString *)primaryKey {
    return @"tel";
}

+ (void)deleteAllRestaurants {
    // デフォルトのRealmを取得
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    [realm deleteAllObjects];
    [realm commitWriteTransaction];
}

+ (void)writeRestaurants:(NSMutableArray *)restaurantsDataMarray {
    
    
        @autoreleasepool {
            // ディクショナリからオブジェクトを作成する場合は、プロパティの順序を気にする必要はありません
            for (int restaurantsNumber = 0; restaurantsNumber < [restaurantsDataMarray count]; restaurantsNumber++) {
                Restaurants *restaurants = [[Restaurants alloc] init];
                restaurants.name = restaurantsDataMarray[restaurantsNumber][0];
                restaurants.address = restaurantsDataMarray[restaurantsNumber][1];
                restaurants.latitude = restaurantsDataMarray[restaurantsNumber][2];
                restaurants.longitude = restaurantsDataMarray[restaurantsNumber][3];
                restaurants.image_url = restaurantsDataMarray[restaurantsNumber][4];
                restaurants.category = restaurantsDataMarray[restaurantsNumber][5];
                restaurants.tel = restaurantsDataMarray[restaurantsNumber][6];
                
                // デフォルトのRealmを取得
                RLMRealm *realm = [RLMRealm defaultRealm];
                // トランザクションを開始し書き込む
                [realm beginWriteTransaction];
                [realm addObject:restaurants];
                [realm commitWriteTransaction];
            }
        }
}

+ (void)readRestaurants {

    NSPredicate *prepared = [NSPredicate predicateWithFormat:@"tel = %@", @"06-6150-1075"];
    RLMResults *results = [Restaurants objectsWithPredicate:prepared];
    RLMRealm *realm = [RLMRealm defaultRealm];
    results = [Restaurants objectsInRealm:realm withPredicate:prepared];
    NSLog(@"results %@" ,results);
}

+ (NSMutableArray *)readAllRestaurants {
    RLMResults *allRestaurants = [Restaurants allObjects];
    NSMutableArray *marr = [NSMutableArray array];
    for (Restaurants *restaurants in allRestaurants) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic[kRestaurantsName]      =  [NSString stringWithFormat:@"%@",restaurants.name];
        dic[kRestaurantsAddress]   =  [NSString stringWithFormat:@"%@",restaurants.address];
        dic[kRestaurantsLatitude]  =  [NSString stringWithFormat:@"%@",restaurants.latitude];
        dic[kRestaurantsLongitude] =  [NSString stringWithFormat:@"%@",restaurants.longitude];
        dic[kRestaurantsImage_url] =  [NSString stringWithFormat:@"%@",restaurants.image_url];
        dic[kRestaurantsCategory]  =  [NSString stringWithFormat:@"%@",restaurants.category];
        dic[kRestaurantsTel]       =  [NSString stringWithFormat:@"電話; %@",restaurants.tel];
        [marr addObject:dic];
    }
    return marr;
}

@end
