//
//  SessionCell.h
//  easemobChat
//
//  Created by FanLang on 16/4/28.
//  Copyright © 2016年 FanLang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IConversationModel.h"
#import "EaseImageView.h"
@interface SessionCell : UITableViewCell

@property (strong, nonatomic) EaseImageView *avatarView;

@property (strong, nonatomic) UILabel *detailLabel;

@property (strong, nonatomic) UILabel *timeLabel;

@property (strong, nonatomic) UILabel *titleLabel;

@property (nonatomic) BOOL showAvatar;//default is "YES"

@property (strong, nonatomic) id<IConversationModel> model;

@end
