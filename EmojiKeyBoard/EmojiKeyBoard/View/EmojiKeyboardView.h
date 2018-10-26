//
//  EmojiKeyboardView.h
//  EmojiKeyBoard
//
//  Created by zou on 2018/9/19.
//  Copyright © 2018年 zou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EmojiItemViewCell.h"

@protocol EmojiKeyboardViewDelegate <NSObject>

@optional

- (void)didClickEmoji:(EmojiItem *)emojiItem;
- (void)didClickSend;
- (void)didClickDelete;
- (void)didClickAdd;
- (void)startLongPressDelete;
- (void)endLongPressDelete;


@end

@interface EmojiKeyboardView : UIView

@property (nonatomic, strong) NSArray *emojiCates;
@property (nonatomic) NSInteger currentEmojiCateIndex;
@property (nonatomic) NSInteger screenWidth;

@property (nonatomic,weak) id<EmojiKeyboardViewDelegate> delegate;


- (instancetype)initWithFrame:(CGRect)frame;
- (void)reloadEmojis:(NSArray *)emojicates;

@end
