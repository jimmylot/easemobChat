//
//  SessionViewController.m
//  easemobChat
//
//  Created by FanLang on 16/4/26.
//  Copyright © 2016年 FanLang. All rights reserved.
//

#import "SessionViewController.h"
#import "EMSDK.h"
#import "ChatViewController.h"
#import "SessionCell.h"
#import "EaseConversationModel.h"

@interface SessionViewController ()<EMChatManagerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *baseTableView;
@property (nonatomic, strong)NSMutableArray * dataSourceAry;

@end

@implementation SessionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)viewWillAppear:(BOOL)animated
{
    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
    
    NSArray *conversations = [[EMClient sharedClient].chatManager loadAllConversationsFromDB];
    
    for (EMConversation * conversation in conversations) {
        
        EaseConversationModel * model = [[EaseConversationModel alloc] initWithConversation:conversation];
        [self.dataSourceAry addObject:model];
    }
    
    
//    self.dataSourceAry = [conversations mutableCopy];
//    
//    EMConversation * conversation = conversations[0];
//    
//    
//    NSString * string = conversation.conversationId; // 会话的唯一标识
//    
//    EMConversationType type = conversation.type; // 会话类型
//    NSDictionary * dicExt = conversation.ext;
//    EMMessageBody * body = conversation.latestMessage.body;
//    
//    NSLog(@"%@", conversations);
//    NSLog(@"!%@", string);
//    NSLog(@"#%d", type);
//    NSLog(@"$%@", dicExt);
//    NSLog(@"*%@", body);

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
    SessionCell * cell = [tableView dequeueReusableCellWithIdentifier:@"SessionCell"];
    
    if (!cell) {
        cell = [[SessionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SessionCell"];
    }
    cell.model = self.dataSourceAry[indexPath.row];
    
    return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ChatViewController * chatVC = [[ChatViewController alloc] init];
    
    chatVC.nameStr = ((EaseConversationModel *)self.dataSourceAry[indexPath.row]).title;
    
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chatVC animated:YES];
    
    self.hidesBottomBarWhenPushed = NO;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0f;
}


-(void)dealloc
{
    [[EMClient sharedClient].chatManager removeDelegate:self];
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
