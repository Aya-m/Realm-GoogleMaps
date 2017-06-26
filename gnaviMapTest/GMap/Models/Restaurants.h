//
//  Restaurants.h
//  GMap
//
//  Created by Aya-m on 2016/06/20.
//  Copyright © 2016年 Aya-m. All rights reserved.
//

#import <Realm/Realm.h>

@interface Restaurants : RLMObject

@property NSString *name;
@property NSString *address;
@property NSString *latitude;
@property NSString *longitude;
@property NSString *image_url;
@property NSString *category;
@property NSString *tel;
//@property BOOL *isWifi;

+ (void)deleteAllRestaurants;
+ (void)writeRestaurants:(NSMutableArray *)restaurantsDataMarray;
+ (NSMutableArray *)readAllRestaurants;
+ (void)readRestaurants;

@end
RLM_ARRAY_TYPE(Restaurants)
