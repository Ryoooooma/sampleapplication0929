//
//  ThirdViewController.h
//  sampleapplication0929
//
//  Created by 脇田竜馬 on 2015/09/29.
//  Copyright (c) 2015年 Ryoma Wakita. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface ThirdViewController : UIViewController<MKMapViewDelegate,CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UITextView *myTextView;
@property (weak, nonatomic) IBOutlet MKMapView *myMapView;
@property (nonatomic) CLLocationManager *locationManager;

@end
