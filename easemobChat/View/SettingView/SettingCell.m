//
//  SettingCell.m
//  easemobChat
//
//  Created by FanLang on 16/4/27.
//  Copyright © 2016年 FanLang. All rights reserved.
//

#import "SettingCell.h"
#import "EMSDK.h"

#define UIScreenWidth   [UIScreen mainScreen].bounds.size.width  // 屏幕宽
#define UIScreenHeight  [UIScreen mainScreen].bounds.size.height  // 屏幕高


@implementation SettingCell

-(instancetype)initCellWithcount:(NSInteger)count
{
    if ([super init]) {
        
        switch (count) {
            case 0:
            {
                UILabel * titleLb = [[UILabel alloc] initWithFrame:CGRectMake(10, 11, 80, 20)];
                titleLb.text = @"自动登录";
                [self addSubview:titleLb];
                
                UISwitch * swit = [[UISwitch alloc] initWithFrame:CGRectMake(UIScreenWidth - 60, 5, 1, 1)];
                
                [swit setOn:YES animated:YES];
                [swit addTarget:self action:@selector(switON:) forControlEvents:UIControlEventValueChanged];
                
                [self addSubview:swit];
                
                
            }
                break;
            case 1:
            {
                
            }
                break;
            case 2:
            {
                
            }
                break;
            case 3:
            {
                
            }
                break;
            case 4:
            {
                
            }
                break;
            case 5:
            {
                
            }
                break;
            case 6:
            {
                
            }
                break;
            case 7:
            {
                
            }
                break;
            case 8:
            {
                
            }
                break;
            case 9:
            {
                UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
                button.frame = CGRectMake(10, 5, UIScreenWidth - 20, 34);
                button.backgroundColor = [UIColor redColor];
                [button setTitle:@"退出登录" forState:UIControlStateNormal];
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [button addTarget:self action:@selector(outLogin) forControlEvents:UIControlEventTouchUpInside];
                [self.contentView addSubview:button];
            }
                break;
            default:
                break;
        }
        
        
    }
    return self;
}



- (void)outLogin
{
    if ([self.settingCellDelegate respondsToSelector:@selector(outlogin)]) {
        [self.settingCellDelegate outlogin];
    }
}


- (void)switON:(UISwitch *)swit
{
    if (swit.isOn) {
       
       
    }else
    {
       
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
