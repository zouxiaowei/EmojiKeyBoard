//
//  EmojiItemViewCell.h
//  EmojiKeyBoard
//
//  Created by zou on 2018/9/20.
//  Copyright © 2018年 zou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EmojiItem.h"
#import <Masonry.h>

static NSString *identifierEmojiItemViewCell=@"EmojiItemViewCell";


@interface EmojiItemViewCell : UICollectionViewCell
@property (strong, nonatomic) EmojiItem* emoji;

@end
