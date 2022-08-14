//
//  AboutViewController.m
//  YuGuanJia
//
//  Created by Yang on 2021/7/1.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关于御管家";
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F2F4F5"];
    [self createUI];
}

- (void)createUI {
    
    UIImageView *logoImageView = [[UIImageView alloc] init];
//    logoImageView.backgroundColor = KBlueColor;
    logoImageView.image = [UIImage imageNamed:@"AppIcon"];
    logoImageView.contentMode = UIViewContentModeScaleAspectFit;
    logoImageView.frame = CGRectMake((kScreenWidth-120)/2.0, 31, 120, 120);
    logoImageView.layer.masksToBounds = YES;
    logoImageView.layer.cornerRadius = 60;
    [self.view addSubview:logoImageView];
    
    UITextView *text = [[UITextView alloc] init];
    text.frame = CGRectMake(0, logoImageView.bottom+29, KScreenWidth, 180);
    text.font = SYSTEMFONT(16);
    text.textColor = CBlackgColor;
    text.text = @"版本信息: 0.8.1\n"
    "御管家，是商品制造产业链整体协作解决方案;\n"
    "御管家，是围绕供应链单据为中心流转的整体服务，坚持 匠心，不忘 中国工业精神;\n"
    "御管家，将全身心服务于制造业商 户，肩负行 业使命，不忘初心;\n"
    "御管家，致力于让工业协作更轻松更快乐。\n"
    "御管家隐私政策\n"
    "正文。。。。。\n"
    "御管家用户协议\n"
    "正文。。。\n";
    [self.view addSubview:text];
}
@end
