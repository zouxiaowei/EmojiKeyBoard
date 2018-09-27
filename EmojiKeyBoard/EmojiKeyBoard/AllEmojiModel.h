//
//  AllEmojiModel.h
//  EmojiKeyBoard
//
//  Created by zou on 2018/9/25.
//  Copyright © 2018年 zou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EmojiCategory.h"
@interface AllEmojiModel : NSObject

@property (nonatomic,strong) NSArray<EmojiCategory *>* allEmojis;

@end
