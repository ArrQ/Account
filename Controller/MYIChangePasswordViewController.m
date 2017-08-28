
#import "MYIChangePasswordViewController.h"

#import "MYIChangePasswordView.h"
#import "JFWeakTimerTargetObject.h"
#import "MYILoginViewController.h"

@interface MYIChangePasswordViewController ()

@property (nonatomic, strong) MYIChangePasswordView *changePasswordView;
/** 计时器*/
@property (nonatomic, strong) NSTimer *countdownTimer;
/** 计时器总时间*/
@property (nonatomic, assign) NSInteger totalTime;

@end

@implementation MYIChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customRightBarButtonItem];
}

- (void)loadView {
    [super loadView];
    [self.view addSubview:self.changePasswordView];
}

- (MYIChangePasswordView *)changePasswordView {
    if (!_changePasswordView) {
        _changePasswordView = [[MYIChangePasswordView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _changePasswordView.backgroundColor = [UIColor whiteColor];
        
        //请求验证码
        __weak typeof(self) weakSelf = self;
        _changePasswordView.clickedVcodeButtonBlock = ^(NSString *userName) {
            
            
        
        };
        
        //修改密码
        _changePasswordView.clickedCompliteButtonBlock = ^(NSString *userName, NSString *password, NSString *vcode) {
            
            MYILoginViewController *lonVC = [[MYILoginViewController alloc]init];
            
            UINavigationController *naVC = [[UINavigationController alloc]initWithRootViewController:lonVC];
            
            [weakSelf presentViewController:naVC animated:YES completion:^{
                
            }];
            
            
            
        };
    }
    return _changePasswordView;
}

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
    [_changePasswordView setUpVcodeButtonEnabled:NO
                                           title:totalTimeString
                                           color:[UIColor grayColor]
                                           state:UIControlStateNormal];
    if (_totalTime == 0) {
        [self removeTimer];
        [_changePasswordView setUpVcodeButtonEnabled:YES
                                               title:@"获取验证码"
                                               color:[UIColor whiteColor]
                                               state:UIControlStateNormal];
    }
}

/// 销毁计时器
- (void)removeTimer {
    [self.countdownTimer invalidate];
    self.countdownTimer = nil;
}

- (void)backrootTableViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (void)dealloc {
    NSLog(@"销毁定时器");
    [self removeTimer];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
