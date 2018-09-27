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
@property (nonatomic,strong) UILabel *emojiWordLabel;

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
    //图片表情
    self.emojiImageView=[[UIImageView alloc]init];
    [self.contentView addSubview:self.emojiImageView];
    [self.emojiImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
    self.emojiImageView.contentMode=UIViewContentModeScaleAspectFit;
    
    //文字表情
    self.emojiWordLabel=[[UILabel alloc]init];
    [self.contentView addSubview:self.emojiWordLabel];
    [self.emojiWordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self);
    }];
    self.emojiWordLabel.textAlignment=NSTextAlignmentCenter;
    self.emojiWordLabel.font=[UIFont systemFontOfSize:11];
}


- (void)setEmoji:(EmojiItem *)emoji{
    
    _emoji=emoji;
    if(_emoji){
        
        NSString *imgName=_emoji.ImageName;
        if(imgName==nil){
            //文字表情
            self.emojiImageView.hidden=YES;
            self.emojiWordLabel.hidden=NO;
            self.emojiWordLabel.text=emoji.Word;
        }else{
            //图片表情
            self.emojiWordLabel.hidden=YES;
            self.emojiImageView.hidden=NO;
            UIImage *image=[UIImage imageNamed:imgName];
            self.emojiImageView.image=image;
        }
        
    }
}
@end
