//
//  FeedBackViewController.m
//  YuGuanJia
//
//  Created by Yang on 2021/7/1.
//

#import "FeedBackViewController.h"

@interface FeedBackViewController ()<UITextViewDelegate>
@property (nonatomic, strong) UITextView *inputContentTV;
@end

@implementation FeedBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F2F4F5"];
    self.title = @"用户反馈";
    [self createBar];
    [self createUI];
}
#pragma mark - 设置导航栏
- (void)createBar {
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(10.0, 0.0, 44.0, 44.0);
    [rightButton addTarget:self action:@selector(rightButtonOnClicked) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setTitle:@"提交" forState:UIControlStateNormal];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 44.0, 44.0)];
    [view addSubview:rightButton];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:view];
    self.navigationItem.rightBarButtonItem = rightItem;
    
}

- (void)createUI {
    
    UIView *bigView = [[UIView alloc] init];
    bigView.frame = CGRectMake(0, 12, kScreenWidth, 180);
    bigView.backgroundColor = KWhiteColor;
    [self.view addSubview:bigView];

    self.inputContentTV = [[UITextView alloc] init];
    self.inputContentTV.frame = CGRectMake(12.5f, 15, KScreenWidth-25, 150);
    self.inputContentTV.font = SYSTEMFONT(15);
    self.inputContentTV.delegate = self;
    self.inputContentTV.textColor = CBlackgColor;
    self.inputContentTV.layer.borderColor = [UIColor colorWithHexString:@"#EEEEEE"].CGColor;
    self.inputContentTV.layer.borderWidth = 1;
    
    UILabel *placeholderLabel = [[UILabel alloc] init];
    placeholderLabel.text = @"请输入您的反馈";
    placeholderLabel.font = [UIFont systemFontOfSize:14];
    placeholderLabel.textColor = [UIColor colorWithHexString:@"999999"];
    placeholderLabel.numberOfLines = 0;
    [placeholderLabel sizeToFit];
    [self.inputContentTV addSubview:placeholderLabel];
    //runtime的做法
    [self.inputContentTV setValue:placeholderLabel forKey:@"_placeholderLabel"];
    [bigView addSubview:self.inputContentTV];
    
    
    UILabel *zishuLabel = [[UILabel alloc] init];
    zishuLabel.frame = CGRectMake(KScreenWidth-24-15-87, 126, 100, 13);
    zishuLabel.text = @"限制300字以内";
    zishuLabel.font = [UIFont systemFontOfSize:13];
    zishuLabel.textColor = [UIColor colorWithHexString:@"999999"];
    [self.inputContentTV addSubview:zishuLabel];
    
}


- (void)rightButtonOnClicked {
    
    if ([NSString isBlankString:_inputContentTV.text]) {
        [YGJToast showToast:@"意见内容不能为空"];
        return;
    }
    NSDictionary *dic = [NSDictionary dictionaryWithObject:self.inputContentTV.text forKey:@"feedbackDesc"];
    
    @weakify(self);
    [UDAAPIRequest requestUrl:@"/app/userFeedback/add" parameter:@{@"userFeedback":dic} requestType:UDARequestTypePost isShowHUD:YES progressBlock:^(CGFloat value) {
        
        
    } completeBlock:^(UDAResponseDataModel * _Nonnull requestModel) {
        
        @strongify(self);
        if (requestModel.success) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"FEEDBACK-SUCCESS" object:nil];
            [self.navigationController popViewControllerAnimated:YES];
            
        }
        
    } errorBlock:^(NSError * _Nullable error) {
        
    }];

}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    YDZYLog(@"textLength == %ld",textView.text.length);
    if ([textView isFirstResponder]) {
        
        if ([[[textView textInputMode] primaryLanguage] isEqualToString:@"emoji"] || ![[textView textInputMode] primaryLanguage]) {
            return NO;
        }
        //判断键盘是不是九宫格键盘
        if ([[MethodManager sharedMethodManager] isNineKeyBoard:text] ){
                return YES;
        }else{
            if ([[MethodManager sharedMethodManager] hasEmoji:text] || [[MethodManager sharedMethodManager] stringContainsEmoji:text]){
                
                [YGJToast showToast:@"不支持输入表情"];
                return NO;
            }
        }
    }
    if (textView.text.length + text.length > 300) {
        NSString *allText = [NSString stringWithFormat:@"%@%@",textView.text,text];
        textView.text = [allText substringToIndex:300];
        [YGJToast showToast:@"最多输入300个字"];
        return NO;
    }
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    [self.view endEditing:YES];
}

@end
