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



- (instancetype)initWithFrame:(CGRect)frame SlideButtonStyle:(SlideButtonStyle) style andColor:(nonnull UIColor *)color{
    self = [super initWithFrame:frame];
    if(self){
        self.topSlideVeiw = [[UIView alloc]initWithFrame:CGRectMake(style.slidePadding,
                                                                    0,
                                                                    CGRectGetWidth(frame)-2*style.slidePadding,
                                                                    style.slideThickness)];
        self.topSlideVeiw.backgroundColor = color;
        [self addSubview:self.topSlideVeiw];
        
        self.leftSlideVeiw = [[UIView alloc]initWithFrame:CGRectMake(0,
                                                                     style.slidePadding,
                                                                     style.slideThickness,
                                                                     CGRectGetHeight(frame)-2*style.slidePadding)];
        self.leftSlideVeiw.backgroundColor = color;
        [self addSubview:self.leftSlideVeiw];
        
        self.bottomSlideVeiw = [[UIView alloc]initWithFrame:CGRectMake(style.slidePadding,
                                                                       CGRectGetHeight(frame)-style.slideThickness,
                                                                       CGRectGetWidth(frame)-2*style.slidePadding,
                                                                       style.slideThickness)];
        self.bottomSlideVeiw.backgroundColor = color;
        [self addSubview:self.bottomSlideVeiw];
        
        self.rightSlideVeiw = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetWidth(frame)-style.slideThickness,
                                                                      style.slidePadding,
                                                                      style.slideThickness,
                                                                      CGRectGetHeight(frame)-2*style.slidePadding)];
        self.rightSlideVeiw.backgroundColor = color;
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
