//
//  MapAnnotation.m
//  GMap
//
//  Created by Aya-m on 2016/06/22.
//  Copyright © 2016年 Aya-m. All rights reserved.
//

#import "MapAnnotation.h"

@implementation MapAnnotation

@synthesize coordinate;
@synthesize title;
@synthesize subtitle;

- (id)initWithCoordinates:(CLLocationCoordinate2D)_coordinate title:(NSString *)_title subtitle:(NSString *)_subtitle
{
    self = [super self];
    if(self != nil){
        coordinate = _coordinate;
        title = _title;
        subtitle = _subtitle;
    }
    return self;
}

@end
