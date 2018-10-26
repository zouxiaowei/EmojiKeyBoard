//
//  EmojiItem.h
//  EmojiKeyBoard
//
//  Created by zou on 2018/9/19.
//  Copyright © 2018年 zou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"
@interface EmojiItem : BaseModel
@property (nonatomic,copy) NSString *imageName;
@property (nonatomic,copy) NSString *word;
@end
