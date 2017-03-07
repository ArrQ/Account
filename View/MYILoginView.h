//
//  MYILoginView.h
//  MaYi
//
//  Created by 张志峰 on 2016/12/9.
//  Copyright © 2016年 zhifenx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MYILoginView : UIView
@property (nonatomic, strong) UITextField *userNameTextField;
@property (nonatomic, strong) UITextField *passwordTextField;
@property (nonatomic, strong) UIButton *loginButton;
@property (nonatomic, strong) UIButton *vcodeButton;

/**
 注册蚂蚁
 */
@property (nonatomic, copy) void(^ registerBlock) ();

/**
 修改密码
 */
@property (nonatomic, copy) void(^ changePasswordBlock) ();

/**
 登录
 */
@property (nonatomic, copy) void(^ loginBlock) (NSString *userName, NSString *password);
- (void)setUpVcodeButtonEnabled:(BOOL)enabled
                          title:(NSString *)title
                          color:(UIColor *)color
                          state:(UIControlState)state;


@end
