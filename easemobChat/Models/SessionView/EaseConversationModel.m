//
//  EaseConversationModel.m
//  easemobChat
//
//  Created by FanLang on 16/4/28.
//  Copyright © 2016年 FanLang. All rights reserved.
//

#import "EaseConversationModel.h"
#import "EMConversation.h"

@implementation EaseConversationModel

- (instancetype)initWithConversation:(EMConversation *)conversation
{
    self = [super init];
    if (self) {
        _conversation = conversation;
        _title = _conversation.conversationId;
        
        if (conversation.type == EMConversationTypeChat) {
            _avatarImage = [UIImage imageNamed:@""];
        }
        else{
            _avatarImage = [UIImage imageNamed:@""];
        }
    }
    
    return self;
}

@end
