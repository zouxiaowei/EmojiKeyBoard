//
//  EmojiCategory.h
//  EmojiKeyBoard
//
//  Created by zou on 2018/9/25.
//  Copyright © 2018年 zou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EmojiItem.h"
typedef NS_ENUM(NSInteger, EmojiKind){
    EmojiKindNormal=1,
    EmojiKindTextEmoji,
    EmojiKindTextDescription
};

@interface EmojiCategory : NSObject
@property (nonatomic,strong) NSArray<EmojiItem *> *EmojiItems;

//表情种类 normal（emoji表情） textEmoji（颜文字） textDescription（动作描述）
@property (nonatomic) EmojiKind emojiKind;

//类别图标
@property (nonatomic,strong) NSString *cateImg;


@end
