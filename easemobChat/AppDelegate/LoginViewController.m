//
//  LoginViewController.m
//  easemobChat
//
//  Created by FanLang on 16/4/26.
//  Copyright © 2016年 FanLang. All rights reserved.
//

#import "LoginViewController.h"
#import "EMSDK.h"
@interface LoginViewController ()<EMClientDelegate>

@property (weak, nonatomic) IBOutlet UITextField *accountTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;



@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.successLb.text = self.string;
    [[EMClient sharedClient] addDelegate:self delegateQueue:nil];
    
}
-(void)dealloc
{
    [[EMClient sharedClient] removeDelegate:self];
}

- (IBAction)registerName:(id)sender {
    
    EMError *error = [[EMClient sharedClient] registerWithUsername:self.accountTF.text password:self.passwordTF.text];
    
    if (error==nil) {
        self.successLb.text = @"注册成功";
    }else
    {
        self.successLb.text = error.errorDescription;
    }
}


- (IBAction)login:(id)sender {
   
    BOOL isAutoLogin = [EMClient sharedClient].options.isAutoLogin;
    
    if (!isAutoLogin) {
        EMError *error = [[EMClient sharedClient] loginWithUsername:self.accountTF.text   password:self.passwordTF.text];
        
        if (!error) {
            [[EMClient sharedClient].options setIsAutoLogin:YES];
            
            // 模拟登录成功后获取到的oncetoken
            NSString * string = @"bsdwiuehdncasbdfu8476238rbfjsdfg";
            
            [[NSUserDefaults standardUserDefaults] setObject:string forKey:@"onceToKen"];
            
            UITabBarController * tab = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"tabBar"];
            
            tab.selectedIndex = 0;
            UIWindow * window = [UIApplication sharedApplication].keyWindow;
            window.rootViewController = tab;
        }else
        {
            
            [self setAlertString:@"登录失败，请重新尝试"];
            
        }
    }
}



/*!
 *  SDK连接服务器的状态变化时会接收到该回调
 *
 *  有以下几种情况, 会引起该方法的调用:
 *  1. 登录成功后, 手机无法上网时, 会调用该回调
 *  2. 登录成功后, 网络状态变化时, 会调用该回调
 *
 *  @param aConnectionState 当前状态
 */
- (void)didConnectionStateChanged:(EMConnectionState)aConnectionState
{
    if (aConnectionState == EMConnectionDisconnected) {
        UIWindow * window = [UIApplication sharedApplication].keyWindow;
        window.rootViewController = self;
    }else
    {
        [self setAlertString:@"登陆成功"];
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
