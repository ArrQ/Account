//
//  MYIChangePasswordView.m
//  MaYi
//
//  Created by 张志峰 on 2016/12/22.
//  Copyright © 2016年 zhifenx. All rights reserved.
//

#import "MYIChangePasswordView.h"

#import "JFConfigFile.h"
#import "Masonry.h"
#import "MBProgressHUD+JFProgressHUD.h"

@interface MYIChangePasswordView ()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *userNameTextField;
@property (nonatomic, strong) UITextField *vcodeTextField;
@property (nonatomic, strong) UITextField *passwordTextField;
@property (nonatomic, strong) UITextField *confirmPasswordTextField;
@property (nonatomic, strong) UIButton *compliteButton;
@property (nonatomic, strong) UIButton *vcodeButton;

@end

@implementation MYIChangePasswordView

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
    self.userNameTextField = [self MYITextField:@"手机号"
                                  isSecureEntry:NO];
    
    [self masonryTextField:_userNameTextField superView:loginLogoImageView width:(JFSCREEN_WIDTH - 60)];
    
    //separator
    [self separatorView:_userNameTextField];
    
    //vcodeTextField
    self.vcodeTextField = [self MYITextField:@"验证码"
                               isSecureEntry:NO];
    [self masonryTextField:_vcodeTextField superView:_userNameTextField width:(JFSCREEN_WIDTH - 140)];
    
    UIButton *vcodeButton = [[UIButton alloc] init];
    vcodeButton.titleLabel.font = [UIFont systemFontOfSize:12.0];
    [vcodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [vcodeButton setTitleColor:KMainBodyColor forState:UIControlStateNormal];
    [vcodeButton addTarget:self action:@selector(vcodeButtonEvent:) forControlEvents:UIControlEventTouchDown];
    [self addSubview:vcodeButton];
    self.vcodeButton = vcodeButton;
    
    [vcodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(80);
        make.height.offset(21);
        make.left.equalTo(_vcodeTextField.mas_right);
        make.centerY.equalTo(_vcodeTextField.mas_centerY);
    }];
    
    //separator
    [self separatorView:_vcodeTextField];
    
    //passwordTextField
    self.passwordTextField = [self MYITextField:@"密码"
                                  isSecureEntry:YES];
    [self masonryTextField:_passwordTextField superView:_vcodeTextField width:(JFSCREEN_WIDTH - 60)];
    //separator
    [self separatorView:_passwordTextField];
    
    
    //confirmPasswordTextField
    self.confirmPasswordTextField = [self MYITextField:@"确认密码"
                                         isSecureEntry:YES];
    [self masonryTextField:_confirmPasswordTextField superView:_passwordTextField width:(JFSCREEN_WIDTH - 60)];
    
    //separator
    [self separatorView:_confirmPasswordTextField];
    
    //registerButton
    UIButton *compliteButton = [[UIButton alloc] init];
    compliteButton.backgroundColor = KMainBodyColor;
    compliteButton.layer.cornerRadius = 3;
    compliteButton.layer.masksToBounds = YES;
    [compliteButton setTitle:@"修改密码" forState:UIControlStateNormal];
    [compliteButton setTintColor:KMainBodyColor];
    [compliteButton setTitleColor:JFRGBAColor(251, 251, 251, 0.5) forState:UIControlStateNormal];
    [compliteButton addTarget:self action:@selector(registerButtonEvent:) forControlEvents:UIControlEventTouchDown];
    [compliteButton setEnabled:NO];
    [self addSubview:compliteButton];
    
    [compliteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(JFSCREEN_WIDTH - 80);
        make.height.offset(44);
        make.top.equalTo(_confirmPasswordTextField.mas_bottom).offset(40);
        make.centerX.equalTo(self.mas_centerX);
    }];
    self.compliteButton = compliteButton;
    
}

- (UITextField *)MYITextField:(NSString *)placeholder
                isSecureEntry:(BOOL)isSecureEntry {
    UITextField *MYITextField = [[UITextField alloc] init];
    MYITextField.delegate = self;
    MYITextField.placeholder = placeholder;
    MYITextField.clearButtonMode = UITextFieldViewModeAlways;
    MYITextField.secureTextEntry = isSecureEntry;
    [self addSubview:MYITextField];
    return MYITextField;
}

- (void)masonryTextField:(UITextField *)textField
               superView:(UIView *)superView
                   width:(CGFloat)width{
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(width);
        make.height.offset(44);
        make.top.equalTo(superView.mas_bottom).offset(20);
        make.left.equalTo(self.mas_left).offset(30);
    }];
}

- (void)separatorView:(UITextField *)textField {
    UIView *separatorView = [[UIView alloc] init];
    separatorView.backgroundColor = JFRGBColor(199, 199, 205);
    [self addSubview:separatorView];
    
    [separatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(JFSCREEN_WIDTH - 60);
        make.height.offset(0.7);
        make.top.equalTo(textField.mas_bottom);
        make.centerX.equalTo(self.mas_centerX);
    }];
}

//获取验证码 点击事件
- (void)vcodeButtonEvent:(UIButton *)sender {
    if ([self validateNumber:_userNameTextField.text regex:@"^1[3|4|5|7|8][0-9]\\d{8}$"]) {
        if (self.clickedVcodeButtonBlock) {
            self.clickedVcodeButtonBlock(_userNameTextField.text);
        }
    }else {
        [MBProgressHUD myi_promptHudWithShowHUDAddedTo:self message:@"手机号码错误！"];
    }
}

//修改密码
- (void)registerButtonEvent:(UIButton *)sender {
    NSString *userName = _userNameTextField.text;
    NSString *vcode = _vcodeTextField.text;
    NSString *passwordText = _passwordTextField.text;
    NSString *confirmPasswordText = _confirmPasswordTextField.text;
    if ([self validateNumber:userName regex:@"^.{0}$"] ||
        [self validateNumber:vcode regex:@"^.{0}$"] ||
        [self validateNumber:passwordText regex:@"^.{0}$"] ||
        [self validateNumber:confirmPasswordText regex:@"^.{0}$"]) {
        [MBProgressHUD myi_promptHudWithShowHUDAddedTo:self message:@"各项不能为空哦！"];
    }else if (![passwordText isEqualToString:confirmPasswordText]) {
        [MBProgressHUD myi_promptHudWithShowHUDAddedTo:self message:@"密码不一致！"];
    }else {
        if (self.clickedCompliteButtonBlock) {
            self.clickedCompliteButtonBlock(userName, passwordText, vcode);
        }
    }
}

/// 正则表达式（判断手机号等正确性）
- (BOOL)validateNumber:(NSString *)textString regex:(NSString *)regexString {
    NSString *regex = regexString;
    NSPredicate *numberPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [numberPredicate evaluateWithObject:textString];
}

//设置验证码按钮状态
- (void)setUpVcodeButtonEnabled:(BOOL)enabled
                          title:(NSString *)title
                          color:(UIColor *)color
                          state:(UIControlState)state {
    [_vcodeButton setEnabled:enabled];
    [_vcodeButton setTitle:title forState:state];
    [_vcodeButton setTitleColor:color forState:UIControlStateNormal];
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

- (void)myi_UITextFieldTextDidChange:(UITextField *)textField {
    //设置注册按钮状态
    if ([self myi_isTextFieldEmpty]) {
        [self.compliteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.compliteButton setEnabled:YES];
    }
    if ([self myi_isAllTextFieldsEmpty]) {
        [self.compliteButton setTitleColor:JFRGBAColor(251, 251, 251, 0.5) forState:UIControlStateNormal];
        [self.compliteButton setEnabled:NO];
    }
}
@end
