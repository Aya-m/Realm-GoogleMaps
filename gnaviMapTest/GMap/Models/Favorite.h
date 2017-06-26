//
//  Favorite.h
//  GMap
//
//  Created by Aya-m on 2016/06/28.
//  Copyright © 2016年 Aya-m. All rights reserved.
//

#import <Realm/Realm.h>

@interface Favorite : RLMObject

@property NSString *name;
@property NSString *address;
@property NSString *latitude;
@property NSString *longitude;
@property NSString *image_url;
@property NSString *category;
@property NSString *tel;

+ (void)writeRestaurants:(NSMutableDictionary *)restaurantsDataMarray;

+ (NSMutableArray *)readAllRestaurants;

@end
