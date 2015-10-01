//
//  SecondViewController.h
//  sampleapplication0929
//
//  Created by 脇田竜馬 on 2015/09/29.
//  Copyright (c) 2015年 Ryoma Wakita. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SecondViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *btnTitle;

@property (weak, nonatomic) IBOutlet UITableView *indexTableView;

@end


//tableview配置
//tableviewcellを置く
//Identifierというプロパティに「 Cell」と入力 idをつけるイメージ
//tableviewをhファイルに接続

//プロトコルを実装
//<UITableViewDelegate, UITableViewDataSource>
//上記をいれることによって、Tableのメソッドを記入可能になる