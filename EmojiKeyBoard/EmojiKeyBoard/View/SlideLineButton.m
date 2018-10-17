//
//  SlideLineButton.m
//  EmojiKeyBoard
//
//  Created by zou on 2018/10/15.
//  Copyright © 2018年 zou. All rights reserved.
//

#import "SlideLineButton.h"
@interface SlideLineButton()

@property (nonatomic,strong) UIView *topSlideVeiw;
@property (nonatomic,strong) UIView *leftSlideVeiw;
@property (nonatomic,strong) UIView *bottomSlideVeiw;
@property (nonatomic,strong) UIView *rightSlideVeiw;
@end


@implementation SlideLineButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/



- (instancetype)initWithFrame:(CGRect)frame SlideButtonStyle:(SlideButtonStyle) style{
    self = [super initWithFrame:frame];
    if(self){
        self.topSlideVeiw = [[UIView alloc]initWithFrame:CGRectMake(style.topSlidePadding,
                                                                    0,
                                                                    CGRectGetWidth(frame)-2*style.topSlidePadding,
                                                                    style.topSlideThickness)];
        self.topSlideVeiw.backgroundColor = [UIColor grayColor];
        [self addSubview:self.topSlideVeiw];
        
        self.leftSlideVeiw = [[UIView alloc]initWithFrame:CGRectMake(0,
                                                                     style.leftSlidePadding,
                                                                     style.leftSlideThickness,
                                                                     CGRectGetHeight(frame)-2*style.leftSlidePadding)];
        self.leftSlideVeiw.backgroundColor = [UIColor grayColor];
        [self addSubview:self.leftSlideVeiw];
        
        self.bottomSlideVeiw = [[UIView alloc]initWithFrame:CGRectMake(style.bottomSlidePadding,
                                                                       CGRectGetHeight(frame)-style.bottomSlideThickness,
                                                                       CGRectGetWidth(frame)-2*style.bottomSlidePadding,
                                                                       style.bottomSlideThickness)];
        self.bottomSlideVeiw.backgroundColor = [UIColor grayColor];
        [self addSubview:self.bottomSlideVeiw];
        
        self.rightSlideVeiw = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetWidth(frame)-style.rightSlideThickness,
                                                                      style.rightSlidePadding,
                                                                      style.rightSlideThickness,
                                                                      CGRectGetHeight(frame)-2*style.rightSlidePadding)];
        self.rightSlideVeiw.backgroundColor = [UIColor grayColor];
        [self addSubview:self.rightSlideVeiw];
        
        self.style = style;
        
    
    }
    return self;
}

- (void)setStyle:(SlideButtonStyle)style{

    _style = style;
    self.topSlideVeiw.hidden = !style.topSlide;
    self.leftSlideVeiw.hidden = !style.leftSlide;
    self.bottomSlideVeiw.hidden = !style.bottomSlide;
    self.rightSlideVeiw.hidden = !style.rightSlide;

}

@end
