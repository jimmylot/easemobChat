//
//  EaseConversationModel.m
//  easemobChat
//
//  Created by FanLang on 16/4/28.
//  Copyright © 2016年 FanLang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@class EMConversation;
@protocol IConversationModel <NSObject>

@property (strong, nonatomic, readonly) EMConversation *conversation;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *avatarURLPath;
@property (strong, nonatomic) UIImage *avatarImage;

- (instancetype)initWithConversation:(EMConversation *)conversation;

@end
