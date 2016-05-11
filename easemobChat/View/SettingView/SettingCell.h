//
//  SettingCell.h
//  easemobChat
//
//  Created by FanLang on 16/4/27.
//  Copyright © 2016年 FanLang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SettingCellDelegate <NSObject>

- (void)outlogin; // 退出登录

@end



@interface SettingCell : UITableViewCell

-(instancetype)initCellWithcount:(NSInteger)count;

@property (nonatomic, assign)id<SettingCellDelegate> settingCellDelegate;



@end
