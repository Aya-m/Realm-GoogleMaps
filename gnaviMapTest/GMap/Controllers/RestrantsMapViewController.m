//
//  RestrantsMapViewController.m
//  GMap
//
//  Created by Aya-m on 2016/06/21.
//  Copyright © 2016年 Aya-m. All rights reserved.
//

#import "RestrantsMapViewController.h"
#import "Config.h"
#import <MapKit/MapKit.h>
#import "MapAnnotation.h"

@interface RestrantsMapViewController () <CLLocationManagerDelegate,MKMapViewDelegate> {
    // 緯度
    float latitudeValue;
    // 経度
    float longitudeValue;
    
    BOOL isFirst;
}
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIImageView *restaurantImage;

@property (nonatomic, retain) CLLocationManager *locationManager;

@end

@implementation RestrantsMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _nameLabel.text = _restaurantName;
    _addressLabel.text = _restaurantAddress;
    NSLog(@"_restaurantAddress %@" ,_restaurantAddress);
    NSLog(@"tel: %@" ,_restaurantTel);
    _categoryLabel.text = _restaurantCategory;
    
    UIImage *image;
    if([_restaurantImage_url isEqualToString:@"noImage.png"]) {
        image = [UIImage imageNamed:@"noImage.png"];
    } else {
        NSURL *url = [NSURL URLWithString:_restaurantImage_url];
        NSData *myData = [NSData dataWithContentsOfURL:url];
        image = [[UIImage alloc] initWithData:myData];
    }
    _restaurantImage.image = image;
    
    self.mapView.delegate = self;
    // ユーザから位置情報の利用について承認
    if (nil == self.locationManager) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        // iOS 8以上
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
            // NSLocationWhenInUseUsageDescriptionに設定したメッセージでユーザに確認
            [ self.locationManager requestWhenInUseAuthorization];
            // NSLocationAlwaysUsageDescriptionに設定したメッセージでユーザに確認
            [self.locationManager requestWhenInUseAuthorization];
        }
    }
    isFirst = YES;
    // 位置情報を取得スタート
    [self.locationManager startUpdatingLocation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)callButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
//    NSString *telNumber = [NSString stringWithFormat:@"tel:%@",_restaurantTel];
//    // tel: で始まるURLを作成
//    NSURL *url = [NSURL URLWithString:telNumber];
//    // 作成したURLを、アプリケーションのopenURLメソッドで開く
//    [[UIApplication sharedApplication] openURL:url];
}

// GPSで位置情報の取得時に呼ばれる
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    if (!isFirst) return;
    isFirst = NO;
    CLLocation* location = [locations lastObject];
    latitudeValue = location.coordinate.latitude;
    longitudeValue = location.coordinate.longitude;
    // 地図の中心・表示範囲を設定
    CLLocationCoordinate2D centerCoordinate = CLLocationCoordinate2DMake(latitudeValue, longitudeValue);
    MKCoordinateSpan span = MKCoordinateSpanMake(0.01, 0.01);
    self.mapView.region = MKCoordinateRegionMake(centerCoordinate, span);
    [self showMapDirection];
}

-(void)showMapDirection {
    // From
    CLLocationCoordinate2D fromCoordinate = CLLocationCoordinate2DMake(latitudeValue ,longitudeValue);
    NSLog(@"From緯度 %f, From経度 %f", latitudeValue,longitudeValue);
    // To
    CLLocationCoordinate2D toCoordinate = CLLocationCoordinate2DMake(_restaurantLatitude ,_restaurantLongitude);
    NSLog(@"To緯度 %f, From経度 %f", _restaurantLatitude,_restaurantLongitude);
    
    // CLLocationCoordinate2D から MKPlacemark を生成
    MKPlacemark *fromPlacemark = [[MKPlacemark alloc] initWithCoordinate:fromCoordinate
                                                       addressDictionary:nil];
    MKPlacemark *toPlacemark   = [[MKPlacemark alloc] initWithCoordinate:toCoordinate
                                                       addressDictionary:nil];
    
    // MKPlacemark から MKMapItem を生成
    MKMapItem *fromItem = [[MKMapItem alloc] initWithPlacemark:fromPlacemark];
    MKMapItem *toItem   = [[MKMapItem alloc] initWithPlacemark:toPlacemark];
    
    // MKMapItem をセットして MKDirectionsRequest を生成
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    request.source = fromItem;
    request.destination = toItem;
    request.requestsAlternateRoutes = YES;
    
    // MKDirectionsRequest から MKDirections を生成
    MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
    
    // 経路検索を実行
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error)
     {
         if (error) return;
         
         if ([response.routes count] > 0)
         {
             MKRoute *route = [response.routes objectAtIndex:0];
             NSLog(@"distance: %.2f meter", route.distance);
             // 地図上にルートを描画
             [self.mapView addOverlay:route.polyline];
             MKPointAnnotation* pin = [[MKPointAnnotation alloc] init];
             pin.coordinate = toCoordinate;
             [self.mapView addAnnotation:pin];
             
//             NSString *distance = [NSString stringWithFormat:@"%.2f", route.distance];
//             NSString *titleYou = distance;
//             NSString *subtitleYou = @"To the destination";
//             MapAnnotation *annotationYou = [[MapAnnotation alloc] initWithCoordinates:toCoordinate title:titleYou subtitle:subtitleYou];
//             [self.mapView addAnnotation:annotationYou];
//             [self.mapView setCenterCoordinate:toCoordinate animated:YES];
         }
     }];
}

#pragma mark - MKMapViewDelegate
// 地図上に描画するルートの色などを指定（これを実装しないと何も表示されない）
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView
            rendererForOverlay:(id<MKOverlay>)overlay
{
    if ([overlay isKindOfClass:[MKPolyline class]])
    {
        MKPolyline *route = overlay;
        MKPolylineRenderer *routeRenderer = [[MKPolylineRenderer alloc] initWithPolyline:route];
        routeRenderer.lineWidth = 5.0;
        routeRenderer.strokeColor = [UIColor redColor];
        return routeRenderer;
    }
    else {
        return nil;
    }
}

@end
