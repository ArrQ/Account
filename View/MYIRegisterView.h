//
//  MYIRegisterView.h
//  MaYi
//
//  Created by 张志峰 on 2016/12/9.
//  Copyright © 2016年 zhifenx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MYIRegisterView : UIView

/**
 获取验证码的回调
 */
@property (nonatomic, copy) void(^ clickedVcodeButtonBlock) (NSString *userName);

/**
 点击注册按钮的回调
 */
@property (nonatomic, copy) void(^ clickedregisterButtonBlock) (NSString *userName, NSString *password, NSString *vcode);

/**
 设置验证码状态

 @param enabled 可否点击
 @param title 按钮名称
 @param color 按钮文字颜色
 @param state 按钮形式
 */
- (void)setUpVcodeButtonEnabled:(BOOL)enabled
                          title:(NSString *)title
                          color:(UIColor *)color
                          state:(UIControlState)state;
@end
