//
//  LuckySheetViewController.m
//  YuGuanJia
//
//  Created by ggzj on 2021/7/26.
//
#import <WebKit/WebKit.h>
#import <WKWebViewJavascriptBridge.h>

#import "LuckySheetViewController.h"
#import "PreviewAttachmentViewController.h"

#import "YGJDocumentsApi.h"
#import "LuckysheetImagePicker.h"

#define YGJHTMLBUNDLE  [NSBundle bundleWithPath: [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: @"html.bundle"]]
//#define  DOWNLOAD_EXCEL(data)   [NSString stringWithFormat:@"downloadExcel('%@')", data]

@interface LuckySheetViewController () <WKUIDelegate, WKNavigationDelegate, LuckysheetImagePickerDelegate, UIDocumentInteractionControllerDelegate>

@property (nonatomic, readwrite, strong) WKWebView *webView;
@property WKWebViewJavascriptBridge* bridge;

@property (nonatomic, copy) NSString *idString;
@property (nonatomic, assign) ExcelStauts status;
// 是否是模版 false 不是、true 是
//@property (nonatomic, assign) BOOL isTemplate;
@property (nonatomic, strong) NSString *tempContent;
@property (nonatomic, assign) int tempType;
@property (nonatomic, copy) NSString *tempName;

@property (nonatomic, strong) QMUIButton *moreBtn;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) QMUIButton *saveBtn;
@property (nonatomic, strong) LuckysheetImagePicker *imagePicker;
@property (nonatomic, strong) QMUIPopupMenuView *popupByWindow;
@property (nonatomic, strong) UIDocumentInteractionController *documentInteractionController;

@end

@implementation LuckySheetViewController

#pragma mark - Life Cycle Methods
- (instancetype)initWithDict:(NSDictionary *)infoDict wthStatus:(ExcelStauts)status {
    if (self = [super init]) {
        self.idString = [NSString stringWithFormat:@"%@", infoDict[@"id"]];
        self.tempContent = infoDict[@"tempContent"];
        self.tempName = infoDict[@"tempName"];
        self.tempType = [infoDict[@"tempType"] intValue];

        self.status = status;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initSubviews];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}
- (UIInterfaceOrientationMask)deviceOrientationMask {
    return  UIInterfaceOrientationMaskAllButUpsideDown;
}
#pragma mark - Intial Methods
- (void)initSubviews {
    self.title = (self.status == ExcelStautsDocunment) ? @"单据详情" : @"模版详情";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.moreBtn];
    self.popupByWindow.sourceView = self.moreBtn;

    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_offset(kScale_W(60));
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.equalTo(self.view);
        }
    }];

    [self.bottomView addSubview:self.saveBtn];
    [self.saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_offset(kScale_W(45));
        make.centerY.equalTo(self.bottomView);
        make.left.equalTo(self.bottomView).mas_offset(kScale_W(12.5));
        make.right.equalTo(self.bottomView).mas_offset(kScale_W(-12.5));
    }];
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
    [self registerNativeFunctions];
}
- (void)registerNativeFunctions {
    
    if (!_bridge) {
        [WKWebViewJavascriptBridge enableLogging];
        self.bridge = [WKWebViewJavascriptBridge bridgeForWebView:self.webView];
        [self.bridge setWebViewDelegate:self];
    }
    @weakify(self);
    //data[@"filePath"]
    [_bridge registerHandler:@"previewAttachmentFile" handler:^(id data, WVJBResponseCallback responseCallback) {
        @strongify(self);
        NSString *dataUrl = @"";
        if([data isKindOfClass:[NSDictionary class]]) {
            if([data objectForKey:@"filePath"]) {
                dataUrl = data[@"filePath"];
            }
        } else if ([data isKindOfClass:[NSArray class]]) {
            dataUrl = data[0];
        } else {
            dataUrl = data;
        }
        
        [self.navigationController pushViewController:[[PreviewAttachmentViewController alloc] initWithNavName:@"" withURLString:dataUrl] animated:true];
    }];
}
#pragma mark - Network Methods
- (void)saveExcel:(NSString *)filePath tempContent:(NSString *)tempContent {
    @weakify(self);
    
    NSMutableDictionary *paramsMuta = [NSMutableDictionary dictionaryWithDictionary:@{@"id": self.idString, @"previewUrl": filePath, @"tempContent": tempContent}];
    if (self.status == ExcelStautsDocunment) {
        [YGJDocumentsApi requestDocumentsEdit:paramsMuta success:^(UDAResponseDataModel *model) {
            
            @strongify(self);
//            [self.navigationController popViewControllerAnimated:true];
            [self.navigationController popToRootViewControllerAnimated:true];
        } error:nil];
        return;
    }
    
    [paramsMuta jk_setObj:@(self.tempType).stringValue forKey:@"tempType"];
    [paramsMuta jk_setObj:self.idString forKey:@"id"];
    if (self.status == ExcelStautsTemplateEdit) {
        [paramsMuta jk_setObj:self.tempName forKey:@"tempName"];
        [YGJDocumentsApi requestTemplatesEdit:paramsMuta success:^(UDAResponseDataModel *model) {
            
            @strongify(self);
//            [self.navigationController popViewControllerAnimated:true];
//            self.navigationController.tabBarController.selectedIndex = 0;
            [self.navigationController popToRootViewControllerAnimated:true];
        } error:nil];
        return;
    }
    
    [YGJDocumentsApi requestTemplatesCustomSave:paramsMuta success:^(UDAResponseDataModel *model) {
        
        @strongify(self);
//        [self.navigationController popViewControllerAnimated:true];
        [self.navigationController popToRootViewControllerAnimated:true];
    } error:nil];
}
- (void)uploadSreenshots:(UIImage *)img tempContent:(NSString *)tempContent {
    
    
    NSArray *imageArr = [NSArray arrayWithObject:img];
    @weakify(self);
    [UDAAPIRequest uploadImagesUrl:@"/image/uploadImg" parameters:nil name:@"file" images:imageArr fileNames:nil imageScale:1 imageType:@"png" progressBlock:^(CGFloat value) {
    } completeBlock:^(UDAResponseDataModel * _Nonnull requestModel) {
    
        @strongify(self);
        [SVProgressHUD dismiss];
        if (requestModel.success) {
//            [SVProgressHUD show];
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [SVProgressHUD dismiss];
                [self saveExcel:requestModel.result[@"filePath"] tempContent:tempContent];
//            });
        }
    } errorBlock:^(NSError * _Nullable error) {
        [SVProgressHUD dismiss];
    }];
}
#pragma mark - Events
- (void)moreButtonEvent {
    [self.popupByWindow showWithAnimated:true];
}
- (void)saveButtonEvent:(UIButton *)btn {
    @weakify(self);
    // 保存excel
    [self.bridge callHandler:@"saveFile" data:@{} responseCallback:^(id responseData) {
        
        @strongify(self);
        [SVProgressHUD show];
        NSString *base64Str = [NSString stringWithFormat:@"%@", responseData[@"base64"]];
        NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:base64Str]];
        [self uploadSreenshots:[UIImage imageWithData:imgData] tempContent:responseData[@"tempContent"]];
    }];
}
#pragma mark - Public Methods

#pragma mark - Private Method
- (void)uploadAttachment {
    @weakify(self);
    [self.bridge callHandler:@"uploadAttachment" data:@{} responseCallback:^(id responseData) {
        
        @strongify(self);
        [self.imagePicker openImagePicker];
    }];
}
// 导出excel
- (void)exportExcel {
    @weakify(self);
    BOOL isTemplates = NO;
    if (self.status == ExcelStautsTemplateEdit || self.status == ExcelStautsTemplateCustom) {
        isTemplates = YES;
    }
    [YGJDocumentsApi requestExport:isTemplates id:self.idString success:^(UDAResponseDataModel *model) {
        
        @strongify(self);
        if (model.success) {
            [self startDownload:model.result[@"filePath"]];
        } else {
            [YGJToast showToast:model.message];
        }
    } error:nil];
}
- (void)startDownload:(NSString *)downloadUrl {
    @weakify(self);
    [UDAAPIRequest downloadUrl:downloadUrl fileDir:@"YGJDownload" progressBlock:^(CGFloat value) {
    } completeBlock:^(NSURL * _Nonnull filePath) {
        
        @strongify(self);
        self.documentInteractionController = [UIDocumentInteractionController
                                          interactionControllerWithURL:filePath];
        self.documentInteractionController.delegate = self;
        [self.documentInteractionController presentOpenInMenuFromRect:self.view.bounds inView:self.view animated:true];
    } errorBlock:^(NSError * _Nullable error) {
        [YGJToast showToast:@"文件导出失败"];
    }];
}
#pragma mark - External Delegate

#pragma mark - LuckysheetImagePickerDelegate
- (void)uploadAttachmentSuccess:(NSString *)filePath {
    // 附件上传成功
    [self.bridge callHandler:@"handleUploadFileSuccess" data:@{@"filePath" : filePath} responseCallback:^(id responseData) {
    }];
}

#pragma mark - WKUIDelegate ,WKNavigationDelegate
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    
}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    
}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
    BOOL allowEdit = (self.status == ExcelStautsDocunmentNonEditable) ? false : true;
    [self.bridge callHandler:@"initData" data:@{@"tempContent": self.tempContent, @"allowEdit": @(allowEdit)} responseCallback:^(id responseData) {
        
    }];
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

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString *))completionHandler {
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
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL fileURLWithPath:[YGJHTMLBUNDLE pathForResource:@"Excel/index" ofType:@"html"]]];
//        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://192.168.10.147:8080/"]];
        [_webView loadRequest:request];
    }
    return _webView;
}
- (QMUIButton *)moreBtn {
    if (!_moreBtn) {
        _moreBtn = [[QMUIButton alloc] qmui_initWithImage:nil title:@"更多"];
        _moreBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_moreBtn addTarget:self action:@selector(moreButtonEvent) forControlEvents:UIControlEventTouchUpInside];
        [_moreBtn setTitleColor:UIColorMakeWithHex(@"#FFFFFF") forState:UIControlStateNormal];
//        _editBtn.spacingBetweenImageAndTitle = 6.0;
        _moreBtn.titleLabel.font = UIFontBoldMake(16);
//        _editBtn.imagePosition = QMUIButtonImagePositionRight;
        _moreBtn.frame = CGRectMake(0, 0, 60, 40);
    }
    return _moreBtn;
}
- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectZero];
        _bottomView.backgroundColor = [UIColor whiteColor];
    }
    return _bottomView;
}
- (QMUIButton *)saveBtn {
    if (!_saveBtn) {
        _saveBtn = [QMUIButton buttonWithType:UIButtonTypeCustom];
        [_saveBtn setTitle:@"保存" forState:UIControlStateNormal];
        _saveBtn.backgroundColor = UIColorMakeWithHex(@"#4581EB");
        _saveBtn.titleLabel.font = UIFontBoldMake(18);
        _saveBtn.layer.cornerRadius = kScale_W(22.5);
        [_saveBtn setTitleColor:UIColorMakeWithHex(@"#FFFFFF") forState:UIControlStateNormal];
        [_saveBtn addTarget:self action:@selector(saveButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saveBtn;
}
- (LuckysheetImagePicker *)imagePicker {
    if (!_imagePicker) {
        _imagePicker = [[LuckysheetImagePicker alloc] initWithDelegate:self];
    }
    return _imagePicker;
}
- (QMUIPopupMenuView *)popupByWindow {
    if (!_popupByWindow) {
        _popupByWindow = [[QMUIPopupMenuView alloc] init];
        _popupByWindow.automaticallyHidesWhenUserTap = true;// 点击空白地方消失浮层
        _popupByWindow.tintColor = UIColorMakeWithHex(@"#333333");
        _popupByWindow.maskViewBackgroundColor = [UIColor clearColor];
        _popupByWindow.shouldShowItemSeparator = true;
        _popupByWindow.minimumWidth = 123;
        _popupByWindow.maximumHeight = 262;
        _popupByWindow.itemConfigurationHandler = ^(QMUIPopupMenuView *aMenuView, QMUIPopupMenuButtonItem *aItem, NSInteger section, NSInteger index) {
            // 利用 itemConfigurationHandler 批量设置所有 item 的样式
            aItem.button.titleLabel.font = UIFontMake(15);
            [aItem.button setTitleColor:UIColorMakeWithHex(@"#333333") forState:UIControlStateNormal];
            aItem.button.highlightedBackgroundColor = UIColorMakeWithHex(@"#EEEEEE");
        };
        @weakify(self);
        
        NSMutableArray *itemsMutaArray = [NSMutableArray arrayWithArray:@[[QMUIPopupMenuButtonItem itemWithImage:nil title:@"导出" handler:^(QMUIPopupMenuButtonItem *aItem) {
            
            @strongify(self);
            [self exportExcel];
            [aItem.menuView hideWithAnimated:true];
        }]]];
        if (self.status == ExcelStautsDocunment) {
            
            [itemsMutaArray addObject: [QMUIPopupMenuButtonItem itemWithImage:nil title:@"上传附件" handler:^(QMUIPopupMenuButtonItem *aItem) {
                
                @strongify(self);
                [self uploadAttachment];
                [aItem.menuView hideWithAnimated:true];
            }]];
        }
        _popupByWindow.items = itemsMutaArray;
        _popupByWindow.didHideBlock = ^(BOOL hidesByUserTap) {
        };
    }
    return _popupByWindow;;
}
@end
