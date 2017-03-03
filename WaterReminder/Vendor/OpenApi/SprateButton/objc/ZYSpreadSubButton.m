//
//  SpreadSubButton.m
//  SpreadButton
//
//  Created by lzy on 16/2/4.
//  Copyright © 2016年 lzy. All rights reserved.
//

#import "ZYSpreadSubButton.h"

@implementation ZYSpreadSubButton

- (instancetype)initWithBackgroundImage:(UIImage *)backgroundImage highlightImage:(UIImage *)highlightImage andTitle:(NSString *)title  clickedBlock:(ButtonClickBlock)buttonClickBlock {
    
    NSAssert(backgroundImage != nil, @"background can not be nil");
    
    self = [super init];
    if (self) {
        [self configureButtonWithBackgroundImage:backgroundImage highlightImage:highlightImage andTitle:title  clickedBlock:buttonClickBlock];
    }
    return self;
}

- (void)configureButtonWithBackgroundImage:(UIImage *)backgroundImage highlightImage:(UIImage *)highlightImage andTitle:(NSString *)title  clickedBlock:(ButtonClickBlock)buttonClickBlock {
    if (backgroundImage != nil) {
        
        [self setBackgroundImage:backgroundImage forState:UIControlStateNormal];
        
        CGRect buttonFrame = CGRectMake(0, 0, 45, 45);
        [self setTitle:title forState:UIControlStateNormal];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self setFrame:buttonFrame];
    }
    
    if (highlightImage != nil) {
        [self setBackgroundImage:highlightImage forState:UIControlStateHighlighted];
    }
    self.buttonClickBlock = buttonClickBlock;
}

- (ButtonClickBlock)buttonClickBlock {
    return _buttonClickBlock;
}

 + (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f); //宽高 1.0只要有值就够了
    UIGraphicsBeginImageContext(rect.size); //在这个范围内开启一段上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);//在这段上下文中获取到颜色UIColor
    CGContextFillRect(context, rect);//用这个颜色填充这个上下文
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();//从这段上下文中获取Image属性,,,结束
    UIGraphicsEndImageContext();
    
    return image;
}


@end
