//
//  EmojiItemViewCell.m
//  EmojiKeyBoard
//
//  Created by zou on 2018/9/20.
//  Copyright © 2018年 zou. All rights reserved.
//

#import "EmojiItemViewCell.h"
#import <Masonry.h>
@interface EmojiItemViewCell()

@property (nonatomic,strong) UIImageView *emojiImageView;

@property (nonatomic,strong) UILabel *emojiName;

@end

@implementation EmojiItemViewCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self createUI];
    }
    
    return self;
}

-(void) createUI{
    self.emojiImageView=[[UIImageView alloc]init];
    [self.contentView addSubview:self.emojiImageView];
    [self.emojiImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
    self.emojiImageView.contentMode=UIViewContentModeScaleAspectFit;
    
}


- (void)setEmoji:(EmojiItem *)emoji{
    _emoji=emoji;
    if(_emoji){
        NSString *imgName=_emoji.ImageName;
//        NSString *imgWord=_emoji.Word;
        UIImage *image=[UIImage imageNamed:imgName];
        self.emojiImageView.image=image;
        
    }
}
@end
