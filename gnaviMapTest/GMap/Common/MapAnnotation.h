//
//  MapAnnotation.h
//  GMap
//
//  Created by Aya-m on 2016/06/22.
//  Copyright © 2016年 Aya-m. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface MapAnnotation : NSObject <MKAnnotation>

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

- (id)initWithCoordinates:(CLLocationCoordinate2D)_coordinate title:(NSString *)_title subtitle:(NSString *)_subtitle;

@end
