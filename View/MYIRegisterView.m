//
//  MYIRegisterView.m
//  MaYi
//
//  Created by 张志峰 on 2016/12/9.
//  Copyright © 2016年 zhifenx. All rights reserved.
//

#import "MYIRegisterView.h"

#import "JFConfigFile.h"
#import "Masonry.h"
#import "MBProgressHUD+JFProgressHUD.h"

@interface MYIRegisterView ()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *userNameTextField;
@property (nonatomic, strong) UITextField *vcodeTextField;
@property (nonatomic, strong) UITextField *passwordTextField;
@property (nonatomic, strong) UITextField *confirmPasswordTextField;
@property (nonatomic, strong) UIButton *registerButton;
@property (nonatomic, strong) UIButton *vcodeButton;

@end

@implementation MYIRegisterView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self customUI];
        [self changRegisterBtnState];
        
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
    // 获取验证码 View
    UIButton *vcodeButton = [[UIButton alloc] init];
    vcodeButton.titleLabel.font = [UIFont systemFontOfSize:12.0];
    [vcodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [vcodeButton setTitleColor:KMainBodyColor forState:UIControlStateNormal];
    [vcodeButton addTarget:self action:@selector(vcodeButtonEvent:) forControlEvents:UIControlEventTouchDown];
    [self addSubview:vcodeButton];
    
//    self.vcodeButton = vcodeButton;
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
    
    //registerButton 注册 按钮
    UIButton *registerButton = [[UIButton alloc] init];
    registerButton.backgroundColor = KMainBodyColor;
    registerButton.layer.cornerRadius = 3;
    registerButton.layer.masksToBounds = YES;
    [registerButton setTitle:@"注册" forState:UIControlStateNormal];
    [registerButton setTitleColor:JFRGBAColor(251, 251, 251, 0.5) forState:UIControlStateNormal];
    [registerButton setEnabled:NO];
    [registerButton addTarget:self action:@selector(registerButtonEvent:) forControlEvents:UIControlEventTouchDown];
    [self addSubview:registerButton];
    
    [registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(JFSCREEN_WIDTH - 80);//宽
        make.height.offset(44);// 高
        // 距离 确认密码 40 高度
        make.top.equalTo(_confirmPasswordTextField.mas_bottom).offset(40);
        // 在 中间
        make.centerX.equalTo(self.mas_centerX);
    }];
    self.registerButton = registerButton;
    
}
// TextField 的 封装view
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

// TextField 的 封装约束
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

//  封装的 分割线
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



#pragma mark-events
//获取验证码 点击 事件
- (void)vcodeButtonEvent:(UIButton *)sender {
    if ([self myi_isPhoneNumber]) {
        if (self.clickedVcodeButtonBlock) {
            self.clickedVcodeButtonBlock(_userNameTextField.text);
        }
    }else {
        [MBProgressHUD myi_promptHudWithShowHUDAddedTo:self message:@"手机号码错误！"];
    }
}

//注册 点击 响应事件
- (void)registerButtonEvent:(UIButton *)sender {
    if ([self myi_isTextFieldEmpty]) {
        [MBProgressHUD myi_promptHudWithShowHUDAddedTo:self message:@"各项不能为空哦！"];
    }else if(![self myi_isPhoneNumber]) {
        [MBProgressHUD myi_promptHudWithShowHUDAddedTo:self message:@"手机号码错误！"];
    }else if ([_passwordTextField.text isEqualToString:_confirmPasswordTextField.text]) {
        if (self.clickedregisterButtonBlock) {
            self.clickedregisterButtonBlock(_userNameTextField.text, _passwordTextField.text, _vcodeTextField.text);
        }
    }else {
        [MBProgressHUD myi_promptHudWithShowHUDAddedTo:self message:@"密码不一致！"];
    }
}

#pragma mark - 判断
//textField是否有空
- (BOOL)myi_isTextFieldEmpty {
    NSString *userName = _userNameTextField.text;
    NSString *vcode = _vcodeTextField.text;
    NSString *passwordText = _passwordTextField.text;
    NSString *confirmPasswordText = _confirmPasswordTextField.text;
    return [self validateNumber:userName regex:@"^.{0}$"] ||
    [self validateNumber:vcode regex:@"^.{0}$"] ||
    [self validateNumber:passwordText regex:@"^.{0}$"] ||
    [self validateNumber:confirmPasswordText regex:@"^.{0}$"];
}

//所有textField都为空
- (BOOL)myi_isAllTextFieldsEmpty {
    NSString *userName = _userNameTextField.text;
    NSString *vcode = _vcodeTextField.text;
    NSString *passwordText = _passwordTextField.text;
    NSString *confirmPasswordText = _confirmPasswordTextField.text;
    return [self validateNumber:userName regex:@"^.{0}$"] &&
    [self validateNumber:vcode regex:@"^.{0}$"] &&
    [self validateNumber:passwordText regex:@"^.{0}$"] &&
    [self validateNumber:confirmPasswordText regex:@"^.{0}$"];
}
// 手机号是否存在
- (BOOL)myi_isPhoneNumber {
    return [self validateNumber:_userNameTextField.text regex:@"^1[3|4|5|7|8][0-9]\\d{8}$"];
}

// 正则表达式
- (BOOL)validateNumber:(NSString *)textString regex:(NSString *)regexString {
    NSString *regex = regexString;
    NSPredicate *numberPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [numberPredicate evaluateWithObject:textString];
}


//封装 设置验证码按钮状态
- (void)setUpVcodeButtonEnabled:(BOOL)enabled
                          title:(NSString *)title
                          color:(UIColor *)color
                          state:(UIControlState)state {
    [_vcodeButton setEnabled:enabled];
    [_vcodeButton setTitleColor:color forState:UIControlStateNormal];
    [_vcodeButton setTitle:title forState:state];
}

// 监听注册按钮的状态
- (void)changRegisterBtnState{

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(myi_UITextFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
}

//  设置注册按钮状态
- (void)myi_UITextFieldTextDidChange:(UITextField *)textField {
    //设置注册按钮状态 白色
    if ([self myi_isTextFieldEmpty]) {
        [self.registerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.registerButton setEnabled:YES];
    }
    // 都为空的时候  显示 灰色 = 不能注册
    if ([self myi_isAllTextFieldsEmpty]) {
        [self.registerButton setTitleColor:JFRGBAColor(251, 251, 251, 0.5) forState:UIControlStateNormal];
        [self.registerButton setEnabled:NO];
    }
}




@end
