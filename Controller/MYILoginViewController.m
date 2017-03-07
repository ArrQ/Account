//
//  MYILoginViewController.m
//  MaYi
//
//  Created by 张志峰 on 2016/12/9.
//  Copyright © 2016年 zhifenx. All rights reserved.
//

#import "MYILoginViewController.h"
#import "YSTabBarVC.h"
#import "MYIRegisterViewController.h"
#import "MYILoginView.h"
#import "MYIChangePasswordViewController.h"
#import "JFConfigFile.h"
#import "ZEPDataManager.h"
#import "JFWeakTimerTargetObject.h"

#define kUSERDEFAULTS [NSUserDefaults standardUserDefaults] //用户信息单例

@interface MYILoginViewController ()

@property (nonatomic, strong) MYILoginView *loginView;
//@property (nonatomic, strong) MYIAccountInfoAFHttpTool *manager;
/** 计时器*/
@property (nonatomic, strong) NSTimer *countdownTimer;
/** 计时器总时间*/
@property (nonatomic, assign) NSInteger totalTime;
@end

@implementation MYILoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)loadView {
    [super loadView];
    [self.view addSubview:self.loginView];
}

- (MYILoginView *)loginView {
    if (!_loginView) {
        _loginView = [[MYILoginView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _loginView.backgroundColor = [UIColor whiteColor];
        
        __weak typeof(self) weakSelf = self;
        //注册账号 跳转到  注册页面
        _loginView.registerBlock = ^{
            MYIRegisterViewController *registerViewController = [[MYIRegisterViewController alloc] init];
            registerViewController.title = @"注册账号";
            
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:registerViewController];
            [weakSelf presentViewController:nav animated:YES completion:nil];
        };
    
        //登录 点击 进入 登录 页面  tabbar 页面
        _loginView.loginBlock = ^(NSString *userName, NSString *password) {
            [[ZEPDataManager sharedZEPDataManager] dm_login:userName
                                                   password:password
                                                    success:^(id response) {
                                                        //用户账号
                                                        [kUSERDEFAULTS setObject:userName forKey:@"userName"];
                                                        //用户昵称
                                                        [kUSERDEFAULTS setObject:[response valueForKey:@"username"]
                                                                          forKey:@"username"];
                                                        [kUSERDEFAULTS setObject:password
                                                                          forKey:@"password"];
                                                   
                                                        
                                                        [kUSERDEFAULTS setObject:[response valueForKey:@"cyb_ep"]
                                                                          forKey:@"cyb_ep"];
                                                        
                                                        [kUSERDEFAULTS setObject:[response valueForKey:@"shop_ep"]
                                                                          forKey:@"shop_ep"];
                                                        [kUSERDEFAULTS setObject:[response valueForKey:@"shop_preep"]
                                                                          forKey:@"shop_preep"];
                                                        [kUSERDEFAULTS setObject:[response valueForKey:@"isshopmaster"] forKey:@"isshopmaster"];
                                                        
                                                        
                                                        [UIApplication sharedApplication].delegate.window.rootViewController = [[YSTabBarVC alloc] init];
                                                    }
                                                    failure:^(NSError *err) {
                                                        
                                                    }];
        };
        
        //忘记密码 点击 跳转到 修改密码页面
        _loginView.changePasswordBlock = ^() {
            MYIChangePasswordViewController *changePasswordViewController = [[MYIChangePasswordViewController alloc] init];
            changePasswordViewController.title = @"修改密码";
            
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:changePasswordViewController];
            [weakSelf presentViewController:nav animated:YES completion:nil];
        };
    }
    return _loginView;
}


/// 打开验证码计时器
- (void)openCountdownTimer {
    _totalTime = 60;
    self.countdownTimer = [JFWeakTimerTargetObject scheduledTimerWithTimeInterval:1.0
                                                                           target:self
                                                                         selector:@selector(timeFireMethod:)
                                                                         userInfo:nil
                                                                          repeats:YES];
}

/// 计时器执行方法
- (void)timeFireMethod:(id)sender {
    _totalTime --;
    NSString *totalTimeString = [[NSString alloc] initWithFormat:@"%lds",_totalTime];
    [_loginView setUpVcodeButtonEnabled:NO title:totalTimeString color:[UIColor grayColor] state:UIControlStateNormal];
    if (_totalTime == 0) {
        [self removeTimer];
        [_loginView setUpVcodeButtonEnabled:YES title:@"获取验证码" color:[UIColor redColor] state:UIControlStateNormal];
    }
}

/// 销毁计时器
- (void)removeTimer {
    [self.countdownTimer invalidate];
    self.countdownTimer = nil;
}

- (void)dealloc {
    JFLog(@"控制器销毁");
    [self removeTimer];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
