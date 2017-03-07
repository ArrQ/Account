//
//  MYIRegisterViewController.m
//  MaYi
//
//  Created by 张志峰 on 2016/12/9.
//  Copyright © 2016年 zhifenx. All rights reserved.
//

#import "MYIRegisterViewController.h"

#import "MYIRegisterView.h"
#import "JFWeakTimerTargetObject.h"
#import "JFConfigFile.h"
#import "MYILoginViewController.h"

#import "MYILoginView.h"

@interface MYIRegisterViewController ()

@property (nonatomic, strong) MYIRegisterView *registerView;
@property (nonatomic, strong) MYILoginView *loginView;

/** 计时器*/
@property (nonatomic, strong) NSTimer *countdownTimer;
/** 计时器总时间*/
@property (nonatomic, assign) NSInteger totalTime;

@end

@implementation MYIRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customRightBarButtonItem];
}

- (void)loadView {
    [super loadView];
    [self.view addSubview:self.registerView];
}



//
- (MYIRegisterView *)registerView {
    if (!_registerView) {
        _registerView = [[MYIRegisterView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _registerView.backgroundColor = [UIColor whiteColor];
        
        //请求注册验证码
        __weak typeof(self) weakSelf = self;
        
        //注册
        _registerView.clickedregisterButtonBlock = ^(NSString *userName, NSString *password, NSString *vcode) {
            MYILoginViewController *logVC = [[MYILoginViewController alloc]init];
           weakSelf.loginView.userNameTextField.text = userName;
          weakSelf.loginView.passwordTextField.text = password;
            UINavigationController *naVC = [[UINavigationController alloc]initWithRootViewController:logVC];
            
            [weakSelf presentViewController:naVC animated:YES completion:^{
                
            }];
            
        };
    }
    return _registerView;
}

// 右按钮
- (void)customRightBarButtonItem {
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    [rightButton addTarget:self action:@selector(backrootTableViewController) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setImage:[UIImage imageNamed:@"return_item"] forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
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
    [_registerView setUpVcodeButtonEnabled:NO title:totalTimeString color:[UIColor grayColor] state:UIControlStateNormal];
    if (_totalTime == 0) {
        [self removeTimer];
        [_registerView setUpVcodeButtonEnabled:YES title:@"获取验证码" color:[UIColor redColor] state:UIControlStateNormal];
    }
}

/// 销毁计时器
- (void)removeTimer {
    [self.countdownTimer invalidate];
    self.countdownTimer = nil;
}

- (void)dealloc {
    JFLog(@"销毁定时器");
    [self removeTimer];
}

- (void)backrootTableViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
