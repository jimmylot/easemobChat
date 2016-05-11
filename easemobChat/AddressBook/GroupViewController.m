//
//  GroupViewController.m
//  easemobChat
//
//  Created by FanLang on 16/4/29.
//  Copyright © 2016年 FanLang. All rights reserved.
//

#import "GroupViewController.h"
#import "EMSDK.h"
#import "ChatViewController.h"

@interface GroupViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *baseTableView;
@property (nonatomic, strong)NSMutableArray * dataSourceAry;
@property (nonatomic, copy)NSString * groupNameString;
@property (nonatomic, copy)NSString * groupDescription;

@end

@implementation GroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray * arry = [[EMClient sharedClient].groupManager getAllGroups];
    
    for (EMGroup * group in arry) {
        NSString * string = group.groupId;
        
        [self.dataSourceAry addObject:string];
        
    }
    
    
    
}
- (IBAction)addGroup:(id)sender {
    
    [self setAlertString:@"创建群组"];
    
}

// 状态提示
- (void)setAlertString:(NSString *)string
{
    //初始化提示框；
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:string preferredStyle: UIAlertControllerStyleAlert];
    
    __weak typeof(self) mySelf = self;
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"群名称";
        textField.tag = 1002;
        [textField addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
        
    }];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"群描述";
        textField.tag = 1003;
        [textField addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
    }];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"创建" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        EMError *error = nil;
        EMGroupOptions *setting = [[EMGroupOptions alloc] init];
        setting.maxUsersCount = 500;
        setting.style = EMGroupStylePrivateMemberCanInvite;// 创建不同类型的群组，这里需要才传入不同的类型
        EMGroup *group = [[EMClient sharedClient].groupManager createGroupWithSubject:mySelf.groupNameString description:mySelf.groupDescription invitees:@[@"lssdasd"] message:[NSString stringWithFormat:@"要你进入%@群", mySelf.groupNameString] setting:setting error:&error];
        if(!error){
            NSLog(@"创建成功 -- %@",group.groupId);
            
            [mySelf.dataSourceAry addObject:mySelf.groupNameString];
            [mySelf.baseTableView reloadData];
            
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
    if (sender.tag == 1002) {
        self.groupNameString = sender.text;
    }else
    {
        self.groupDescription = sender.text;
    }
}

-(NSMutableArray *)dataSourceAry
{
    if (_dataSourceAry == nil) {
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
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"GroupCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"GroupCell"];
    }
    
    cell.textLabel.text = self.dataSourceAry[indexPath.row];
    
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
