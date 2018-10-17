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
    
    CGFloat topSlidePadding;
    CGFloat leftSlidePadding;
    CGFloat bottomSlidePadding;
    CGFloat rightSlidePadding;
    
    CGFloat topSlideThickness;
    CGFloat leftSlideThickness;
    CGFloat bottomSlideThickness;
    CGFloat rightSlideThickness;
}SlideButtonStyle;

static SlideButtonStyle slideButtonStyleDefault = {YES,YES,YES,YES,0,0,0,0,1,1,1,1};

@interface SlideLineButton : UIButton

@property (nonatomic) SlideButtonStyle style;
- (instancetype)initWithFrame:(CGRect)frame SlideButtonStyle:(SlideButtonStyle) style;
@end

NS_ASSUME_NONNULL_END
