//
//  ViewController.m
//  sampleapplication0929
//
//  Created by 脇田竜馬 on 2015/09/29.
//  Copyright (c) 2015年 Ryoma Wakita. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "SecondViewController.h"

@interface ViewController (){
    
    // _appdeligateというオブジェクトを生成している（appdeligateを使う準備）
    AppDelegate *_appDeligate;
    
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //  初期化
    _appDeligate = [[UIApplication sharedApplication] delegate];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)goBeach:(id)sender {
//    NSLog(@"ビーチが押されたよ");

    UIButton *Btn = (UIButton *)sender;
    // キャストする。。。クリックされた情報がsenderに入っていて、それを変数Btnに突っ込んでいる
    
//    NSLog(@"Btnのタイトル %@", Btn.currentTitle);
    
    _appDeligate.btnTitle = Btn.currentTitle;
    //appdeligateした時は値が代入されているかを必ず確認する
    NSLog(@"アップテリゲートのタイトル %@", _appDeligate.btnTitle);
    
    SecondViewController *SVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SecondViewController"];

    // プッシュで遷移（横からシュっ）
    [self.navigationController pushViewController:SVC animated:YES];

    
}

- (IBAction)gorestaurant:(id)sender {
//    NSLog(@"レストランが押されたよ");
    
    UIButton *Btn = (UIButton *)sender;
    // キャストする。。。クリックされた情報がsenderに入っていて、それを変数Btnに突っ込んでいる
    
//    NSLog(@"Btnのタイトル %@", Btn.currentTitle);
    
    _appDeligate.btnTitle = Btn.currentTitle;
    //appdeligateした時は値が代入されているかを必ず確認する
    NSLog(@"アップテリゲートのタイトル %@", _appDeligate.btnTitle);
    
    SecondViewController *SVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SecondViewController"];

    // モーダルで遷移（下からギュン）
//    [self presentViewController:SVC animated:YES completion:nil];

    // プッシュで遷移（横からシュっ）
    [self.navigationController pushViewController:SVC animated:YES];

}
@end



//ボタンを2つ用意（beachとrestaurant）
//プロパティ

//viewcontrollerを追加
//hとmをつくる
//クラス名だけでなくstoryboardIDも同じ名前でつけておく
// ※ tableviewは1枚だけでクリックされた内容によって表示方法を変える手段をとる
//もーだる＝下から
//プッシュ＝横から


//コードの内容でページ遷移させるのは重要！


//　appdeligateとは。。。
//　スーパーグローバル変数を扱う方法
//　プロジェクト内どこでも扱えるようにするためのファイルのこと

//プロパティへのアクセスはクラス名[.]プロパティ名にする
