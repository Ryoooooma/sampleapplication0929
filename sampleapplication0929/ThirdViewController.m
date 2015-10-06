//
//  ThirdViewController.m
//  sampleapplication0929
//
//  Created by 脇田竜馬 on 2015/09/29.
//  Copyright (c) 2015年 Ryoma Wakita. All rights reserved.
//

#import "ThirdViewController.h"
#import "AppDelegate.h"

@interface ThirdViewController (){
    AppDelegate *_appDelegate;
}

@end

@implementation ThirdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //表示位置を設定
    CLLocationCoordinate2D fromLocation = CLLocationCoordinate2DMake(10.317347, 123.905759);
    
    [self.myMapView setCenterCoordinate:fromLocation];
    
    //縮尺を指定
    MKCoordinateRegion cr = self.myMapView.region;
    
    //地図の範囲を指定（緯度）
    cr.span.latitudeDelta = 0.02;
    
    //地図の範囲を指定（経度)
    cr.span.longitudeDelta = 0.02;
    
    cr.center = fromLocation;
    
    [self.myMapView setRegion:cr];
    
    //地図の表示種類設定
    self.myMapView.mapType = MKMapTypeStandard;
    
    
    //ピンを立てる
    //アヤラ
    MKPointAnnotation *pin =[[MKPointAnnotation alloc] init];
    pin.coordinate = CLLocationCoordinate2DMake(10.317347, 123.905759);
    
    pin.title = @"Ayala";
    pin.subtitle = @"セブで一番大きい";
    
    [self.myMapView addAnnotation:pin];

    
    _appDelegate = [[UIApplication sharedApplication] delegate];
    
    self.myTextView.text = _appDelegate.infoText;
    self.title = _appDelegate.infoTitle;
    
    // = _appDelegate.infoLocation;
 
    MKPointAnnotation *pin_2 =[[MKPointAnnotation alloc] init];
    pin_2.coordinate = CLLocationCoordinate2DMake(_appDelegate.infoLati, _appDelegate.infoLongi);
    
    pin_2.title = _appDelegate.infoTitle;
    
    [self.myMapView addAnnotation:pin_2];

    
    // ここから実装している10/05
    CLLocationCoordinate2D toLocation = CLLocationCoordinate2DMake(_appDelegate.infoLati, _appDelegate.infoLongi);

    // CLLocationCoordinate2D から MKPlacemark を生成
    MKPlacemark *fromPlacemark = [[MKPlacemark alloc] initWithCoordinate:fromLocation
                                                       addressDictionary:nil];
    MKPlacemark *toPlacemark   = [[MKPlacemark alloc] initWithCoordinate:toLocation
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
             NSLog(@"アヤラからの距離は: %.f mです", route.distance);
               self.myDistanceLabel.text =[NSString stringWithFormat:@"%.f",route.distance];
             // 地図上にルートを描画
             [self.myMapView addOverlay:route.polyline];
         }
     }];
    
    //表示するためにViewに追加
    [self.view addSubview:self.myMapView];
    
}


// 地図上に描画するルートの色などを指定(これを実装しないと何も表示されない)
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

@end
