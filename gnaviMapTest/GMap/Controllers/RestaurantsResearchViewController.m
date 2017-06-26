#import "RestaurantsResearchViewController.h"
#import "Config.h"
#import "LoadingView.h"
#import <GoogleMaps/GoogleMaps.h>
#import <CoreLocation/CoreLocation.h>
#import <Realm/Realm.h>  
#import "Restaurants.h"

@import GoogleMaps;

@interface RestaurantsResearchViewController ()<NSURLSessionDelegate,GMSMapViewDelegate, CLLocationManagerDelegate>{
    // 範囲
    NSString *rangeSt;
    // ヒット件数
    NSString *pageSt;
    // 緯度
    float latitudeValue;
    // 経度
    float longitudeValue;
    
    BOOL isTapDistanceButton;
}

@property (nonatomic, retain) CLLocationManager *locationManager;

@end

@implementation RestaurantsResearchViewController

- (void)viewDidLoad {
    [super didReceiveMemoryWarning];
    isTapDistanceButton = NO;
}

// GPSで位置情報の取得時に呼ばれる
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    if (!isTapDistanceButton) return;
    CLLocation* location = [locations lastObject];
    NSLog(@"緯度 %f, 経度 %f", location.coordinate.latitude,
          location.coordinate.longitude);
    latitudeValue = location.coordinate.latitude;
    longitudeValue = location.coordinate.longitude;
    [self requestApi];
    
}

-(IBAction)shareYourLacationButton:(UISegmentedControl*)sender{
    isTapDistanceButton = YES;
    switch (sender.selectedSegmentIndex) {
        case 0:
            rangeSt = [NSString stringWithFormat:@"1"];
            pageSt  = [NSString stringWithFormat:@"300"];
            break;
            
        case 1:
            rangeSt = [NSString stringWithFormat:@"3"];
            pageSt  = [NSString stringWithFormat:@"500"];
            break;
    }
    
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
    // 位置情報を取得スタート
    [self.locationManager startUpdatingLocation];
}

-(void)requestApi {
    // floatを文字列に変換
    NSString *latitudeStr = [NSString stringWithFormat:@"%f", latitudeValue];
    NSString *longitudeStr = [NSString stringWithFormat:@"%f", longitudeValue];

    NSURLQueryItem *keyidItem = [NSURLQueryItem queryItemWithName:@"keyid" value: @"8ea94a772f9fd082f2ffbfec99040033"];
    NSURLQueryItem *formatItem = [NSURLQueryItem queryItemWithName:@"format" value: @"json"];
    NSURLQueryItem *latitudeItem = [NSURLQueryItem queryItemWithName:@"latitude" value: latitudeStr];
    NSURLQueryItem *longitudeItem = [NSURLQueryItem queryItemWithName:@"longitude" value: longitudeStr];
    NSURLQueryItem *rangeItem = [NSURLQueryItem queryItemWithName:@"range" value: rangeSt];
    NSURLQueryItem *hit_per_pageItem = [NSURLQueryItem queryItemWithName:@"hit_per_page" value: pageSt];
    NSURLComponents *components = [[NSURLComponents alloc] initWithString:kGurunaviCentersApiUrl];
    components.queryItems = @[keyidItem,formatItem,latitudeItem, longitudeItem,rangeItem,hit_per_pageItem];
    NSURL *url = [components URL];
    NSLog(@"%@" ,url);
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil  ];
    
    // Loading画面作成
    LoadingView *loadView = [[[NSBundle mainBundle] loadNibNamed:@"LoadingView" owner:nil options:0] firstObject];
    [loadView setLodingTitle:@"Wait a minute..."];
    loadView.center = self.view.center;
    [self.view addSubview:loadView];
    [loadView startIndicator];
    
    NSURLSessionDataTask *jsonData = [session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSMutableArray *restaurantsDataMarray = [[NSMutableArray alloc]init];
        if (!error) {
            NSHTTPURLResponse *httpResp = (NSHTTPURLResponse *) response;
            if (httpResp.statusCode == 200) {
                NSError *jsonError;
                
                NSDictionary *cor01 =(NSDictionary *)
                [NSJSONSerialization JSONObjectWithData:data
                                                options:NSJSONReadingMutableContainers
                                                  error:nil];
                // メモリー解放
                [session invalidateAndCancel];
                if (!jsonError) {
                    // JSON のオブジェクトは NSDictionary に変換されている
                    NSString *imagePath;
                    for (NSDictionary *obj in cor01[@"rest"]) {
                        imagePath = obj[@"image_url"][@"shop_image1"];
                        // imagepathがなければこちらで画像設定
                        if( [[imagePath class] isSubclassOfClass:[NSDictionary class]] ) {
                            imagePath = @"noImage.png";
                        }
                        [restaurantsDataMarray addObject:@[obj[@"name"],obj[@"address"],obj[@"latitude"],obj[@"longitude"],imagePath,obj[@"category"],obj[@"tel"]]];
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (!isTapDistanceButton) return;
                        isTapDistanceButton = NO;
                        [Restaurants deleteAllRestaurants];
                        [Restaurants writeRestaurants:restaurantsDataMarray];
                        [loadView stopIndicator];
                        [loadView removeFromSuperview];
                        [self performSegueWithIdentifier:@"toRestaurantsList" sender:self];                    
                    });
                }
            }
        }
    }];
    [jsonData resume];
}

@end
