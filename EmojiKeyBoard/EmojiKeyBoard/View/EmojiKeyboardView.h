//
//  EmojiKeyboardView.h
//  EmojiKeyBoard
//
//  Created by zou on 2018/9/19.
//  Copyright © 2018年 zou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AllEmojiModel.h"
#import "EmojiItemViewCell.h"

@protocol EmojiKeyboardViewDelegate <NSObject>

@optional
- (void)didClickEmoji:(EmojiItem *)emojiItem;
- (void)didClickSend;
- (void)didClickDelete;
- (void)didClickAdd;

@end

@protocol EmojiKeyboardViewDataSource <NSObject>
- (AllEmojiModel *) emojiEmodelForEmojiKeyBoard;
@end

@interface EmojiKeyboardView : UIView

@property (nonatomic,strong) AllEmojiModel *allEmojiModel;
@property (nonatomic,assign) NSInteger currentEmojiCateIndex;
@property (nonatomic,weak) id<EmojiKeyboardViewDelegate> delegate;
@property (nonatomic,weak) id<EmojiKeyboardViewDataSource> datasource;
@property (nonatomic) CGFloat screenWidth;

- (instancetype)initWithFrame:(CGRect)frame;
- (void)reloadAllData:(AllEmojiModel *)emojiModel;  //更新数据源

@end
