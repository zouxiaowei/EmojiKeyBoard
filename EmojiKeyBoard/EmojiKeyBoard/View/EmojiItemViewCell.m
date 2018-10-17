//
//  EmojiItemViewCell.m
//  EmojiKeyBoard
//
//  Created by zou on 2018/9/20.
//  Copyright © 2018年 zou. All rights reserved.
//

#import "EmojiItemViewCell.h"
#import "SlideLineButton.h"
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
    
//    //文字表情
//    self.textEmojiButton = [[SlideLineButton alloc]initWithFrame:self.frame SlideButtonStyle:slideButtonStyleDefault andColor:[UIColor lightGrayColor]];
//    [self.contentView addSubview:self.textEmojiButton];
//    [self.textEmojiButton.titleLabel setFont:[UIFont systemFontOfSize:11]];
//    self.textEmojiButton.titleLabel.textAlignment = NSTextAlignmentCenter;
}


- (void)setEmoji:(EmojiItem *)emoji{
    
    _emoji=emoji;
    if(_emoji){
        NSString *imgName=_emoji.ImageName;
        if(imgName==nil || imgName.length==0){
            //文字表情
            self.emojiWordLabel.hidden=NO;
            self.emojiImageView.hidden=YES;
            if(emoji.Word!= nil && emoji.Word.length!=0){
                [self.emojiWordLabel setText:emoji.Word];
//                NSArray<CALayer *> *layers = [self createEmojiLines];
//                self.layer.sublayers = layers;
//                self.layer.borderColor = [UIColor grayColor].CGColor;
//                self.layer.borderWidth = 0.3f;
            }else{
//                [self.emojiWordLabel setText:nil];
//                self.layer.borderWidth = 0;
//                [self.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
//                NSArray<CALayer *> *layers = [self createNilEmojiLines];
//                self.layer.sublayers = layers;
            }
        }else{
            //textEmojiButton图片表情
            self.emojiWordLabel.hidden=YES;
            self.emojiImageView.hidden=NO;
            UIImage *image=[UIImage imageNamed:imgName];
            self.emojiImageView.image=image;
//            self.layer.borderWidth = 0;
//            [self.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
//            NSArray<CALayer *> *layers = [self createNilEmojiLines];
//            self.layer.sublayers = layers;
        }
        
    }
}

-(NSArray<CALayer *> *)createEmojiLines{
    NSMutableArray<CALayer *> *layers = [NSMutableArray array];
    
    CALayer *layer1 = [CALayer layer];
    layer1.backgroundColor = [UIColor lightGrayColor].CGColor;
    layer1.frame = CGRectMake(0, 0, self.frame.size.width, 0.3);
    CALayer *layer2 = [CALayer layer];
    layer2.backgroundColor = [UIColor lightGrayColor].CGColor;
    layer2.frame = CGRectMake(0, 0, 0.3, self.frame.size.height);
    CALayer *layer3 = [CALayer layer];
    layer3.backgroundColor = [UIColor lightGrayColor].CGColor;
    layer3.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, 0.3);
    
    [layers addObjectsFromArray:[NSArray arrayWithObjects:layer1,layer2,layer3, nil]];
    
    return layers;
}
-(NSArray<CALayer *> *)createNilEmojiLines{
    NSMutableArray<CALayer *> *layers = [NSMutableArray array];
    
    return layers;
}
@end
