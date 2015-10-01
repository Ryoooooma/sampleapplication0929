//
//  SecondViewController.m
//  sampleapplication0929
//
//  Created by 脇田竜馬 on 2015/09/29.
//  Copyright (c) 2015年 Ryoma Wakita. All rights reserved.
//

#import "SecondViewController.h"
#import "ThirdViewController.h"
#import "AppDelegate.h"

@interface SecondViewController (){
    AppDelegate *_appdeligate;
    
    NSArray *_plistArray;
    
    int _category;
    
}

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    // 初期化
    _appdeligate = [[UIApplication sharedApplication] delegate];
    
    NSLog(@"セカンドビューコンのアップデリゲート %@", _appdeligate.btnTitle);
    
    // UILabelがNSStringを受け入れる必要があるので[.text]を追記する必要がある（nsstringになる的な）
    self.btnTitle.text = _appdeligate.btnTitle;
 
    self.title = _appdeligate.btnTitle;
    
    // delegataを扱うのがsecondviewconですよと宣言
    self.indexTableView.delegate = self;
    self.indexTableView.dataSource = self;
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *path = [bundle pathForResource:@"List" ofType:@"plist"];
    
    _plistArray = [NSArray arrayWithContentsOfFile:path];
    NSLog(@"ary %@", _plistArray);
    NSLog(@"ary[0] %@", _plistArray[0]);
    
    NSLog(@"ary1件目の名前 %@", _plistArray[0][0][@"name"]);
    NSLog(@"ary1件目のテキスト %@", _plistArray[0][0][@"text"]);
    
    if ([_appdeligate.btnTitle isEqualToString:@"Beach"]) {
        _category = 0;
    } else if([_appdeligate.btnTitle isEqualToString:@"Restaurant"]) {
        _category = 1;
    }
}

    // セクションの数を決めてあげるメソッド
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

    // 行数を決めてあげるメソッド
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    int count;
    
    count = (int)[_plistArray[_category] count];
    
    return count;
}

//セルの内容を決めるメソッド
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//  再利用可能がなセルを生成
    static NSString *CellIndentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIndentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIndentifier];
    }
    cell.textLabel.text = _plistArray[_category][indexPath.row][@"name"];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%li番目がタップされたよ",indexPath.row);
    
    _appdeligate.infoText = _plistArray[_category][indexPath.row][@"text"];
    _appdeligate.infoTitle = _plistArray[_category][indexPath.row][@"name"];

    
    ThirdViewController *TVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ThirdViewController"];
    
    // プッシュで遷移（横からシュっ）
    [self.navigationController pushViewController:TVC animated:YES];
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
