//
//  AppDelegate.h
//  sampleapplication0929
//
//  Created by 脇田竜馬 on 2015/09/29.
//  Copyright (c) 2015年 Ryoma Wakita. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic) NSString *btnTitle;
@property (nonatomic) NSString *infoText;
@property (nonatomic) NSString *infoTitle;
@property (nonatomic) float endLati;
@property (nonatomic) float endLongi;
@end

