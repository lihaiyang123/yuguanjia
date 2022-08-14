

#import "YJYMeAboutUSVC.h"

@interface YJYMeAboutUSVC ()
///导航栏高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nacHeight;
///版本号
@property (weak, nonatomic) IBOutlet UILabel *visionLabel;
@property (weak, nonatomic) IBOutlet UIButton *agrementButton;
@end

@implementation YJYMeAboutUSVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initUI];
}

#pragma mark - initUI

- (void)initUI {
    
    self.title = @"关于御管家";
    //获取版本号
    self.visionLabel.text = [NSString stringWithFormat:@"版本 V%@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
}

#pragma mark  - action

- (IBAction)showAgrementAction:(UIButton *)sender {
    NSInteger index = sender.tag - 8000;
    switch (index) {
        case 0:{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[YGJSetUp getAgrementUrl]]];
        }
            break;
            
        default:{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[YGJSetUp getPrivacyUrl]]];
        }
            break;
    }
    
}

#pragma mark  - 设置状态栏颜色

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}


@end
