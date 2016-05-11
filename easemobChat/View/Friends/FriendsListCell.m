//
//  FriendsListCell.m
//  easemobChat
//
//  Created by FanLang on 16/4/28.
//  Copyright © 2016年 FanLang. All rights reserved.
//

#import "FriendsListCell.h"

#define UIScreenWidth   [UIScreen mainScreen].bounds.size.width  // 屏幕宽
#define UIScreenHeight  [UIScreen mainScreen].bounds.size.height  // 屏幕高

@implementation FriendsListCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self creatUI];
    }
    return self;
}


- (void)creatUI
{
    UIImageView * imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
    imgView.layer.cornerRadius = 10;
    imgView.image = [UIImage imageNamed:@"5pic2"];
    [self addSubview:imgView];
    
    UILabel * nameLb = [[UILabel alloc] initWithFrame:CGRectMake(60, 20, UIScreenWidth - 70, 20)];
    nameLb.text = @"测试人员";
    [self addSubview:nameLb];
}




- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
