//
//  AddressViewController.m
//  easemobChat
//
//  Created by FanLang on 16/4/26.
//  Copyright © 2016年 FanLang. All rights reserved.
//

#import "AddressViewController.h"
#import "EMSDK.h"
#import "ChatViewController.h"
#import "FriendsListCell.h"

#define UIScreenWidth   [UIScreen mainScreen].bounds.size.width  // 屏幕宽
#define UIScreenHeight  [UIScreen mainScreen].bounds.size.height  // 屏幕高

@interface AddressViewController ()<EMContactManagerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, copy)NSString * addIdStr;
@property (nonatomic, copy)NSString * supplementStr;

@property (nonatomic, strong)UITableView * baseTableView;
@property (nonatomic, strong)NSMutableArray * dataSourceAry;

@end

@implementation AddressViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.baseTableView];
    
    
}
- (void)viewWillAppear:(BOOL)animated
{
    //注册好友回调
    [[EMClient sharedClient].contactManager addDelegate:self delegateQueue:nil];
    
    EMError *error = nil;
    NSArray *userlist = [[EMClient sharedClient].contactManager getContactsFromServerWithError:&error];
    if (!error) {
        self.dataSourceAry = [userlist mutableCopy];
    }else
    {
        return;
    }
}

-(void)dealloc
{
    // 移除好友回调
    [[EMClient sharedClient].contactManager removeDelegate:self];
}

- (UITableView *)baseTableView
{
    if (_baseTableView == nil) {
        _baseTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, UIScreenHeight)];
        _baseTableView.delegate = self;
        _baseTableView.dataSource = self;
    }
    return _baseTableView;
}

-(NSMutableArray *)dataSourceAry
{
    if (_dataSourceAry ==nil) {
        _dataSourceAry = [@[] mutableCopy];
    }
    return _dataSourceAry;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSourceAry.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FriendsListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"FriendsListCell"];
    
    if (!cell) {
        cell = [[FriendsListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FriendsListCell"];
    }
    
//    cell.textLabel.text = self.dataSourceAry[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ChatViewController * chatVC = [[ChatViewController alloc] init];
    
    chatVC.nameStr = self.dataSourceAry[indexPath.row];
    
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chatVC animated:YES];
    
    self.hidesBottomBarWhenPushed = NO;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}


- (IBAction)add:(id)sender {
    
    [self setAlertString:@"添加好友"];
}

// 添加好友后返回的状态
- (void)didReceiveFriendInvitationFromUsername:(NSString *)aUsername
                                       message:(NSString *)aMessage
{
    [self setAddAlertString:aMessage nameString:aUsername];
}


/*!
 @method
 @brief 用户A发送加用户B为好友的申请，用户B同意后，用户A会收到这个回调
 */
- (void)didReceiveAgreedFromUsername:(NSString *)aUsername
{
    NSLog(@"对方同意添加好友");
    [self.dataSourceAry addObject:aUsername];
    [self.baseTableView reloadData];
}

/*!
 @method
 @brief 用户A发送加用户B为好友的申请，用户B拒绝后，用户A会收到这个回调
 */
- (void)didReceiveDeclinedFromUsername:(NSString *)aUsername
{
    NSLog(@"对方拒绝添加好友");
}


// 状态提示
- (void)setAddAlertString:(NSString *)string nameString:(NSString *)nameString
{
    //初始化提示框；
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nameString message:string preferredStyle: UIAlertControllerStyleAlert];
    
     __weak typeof(self) mySelf = self;
    [alert addAction:[UIAlertAction actionWithTitle:@"同意" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        EMError *error = [[EMClient sharedClient].contactManager acceptInvitationForUsername:nameString];
        if (!error) {
            NSLog(@"发送同意成功");
            [mySelf.dataSourceAry addObject:nameString];
            [mySelf.baseTableView reloadData];
            
        }else
        {
            
        }
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"拒绝" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        EMError *error = [[EMClient sharedClient].contactManager declineInvitationForUsername:nameString];
        if (!error) {
            NSLog(@"发送拒绝成功");
        }
    }]];
    
    //弹出提示框；
    [self presentViewController:alert animated:true completion:nil];
}



// 状态提示
- (void)setAlertString:(NSString *)string
{
    //初始化提示框；
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:string preferredStyle: UIAlertControllerStyleAlert];
    
    __weak typeof(self) mySelf = self;
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"好友账号";
        textField.tag = 1000;
        [textField addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
        
    }];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"说点什么吧";
        textField.tag = 1001;
        [textField addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
    }];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        EMError *error = [[EMClient sharedClient].contactManager addContact:mySelf.addIdStr message:mySelf.supplementStr];
        if (!error) {
            NSLog(@"添加成功");
        }else
        {
            NSLog(@"添加失败");
        }
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //点击按钮的响应事件；
    }]];
    
    //弹出提示框；
    [self presentViewController:alert animated:true completion:nil];
}


- (void)textChange:(UITextField *)sender
{
    if (sender.tag == 1000) {
        self.addIdStr = sender.text;
    }else
    {
        self.supplementStr = sender.text;
    }
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
