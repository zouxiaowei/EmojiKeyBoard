//
//  EmojiKeyboardView.h
//  EmojiKeyBoard
//
//  Created by zou on 2018/9/19.
//  Copyright © 2018年 zou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EmojiItem.h"
#import "AllEmojiModel.h"
@interface EmojiKeyboardView : UIView
- (instancetype)initWithFrame:(CGRect)frame;
-(void) initWithAllEmojiModel:(AllEmojiModel *)allEmojiModel;
-(void) changeEmojiListTo:(int)cateIndex;
@end
