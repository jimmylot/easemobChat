//
//  ChatViewController.m
//  easemobChat
//
//  Created by FanLang on 16/4/26.
//  Copyright © 2016年 FanLang. All rights reserved.
//

#import "ChatViewController.h"
#import "ChatKeyBoard.h"
#import "MoreItem.h"
#import "ChatToolBarItem.h"
#import "FaceSourceManager.h"
#import "FaceThemeModel.h"
#import "EMSDK.h"


#define UIScreenWidth   [UIScreen mainScreen].bounds.size.width  // 屏幕宽
#define UIScreenHeight  [UIScreen mainScreen].bounds.size.height  // 屏幕高

@interface ChatViewController () <ChatKeyBoardDataSource, ChatKeyBoardDelegate,EMChatManagerDelegate, UITableViewDataSource, UITableViewDelegate>

/** chatkeyBoard */
@property (nonatomic, strong) ChatKeyBoard *chatKeyBoard;


@property (nonatomic, strong)UITableView * baseTableView;

@property (nonatomic, strong)NSMutableArray * meDataSourceAry;




@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = self.nameStr;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationChange:) name:@"jianpan" object:nil];
    
    [self.view addSubview:self.baseTableView];
    
    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
    self.chatKeyBoard = [ChatKeyBoard keyBoardWithNavgationBarTranslucent:NO];
    
    self.chatKeyBoard.delegate = self;
    self.chatKeyBoard.dataSource = self;
    
    self.chatKeyBoard.placeHolder = @"请输入消息";
    [self.view addSubview:self.chatKeyBoard];
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = YES;
}

#pragma mark - 监听键盘
- (void)notificationChange:(NSNotification *)sender
{
   NSNumber * num = sender.userInfo[@"y"];
    CGFloat y = [num floatValue];
    
    _baseTableView.frame = CGRectMake(0, 0, UIScreenWidth, y);
}


#pragma mark -- ChatKeyBoardDataSource
- (NSArray<MoreItem *> *)chatKeyBoardMorePanelItems
{
    MoreItem *item1 = [MoreItem moreItemWithPicName:@"sharemore_location" highLightPicName:nil itemName:@"位置"];
    MoreItem *item2 = [MoreItem moreItemWithPicName:@"sharemore_pic" highLightPicName:nil itemName:@"图片"];
    MoreItem *item3 = [MoreItem moreItemWithPicName:@"sharemore_video" highLightPicName:nil itemName:@"拍照"];
    MoreItem *item4 = [MoreItem moreItemWithPicName:@"sharemore_location" highLightPicName:nil itemName:@"位置"];
    MoreItem *item5 = [MoreItem moreItemWithPicName:@"sharemore_pic" highLightPicName:nil itemName:@"图片"];
    MoreItem *item6 = [MoreItem moreItemWithPicName:@"sharemore_video" highLightPicName:nil itemName:@"拍照"];
    MoreItem *item7 = [MoreItem moreItemWithPicName:@"sharemore_location" highLightPicName:nil itemName:@"位置"];
    MoreItem *item8 = [MoreItem moreItemWithPicName:@"sharemore_pic" highLightPicName:nil itemName:@"图片"];
    MoreItem *item9 = [MoreItem moreItemWithPicName:@"sharemore_video" highLightPicName:nil itemName:@"拍照"];
    return @[item1, item2, item3, item4, item5, item6, item7, item8, item9];
}
- (NSArray<ChatToolBarItem *> *)chatKeyBoardToolbarItems
{
    ChatToolBarItem *item1 = [ChatToolBarItem barItemWithKind:kBarItemFace normal:@"face" high:@"face_HL" select:@"keyboard"];
    
    ChatToolBarItem *item2 = [ChatToolBarItem barItemWithKind:kBarItemVoice normal:@"voice" high:@"voice_HL" select:@"keyboard"];
    
    ChatToolBarItem *item3 = [ChatToolBarItem barItemWithKind:kBarItemMore normal:@"more_ios" high:@"more_ios_HL" select:nil];
    
    ChatToolBarItem *item4 = [ChatToolBarItem barItemWithKind:kBarItemSwitchBar normal:@"switchDown" high:nil select:nil];
    
    return @[item1, item2, item3, item4];
}

- (NSArray<FaceThemeModel *> *)chatKeyBoardFacePanelSubjectItems
{
    return [FaceSourceManager loadFaceSource];
}


#pragma mark -- 语音状态
- (void)chatKeyBoardDidStartRecording:(ChatKeyBoard *)chatKeyBoard
{
    NSLog(@"*****正在录音");
}
- (void)chatKeyBoardDidCancelRecording:(ChatKeyBoard *)chatKeyBoard
{
     NSLog(@"*****已经取消录音");
}
- (void)chatKeyBoardDidFinishRecoding:(ChatKeyBoard *)chatKeyBoard
{
    NSLog(@"*****已经完成录音");
}
- (void)chatKeyBoardWillCancelRecoding:(ChatKeyBoard *)chatKeyBoard
{
    NSLog(@"*****将要取消录音");
}
- (void)chatKeyBoardContineRecording:(ChatKeyBoard *)chatKeyBoard
{
    NSLog(@"*****继续录音");
}

#pragma mark -- 更多
- (void)chatKeyBoard:(ChatKeyBoard *)chatKeyBoard didSelectMorePanelItemIndex:(NSInteger)index
{
    NSString *message = [NSString stringWithFormat:@"选择的ItemIndex %zd", index];
    
    NSLog(@"####%@", message);
}

#pragma mark -- 发送文本
- (void)chatKeyBoardSendText:(NSString *)text
{
    NSLog(@"!!!%@", text);
    
    EMTextMessageBody *body = [[EMTextMessageBody alloc] initWithText:text];
    NSString *from = [[EMClient sharedClient] currentUsername];
    //生成Message
    EMMessage *message = [[EMMessage alloc] initWithConversationID:self.nameStr from:from to:self.nameStr body:body ext:nil];
    message.chatType = EMChatTypeChat;
    
    [[EMClient sharedClient].chatManager asyncSendMessage:message progress:^(int progress) {
        NSLog(@"附件上传回调");
    } completion:^(EMMessage *message, EMError *error) {
        NSLog(@"%d, %@", message.status, error.errorDescription);
        
        NSString * string = [NSString stringWithFormat:@"%@: 我", text];
        
        [self.meDataSourceAry addObject:string];
        [self.baseTableView reloadData];
    }];

    
    
}


#pragma mark - ------接收消息------
- (void)didReceiveMessages:(NSArray *)aMessages
{
    for (EMMessage * message in aMessages) {
        EMMessageBody *msgBody = message.body;
        
        switch (msgBody.type) {
            case EMMessageBodyTypeText:
                // 收到的文字消息
                
            {
                EMTextMessageBody * textbody = (EMTextMessageBody *)msgBody;
                NSLog(@"%@", textbody.text);
                
                NSString * string = [NSString stringWithFormat:@"发送: %@", textbody.text];
                [self.meDataSourceAry addObject:string];
                [self.baseTableView reloadData];
                
                NSDictionary *ext = message.ext;
                NSLog(@"消息中的扩展属性是 -- %@",ext);
            }
                
                break;
                
            default:
                break;
        }
    }
}

- (void)didReceiveCmdMessages:(NSArray *)aCmdMessages{
    for (EMMessage *message in aCmdMessages) {
        // cmd消息中的扩展属性
        NSDictionary *ext = message.ext;
        NSLog(@"cmd消息中的扩展属性是 -- %@",ext);
    }
}


-(UITableView *)baseTableView
{
    if (_baseTableView ==nil) {
        _baseTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, UIScreenHeight - 49)];
        _baseTableView.delegate = self;
        _baseTableView.dataSource = self;
    }
    
    return _baseTableView;
}

-(NSMutableArray *)meDataSourceAry
{
    if (_meDataSourceAry == nil) {
        _meDataSourceAry = [@[] mutableCopy];
    }
    
    return _meDataSourceAry;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.meDataSourceAry.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ChatCell"];
    if (!cell) {
      cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ChatCell"];
    }
    cell.textLabel.textAlignment = 2;
    cell.textLabel.text = self.meDataSourceAry[indexPath.row];
    
    return cell;
    
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"jianpan" object:nil];
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
