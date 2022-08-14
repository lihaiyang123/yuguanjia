//
//  PreviewAttachmentViewController.m
//  YuGuanJia
//
//  Created by ggzj on 2021/8/7.
//

#import <WebKit/WebKit.h>
#import <WKWebViewJavascriptBridge.h>

#import "PreviewAttachmentViewController.h"

@interface PreviewAttachmentViewController () <WKUIDelegate, WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, copy) NSString *urlString;
@property (nonatomic, copy) NSString *navTitleString;
@end

@implementation PreviewAttachmentViewController

- (instancetype)initWithNavName:(NSString *)navName
                  withURLString:(NSString *)urlString {
    self = [super init];
    if (self) {
        _urlString = urlString;
        _navTitleString = navName;
    }
    return self;
}
#pragma mark - Life Cycle Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initSubviews];
}
#pragma mark - Intial Methods
- (void)initSubviews {
    
    if (self.navTitleString.length == 0) {
        self.title = @"附件预览";
    }
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.equalTo(self.view);
        }
    }];
}
#pragma mark - Network Methods

#pragma mark - Events

#pragma mark - Public Methods

#pragma mark - Private Method

#pragma mark - External Delegate
#pragma mark - WKUIDelegate ,WKNavigationDelegate
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    
}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    
}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    
    YDZYLog(@"加载出现错误:  %@", [error localizedDescription]);
}
// 解决内存占用过大白屏
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView {
    
    [webView reload];
}
#pragma mark - WKUIDelegate

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    
    //js 里面的alert实现，如果不实现，网页的alert函数无效
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }]];
    [self presentViewController:alertController animated:YES completion:^{}];
}
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler {
    //  js 里面的alert实现，如果不实现，网页的alert函数无效  ,
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
        completionHandler(false);
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        completionHandler(true);
    }]];
    [self presentViewController:alertController animated:YES completion:^{}];
}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString *))completionHandler
{
    //用于和JS交互，弹出输入框
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:prompt message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
        completionHandler(nil);
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UITextField *textField = alertController.textFields.firstObject;
        completionHandler(textField.text);
    }]];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = defaultText;
    }];
    [self presentViewController:alertController animated:true completion:NULL];
}

#pragma mark – Getters and Setters
- (WKWebView *)webView {
    if (!_webView) {
        _webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:[WKWebViewConfiguration new]];
        _webView.scrollView.showsVerticalScrollIndicator = false;
        [_webView setOpaque:false]; //解决iOS9.2以上黑边问题
        _webView.multipleTouchEnabled = true;//关闭多点触控
        _webView.navigationDelegate = self;
        _webView.UIDelegate = self;
        _webView.scrollView.bounces = false;
        _webView.backgroundColor = [UIColor clearColor];
        if (@available(iOS 11.0, *)){
            _webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:_urlString]];
        [_webView loadRequest:request];
    }
    return _webView;
}
@end
