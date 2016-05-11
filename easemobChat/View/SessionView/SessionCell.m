//
//  SessionCell.m
//  easemobChat
//
//  Created by FanLang on 16/4/28.
//  Copyright © 2016年 FanLang. All rights reserved.
//

#import "SessionCell.h"
#import "UIImageView+EMWebCache.h"
#import "EMConversation.h"

#define UIScreenWidth   [UIScreen mainScreen].bounds.size.width  // 屏幕宽
#define UIScreenHeight  [UIScreen mainScreen].bounds.size.height  // 屏幕高

@implementation SessionCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _showAvatar = YES;
        [self creatUI];
    }
    return self;
}

- (void)creatUI
{
    EaseImageView * imgView = [[EaseImageView alloc] initWithFrame:CGRectMake(10, 10, 50, 50)];
    imgView.image = [UIImage imageNamed:@"5pic7"];
//    imgView.backgroundColor = [UIColor redColor];
    [self addSubview:imgView];
    self.avatarView = imgView;
    
    UILabel * nameLb = [[UILabel alloc] initWithFrame:CGRectMake(70, 10, (UIScreenWidth - 80) / 2.0, 20)];
    nameLb.text = @"说说";
    nameLb.font = [UIFont systemFontOfSize:20.0];
    [self addSubview:nameLb];
    self.titleLabel = nameLb;
    
    UILabel * titleLb = [[UILabel alloc] initWithFrame:CGRectMake(70, 40, UIScreenWidth - 80, 20)];
    titleLb.text = @"你好,还在吗?";
    titleLb.font = [UIFont systemFontOfSize:12.0];
    titleLb.textColor = [UIColor grayColor];
    [self addSubview:titleLb];
    self.detailLabel = titleLb;
    
    UILabel * timeLb = [[UILabel alloc] initWithFrame:CGRectMake(UIScreenWidth - (UIScreenWidth - 80) / 2.0 - 10, 10, (UIScreenWidth - 80) / 2.0, 20)];
    timeLb.textAlignment = 2;
    timeLb.font = [UIFont systemFontOfSize:13.0];
    timeLb.text = @"12:30:45";
    [self addSubview:timeLb];
    self.timeLabel = titleLb;
}


- (void)setModel:(id<IConversationModel>)model
{
    _model = model;
    
    if ([_model.title length] > 0) {
        self.titleLabel.text = _model.title;
    }
    else{
        self.titleLabel.text = _model.conversation.conversationId;
    }
    
    if (self.showAvatar) {
        if ([_model.avatarURLPath length] > 0){
            [self.avatarView.imageView sd_setImageWithURL:[NSURL URLWithString:_model.avatarURLPath] placeholderImage:_model.avatarImage];
        } else {
            if (_model.avatarImage) {
                self.avatarView.image = _model.avatarImage;
            }
        }
    }
    
    if (_model.conversation.unreadMessagesCount == 0) {
        _avatarView.showBadge = NO;
    }
    else{
        _avatarView.showBadge = YES;
        _avatarView.badge = _model.conversation.unreadMessagesCount;
    }
}





- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
