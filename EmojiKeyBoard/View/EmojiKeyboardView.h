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
@protocol EmojiKeyboardViewDelegate <NSObject>

@required
-(void) didclickEmoji:(EmojiItem *)emojiItem;

@optional
-(void) didclickSend;
@end

@interface EmojiKeyboardView : UIView

@property (nonatomic,strong) AllEmojiModel *allEmojiModel;
@property (nonatomic) NSUInteger currentEmojiCateIndex;
@property (nonatomic,weak) id<EmojiKeyboardViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame;
-(void) initWithAllEmojiModel:(AllEmojiModel *)allEmojiModel;
-(void) changeEmojiListTo:(int)cateIndex;
@end
