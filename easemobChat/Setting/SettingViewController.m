//
//  SettingViewController.m
//  easemobChat
//
//  Created by FanLang on 16/4/26.
//  Copyright © 2016年 FanLang. All rights reserved.
//

#import "SettingViewController.h"
#import "LoginViewController.h"
#import "SettingCell.h"
#import "EMSDK.h"

@interface SettingViewController ()<UITableViewDelegate, UITableViewDataSource, SettingCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *baseTableView;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SettingCell * cell = [tableView dequeueReusableCellWithIdentifier:@"setCell"];
    if (!cell) {
        cell = [[SettingCell alloc] initCellWithcount:indexPath.row];
    }
    cell.settingCellDelegate = self;
//    cell.textLabel.text = @"测试数据";
    
    return cell;
    
}


-(void)outlogin
{
    EMError *error = [[EMClient sharedClient] logout:YES];
    if (!error) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"onceToKen"];
        
        LoginViewController * loginVC = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        UIWindow * window = [UIApplication sharedApplication].keyWindow;
        window.rootViewController = loginVC;
        
        
    }else
    {
        [self setAlertString:error.errorDescription];
    }

}


// 状态提示
- (void)setAlertString:(NSString *)string
{
    //初始化提示框；
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:string preferredStyle: UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //点击按钮的响应事件；
    }]];
    
    //弹出提示框；
    [self presentViewController:alert animated:true completion:nil];
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
