

#import <UIKit/UIKit.h>

@interface MYILoginViewController : UIViewController

@property (nonatomic, copy) void(^ loginSuccessBlock) (NSString *userName);

@end
