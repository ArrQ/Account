//
//  MYILoginViewController.h
//  MaYi
//
//  Created by 张志峰 on 2016/12/9.
//  Copyright © 2016年 zhifenx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MYILoginViewController : UIViewController

@property (nonatomic, copy) void(^ loginSuccessBlock) (NSString *userName);

@end
