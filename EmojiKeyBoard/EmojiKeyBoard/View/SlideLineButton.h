//
//  SlideLineButton.h
//  EmojiKeyBoard
//
//  Created by zou on 2018/10/15.
//  Copyright © 2018年 zou. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef struct ButtonStyle {
    BOOL topSlide;
    BOOL leftSlide;
    BOOL bottomSlide;
    BOOL rightSlide;

    CGFloat slidePadding;
    CGFloat slideThickness;
}SlideButtonStyle;

static SlideButtonStyle slideButtonStyleDefault = {YES,YES,YES,YES,0,1};
static SlideButtonStyle slideButtonStyleLeft = {NO,YES,NO,NO,5,1};
static SlideButtonStyle slideButtonStyleRight = {NO,NO,NO,YES,5,1};
static SlideButtonStyle slideButtonStyleBottom = {NO,NO,YES,NO,5,1};
static SlideButtonStyle slideButtonStyleTop = {YES,NO,NO,NO,5,1};

@interface SlideLineButton : UIButton

@property (nonatomic) SlideButtonStyle style;
- (instancetype)initWithFrame:(CGRect)frame SlideButtonStyle:(SlideButtonStyle) style andColor:(UIColor *)color;
@end

NS_ASSUME_NONNULL_END
