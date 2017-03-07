//
//  MYILoginView.m
//  MaYi
//
//  Created by 张志峰 on 2016/12/9.
//  Copyright © 2016年 zhifenx. All rights reserved.
//

#import "MYILoginView.h"

#import "Masonry.h"
#import "JFConfigFile.h"
#import "MBProgressHUD+JFProgressHUD.h"

@interface MYILoginView ()<UITextFieldDelegate>


@end

@implementation MYILoginView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self customUI];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(myi_UITextFieldTextDidChange:)
                                                     name:UITextFieldTextDidChangeNotification
                                                   object:nil];
    }
    return self;
}

- (void)customUI {
    //loginImageView
    UIImageView *loginLogoImageView = [[UIImageView alloc] init];
    loginLogoImageView.image = [UIImage imageNamed:@"login_logo"];
    [self addSubview:loginLogoImageView];
    
    [loginLogoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(110);
        make.height.offset(32);
        make.top.equalTo(self.mas_top).offset(100);
        make.centerX.equalTo(self.mas_centerX);
    }];
    
    //userNameTextField
    UITextField *userNameTextField = [[UITextField alloc] init];
    userNameTextField.delegate = self;
    userNameTextField.placeholder = @"手机号";
    userNameTextField.clearButtonMode = UITextFieldViewModeAlways;
    [self addSubview:userNameTextField];
    
    [userNameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(JFSCREEN_WIDTH - 60);
        make.height.offset(44);
        make.top.equalTo(loginLogoImageView.mas_bottom).offset(30);
        make.centerX.equalTo(self.mas_centerX);
    }];
    self.userNameTextField = userNameTextField;
    
    //separator
    UIView *separatorView_u = [[UIView alloc] init];
    separatorView_u.backgroundColor = JFRGBColor(199, 199, 205);
    [self addSubview:separatorView_u];
    
    [separatorView_u mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(JFSCREEN_WIDTH - 60);
        make.height.offset(0.7);
        make.top.equalTo(userNameTextField.mas_bottom).offset(0);
        make.centerX.equalTo(self.mas_centerX);
    }];
    
    //passwordTextField
    UITextField *passwordTextField = [[UITextField alloc] init];
    passwordTextField.delegate = self;
    passwordTextField.placeholder = @"密码";
    passwordTextField.secureTextEntry = YES;
    passwordTextField.clearButtonMode = UITextFieldViewModeAlways;
    [self addSubview:passwordTextField];
    
    [passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(JFSCREEN_WIDTH - 60);
        make.height.offset(44);
        make.top.equalTo(userNameTextField.mas_bottom).offset(20);
        make.left.equalTo(userNameTextField.mas_left);
    }];
    self.passwordTextField = passwordTextField;
    
    //separator
    UIView *separatorView_p = [[UIView alloc] init];
    separatorView_p.backgroundColor = JFRGBColor(199, 199, 205);
    [self addSubview:separatorView_p];
    
    [separatorView_p mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(JFSCREEN_WIDTH - 60);
        make.height.offset(0.7);
        make.top.equalTo(passwordTextField.mas_bottom).offset(0);
        make.centerX.equalTo(self.mas_centerX);
    }];
    
    //loginButton
    UIButton *loginButton = [[UIButton alloc] init];
    loginButton.backgroundColor = KMainBodyColor;
    loginButton.layer.cornerRadius = 3;
    loginButton.layer.masksToBounds = YES;
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [loginButton setEnabled:NO];
    [loginButton setTitleColor:JFRGBAColor(251, 251, 251, 0.5) forState:UIControlStateNormal];
    [loginButton setTintColor:KMainBodyColor];
    
    [loginButton addTarget:self action:@selector(loginButtonEvent:) forControlEvents:UIControlEventTouchDown];
    [self addSubview:loginButton];
    
    [loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(JFSCREEN_WIDTH - 80);
        make.height.offset(44);
        make.top.equalTo(passwordTextField.mas_bottom).offset(40);
        make.centerX.equalTo(self.mas_centerX);
    }];
    self.loginButton = loginButton;
    
    
    //FinderPasswordButton
    UIButton *finderPasswordButton = [[UIButton alloc] init];
    finderPasswordButton.titleLabel.font = [UIFont systemFontOfSize:12.0];
    [finderPasswordButton setTitle:@"忘记密码？" forState:UIControlStateNormal];
    [finderPasswordButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [finderPasswordButton addTarget:self action:@selector(presentChangePasswordView) forControlEvents:UIControlEventTouchDown];
    [self addSubview:finderPasswordButton];
    
    [finderPasswordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(80);
        make.height.offset(21);
        make.top.equalTo(loginButton.mas_bottom).offset(15);
        make.right.equalTo(loginButton.mas_right);
    }];
    
    //registerButton
    UIButton *registerButton = [[UIButton alloc] init];
    [registerButton setTitle:@"注册账号" forState:UIControlStateNormal];
    registerButton.titleLabel.font = [UIFont systemFontOfSize:12.0];
    [registerButton setTitleColor:KMainBodyColor forState:UIControlStateNormal];
    [registerButton addTarget:self action:@selector(presentRegisterView) forControlEvents:UIControlEventTouchDown];
    [self addSubview:registerButton];
    
    [registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(80);
        make.height.offset(21);
        make.top.equalTo(loginButton.mas_bottom).offset(15);
        make.left.equalTo(loginButton.mas_left);
    }];
}

- (void)presentRegisterView {
    if (self.registerBlock) {
        self.registerBlock();
    }
}

- (void)presentChangePasswordView {
    if (self.changePasswordBlock) {
        self.changePasswordBlock();
    }
}


//textField是否有空
- (BOOL)myi_isTextFieldEmpty {
    NSString *userName = _userNameTextField.text;
    NSString *passwordText = _passwordTextField.text;
    return [self validateNumber:userName regex:@"^.{0}$"] ||
    [self validateNumber:passwordText regex:@"^.{0}$"];
}

//所有textField都为空
- (BOOL)myi_isAllTextFieldsEmpty {
    NSString *userName = _userNameTextField.text;
    NSString *passwordText = _passwordTextField.text;
    return [self validateNumber:userName regex:@"^.{0}$"] &&
    [self validateNumber:passwordText regex:@"^.{0}$"];
}

- (BOOL)myi_isPhoneNumber {
    return [self validateNumber:_userNameTextField.text regex:@"^1[3|4|5|7|8][0-9]\\d{8}$"];
}

/// 正则表达式
- (BOOL)validateNumber:(NSString *)textString regex:(NSString *)regexString {
    NSString *regex = regexString;
    NSPredicate *numberPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [numberPredicate evaluateWithObject:textString];
}

- (void)myi_UITextFieldTextDidChange:(UITextField *)textField {
    //设置注册按钮状态
    if ([self myi_isTextFieldEmpty]) {
        [self.loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.loginButton setEnabled:YES];
    }
    if ([self myi_isAllTextFieldsEmpty]) {
        [self.loginButton setTitleColor:JFRGBAColor(251, 251, 251, 0.5) forState:UIControlStateNormal];
        [self.loginButton setEnabled:NO];
    }
}

- (void)loginButtonEvent:(UIButton *)sender {
    if (self.loginBlock) {
        NSString *userName = _userNameTextField.text;
        NSString *password = _passwordTextField.text;
        self.loginBlock(userName, password);
    }
}

//设置验证码按钮状态
- (void)setUpVcodeButtonEnabled:(BOOL)enabled
                          title:(NSString *)title
                          color:(UIColor *)color
                          state:(UIControlState)state {
    [_vcodeButton setEnabled:enabled];
    [_vcodeButton setTitleColor:color forState:UIControlStateNormal];
    [_vcodeButton setTitle:title forState:state];
}


@end
