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
    MKMapView *_mapView;
}

@end

@implementation ThirdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //MapViewオブジェクトを生成
    _mapView = [[MKMapView alloc] init];
    
    //デリゲートを設定
    _mapView.delegate = self;
    
    //大きさ、位置を決定
    _mapView.frame = CGRectMake(0, 0, 0, 0);
    
    //表示位置を設定
    CLLocationCoordinate2D co;
    
    //アヤラの位置を設定
    co.latitude = 10.317347; //緯度
    co.longitude = 123.905759;  //経度
    
    [_mapView setCenterCoordinate:co];
    
    //縮尺を指定
    MKCoordinateRegion cr = _mapView.region;
    
    //地図の範囲を指定（緯度）
    cr.span.latitudeDelta = 0.02;
    
    //地図の範囲を指定（経度)
    cr.span.longitudeDelta = 0.02;
    
    cr.center = co;
    
    [_mapView setRegion:cr];
    
    //地図の表示種類設定
    _mapView.mapType = MKMapTypeStandard;
    
    
    //現在位置を表示する
    //_mapView.showsUserLocation = YES;
    
    
    //表示するためにViewに追加
    [self.view addSubview:_mapView];

    
    
    _appDelegate = [[UIApplication sharedApplication] delegate];
    
    self.myTextView.text = _appDelegate.infoText;
    
    self.title = _appDelegate.infoTitle;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
